import SwiftUI

struct LockscreenView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage

    var body: some View {
        Form {
            generalSection
            lockscreenSettingsSection
            lockscreenSnowSpeedSection
            lockscreenSnowWindSection
            miscellaneousSection
            linkToCustomImage
        }
        .navigationTitle("Lockscreen")
    }

    var generalSection: some View {
        Section() {
            Toggle("Enable", isOn: $preferenceStorage.lockscreen)
        }
    }

    var lockscreenSettingsSection: some View {
        Section(header: Text("Lockscreen Settings")) {
            ColorPicker("Color", selection: Binding<Color>(
                get: { Color(hex: preferenceStorage.lockscreenSnowColor) },
                set: { color in 
                    preferenceStorage.lockscreenSnowColor = color.toHex()
                }
            ))
            HStack {
                Text("Spawn Rate")
                Slider(value: $preferenceStorage.lockscreenSpawnRate, in: 1...80, step: 1)
                Text("\(Int(preferenceStorage.lockscreenSpawnRate))")
            }
            
        }
    }

    var lockscreenSnowSpeedSection: some View {
        Section(header: Text("Snow speed")) {
            Picker("Snow Speed", selection: $preferenceStorage.lockscreenSnowSpeed) {
                Text("Very slow").tag(5.0)
                Text("Slow").tag(18.0)
                Text("Normal").tag(30.0)
                Text("Fast").tag(90.0)
                Text("Snowstorm").tag(350.0)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    var lockscreenSnowWindSection: some View {
        Section(header: Text("Snow wind")) {
            HStack {
                Slider(value: $preferenceStorage.lockscreenSnowWind, in: -25.0...25.0, step: 1.0)
                Text("\(Int(preferenceStorage.lockscreenSnowWind))")
            }
        }
    }

    var miscellaneousSection: some View {
        Section(header: Text("Miscellaneous")) {
            Toggle("Notifications", isOn: $preferenceStorage.notifications)
            Toggle("Music player", isOn: $preferenceStorage.musicPlayer)
        }
    }

    var linkToCustomImage: some View {
        Section() {
            NavigationLink("Custom Image") {
                CustomImageView(storageKey: .lockscreen)
                    .environmentObject(preferenceStorage)
            }
        }
    }
}
