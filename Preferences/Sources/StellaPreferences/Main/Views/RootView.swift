import SwiftUI
import libroot
import Comet

struct RootView: View {
    var onToggle: (() -> Void)?
    
    @StateObject private var preferenceStorage = PreferenceStorage()
    @State private var togglesNeedingRespring: Set<String> = []

    @State private var isExpanded: Bool = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .top) {
            Form {
                headerView
                generalSection
                customizationSection
                emptySection(height: 20.0)
                if isExpanded {
                    respringSection
                    creditSection
                    tweakSection
                }
                moreButton
            }
        }
    }

    private var headerView: some View {
        VStack {
            Spacer()
            VStack {
                Image(uiImage: UIImage(contentsOfFile: jbRootPath("/Library/PreferenceBundles/StellaPreferences.bundle/stella.png"))!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 5)
                Text("Stella")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("\(Constants.versionNumber) - \(Constants.social)")
                    .font(.footnote)
                    .fontWeight(.light)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .listRowInsets(EdgeInsets())
        .background(Color(UIColor.systemGroupedBackground))
    }

    private var generalSection: some View {
        Section(header: Text("General")) {
            Toggle("Enabled", isOn: $preferenceStorage.isEnabled).onChange(of: preferenceStorage.isEnabled) { newValue in
                handleToggleChange(toggleName: "Enabled")
            }.foregroundColor(preferenceStorage.isEnabled ? .primary : .secondary)
        }
    }

    private var customizationSection: some View {
        Section(header: Text("Customization")) {
            NavigationLink("Lockscreen") {
                LockscreenView().environmentObject(preferenceStorage)
            }.foregroundColor(preferenceStorage.isEnabled ? .primary : .secondary)

            NavigationLink("Homescreen") {
                HomescreenView().environmentObject(preferenceStorage)
            }.foregroundColor(preferenceStorage.isEnabled ? .primary : .secondary)
        }
        .disabled(!preferenceStorage.isEnabled)
    }

    private func emptySection(height: CGFloat) -> some View {
        Section {
            EmptyView()
                .frame(height: height)
        }
    }

    private var moreButton: some View {
        Section {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "Collapse" : "Credits & More")
                    .foregroundColor(.blue)
            }
        }
    }

    private var respringSection: some View {
        Section {
            Button("Respring") {
                Respring.execute()
            }.foregroundColor(togglesNeedingRespring.isEmpty ? .secondary : .primary)
        }
    }

    private var creditSection: some View {
        Section {
            CreditCell(imagePath: jbRootPath("/Library/PreferenceBundles/StellaPreferences.bundle/yan.png"), username: "yandevelop", description: "@yandevelop")
            LinkCell(title: "Donate", subtitle: "Support my work!", url: "https://ko-fi.com/yandevelop")
        }
    }

    private var tweakSection: some View {
        Section(header: Text("My other Tweaks")) {
            LinkCell(iconPath: jbRootPath("/Library/PreferenceBundles/StellaPreferences.bundle/tweaks/bloom@3x.png"), title: "Bloom", subtitle: "Animate your notifications with style", url: "sileo://package/com.yan.bloom", fallbackUrl: "https://havoc.app/package/bloom")
            LinkCell(iconPath: jbRootPath("/Library/PreferenceBundles/StellaPreferences.bundle/tweaks/fiona@3x.png"), title: "Fiona", subtitle: "Make your tab bar float", url: "sileo://package/com.yan.fiona", fallbackUrl: "https://havoc.app/package/fiona")
            LinkCell(iconPath: jbRootPath("/Library/PreferenceBundles/StellaPreferences.bundle/tweaks/ring@3x.png"), title: "Ring", subtitle: "Effortlessly control your ringer volume", url: "sileo://package/com.yan.ring", fallbackUrl: "https://havoc.app/package/ring")
        }
    }

    @inline(__always) private func handleToggleChange(toggleName: String) {
        let wasEmpty = togglesNeedingRespring.isEmpty

        if togglesNeedingRespring.contains(toggleName) {
            togglesNeedingRespring.remove(toggleName)
        } else {
            togglesNeedingRespring.insert(toggleName)
        }

        let isEmpty = togglesNeedingRespring.isEmpty

        if wasEmpty != isEmpty {
            onToggle?()
        }
    }
}
