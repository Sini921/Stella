import Foundation
import libroot

final class StellaPreferences {
    private(set) var settings: StellaSettings!
    static let shared = StellaPreferences()

    private let preferencesPath = jbRootPath("/var/mobile/Library/Preferences/com.yan.stella.prefs.plist")

    func loadSettings() throws {
        if let data = FileManager.default.contents(atPath: preferencesPath) {
            let decoder = PropertyListDecoder()
            settings = try decoder.decode(StellaSettings.self, from: data)
        } else {
            settings = StellaSettings()
        }
    }

    func saveSettings() throws {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(settings)
        try data.write(to: URL(fileURLWithPath: preferencesPath))
    }
}

final class StellaSettings: Codable {
    var enabled: Bool = true

    var lockscreen: Bool = true
    var homescreen: Bool = true

    // MARK: Lockscreen 
    var lockscreenSnowColor: String = "ffffff"
    var lockscreenSpawnRate: Float = 9.0
    var lockscreenSnowSpeed: Float = 50.0
    var lockscreenSnowWind: Float = 0.0

    var lockscreenCustomImageEnabled: Bool = false
    var lockscreenCustomImageData: Data = Data()
    var lockscreenCustomImageSize: Float = 10.0

    // MARK: Homescreen
    var homescreenSnowColor: String = "ffffff"
    var homescreenSpawnRate: Float = 9.0
    var homescreenSnowSpeed: Float = 50.0
    var homescreenSnowWind: Float = 0.0

    var homescreenCustomImageEnabled: Bool = false
    var homescreenCustomImageData: Data = Data()
    var homescreenCustomImageSize: Float = 10.0

    var homescreenSnowBehindIcons: Bool = true
    var homescreenDockEnabled: Bool = true
    
    // MARK: Miscellaneous
    var notifications: Bool = true
    var musicPlayer: Bool = true
}