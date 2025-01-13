import SwiftUI

struct HomescreenView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage

    var body: some View {
        Form {
            generalSection
            homescreenSettingsSection
            homescreenSnowSpeedSection
            homescreenSnowWindSection
            miscellaneousSection
            linkToCustomImage
        }
        .navigationTitle("Homescreen")
    }

    var generalSection: some View {
        Section() {
            Toggle("Enable", isOn: $preferenceStorage.homescreen)
        }
    }

    var homescreenSettingsSection: some View {
        Section(header: Text("homescreen Settings")) {
            ColorPicker("Color", selection: Binding<Color>(
                get: { Color(hex: preferenceStorage.homescreenSnowColor) },
                set: { color in 
                    preferenceStorage.homescreenSnowColor = color.toHex()
                }
            ))
            HStack {
                Text("Spawn Rate")
                Slider(value: $preferenceStorage.homescreenSpawnRate, in: 1...80, step: 1)
                Text("\(Int(preferenceStorage.homescreenSpawnRate))")
            }
            
        }
    }

    var homescreenSnowSpeedSection: some View {
        Section(header: Text("Snow speed")) {
            Picker("Snow Speed", selection: $preferenceStorage.homescreenSnowSpeed) {
                Text("Very slow").tag(5.0)
                Text("Slow").tag(18.0)
                Text("Normal").tag(30.0)
                Text("Fast").tag(90)
                Text("Snowstorm").tag(350.0)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    var homescreenSnowWindSection: some View {
        Section(header: Text("Snow wind")) {
            HStack {
                Slider(value: $preferenceStorage.homescreenSnowWind, in: -25.0...25.0, step: 1.0)
                Text("\(Int(preferenceStorage.homescreenSnowWind))")
            }
        }
    }

    var miscellaneousSection: some View {
        Section(header: Text("Miscellaneous")) {
            // Toggle to switch between having the snow fall behind or in front of the icons
            Toggle("Snow behind icons", isOn: $preferenceStorage.homescreenSnowBehindIcons)
            Toggle("Snow on dock", isOn: $preferenceStorage.homescreenDockEnabled)
        }
    }

    var linkToCustomImage: some View {
        Section() {
            NavigationLink("Custom Image") {
                CustomImageView(storageKey: .homescreen)
                    .environmentObject(preferenceStorage)
            }
        }
    }
}