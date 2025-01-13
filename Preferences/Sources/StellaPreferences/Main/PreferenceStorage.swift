import Foundation
import Comet
import libroot

final class PreferenceStorage: ObservableObject {
    static var shared = PreferenceStorage()
    private static let registry: String = jbRootPath("/var/mobile/Library/Preferences/com.yan.stella.prefs.plist")

    @Published(key: "enabled", registry: registry) var isEnabled = true
    @Published(key: "lockscreen", registry: registry) var lockscreen = true
    @Published(key: "homescreen", registry: registry) var homescreen = true

    @Published(key: "lockscreenSnowColor", registry: registry) var lockscreenSnowColor = "FFFFFF"
    @Published(key: "lockscreenSpawnRate", registry: registry) var lockscreenSpawnRate = 30.0
    @Published(key: "lockscreenSnowSpeed", registry: registry) var lockscreenSnowSpeed = 30.0
    @Published(key: "lockscreenSnowWind", registry: registry) var lockscreenSnowWind = 0.0
    @Published(key: "lockscreenCustomImageEnabled", registry: registry) var lockscreenCustomImageEnabled = false
    @Published(key: "lockscreenCustomImageData", registry: registry) var lockscreenCustomImageData = Data()

    @Published(key: "lockscreenCustomImageSize", registry: registry) var lockscreenCustomImageSize = 10.0

    @Published(key: "notifications", registry: registry) var notifications = true
    @Published(key: "musicPlayer", registry: registry) var musicPlayer = true

    @Published(key: "homescreenSnowColor", registry: registry) var homescreenSnowColor = "FFFFFF"
    @Published(key: "homescreenSpawnRate", registry: registry) var homescreenSpawnRate = 30.0
    @Published(key: "homescreenSnowSpeed", registry: registry) var homescreenSnowSpeed = 30.0
    @Published(key: "homescreenSnowWind", registry: registry) var homescreenSnowWind = 0.0
    @Published(key: "homescreenCustomImageEnabled", registry: registry) var homescreenCustomImageEnabled = false
    @Published(key: "homescreenCustomImageData", registry: registry) var homescreenCustomImageData = Data()
    @Published(key: "homescreenCustomImageSize", registry: registry) var homescreenCustomImageSize = 10.0


    @Published(key: "homescreenSnowBehindIcons", registry: registry) var homescreenSnowBehindIcons  = true
    @Published(key: "homescreenDockEnabled", registry: registry) var homescreenDockEnabled = true
}
