import Orion
import StellaC

struct Lockscreen: HookGroup{}
struct Homescreen: HookGroup{}
struct Notifications: HookGroup{}
struct OldMusicPlayer: HookGroup{}
struct NewMusicPlayer: HookGroup{}
struct iPadDock: HookGroup{}
struct iOSDock: HookGroup{}

struct SnowflakeConfiguration {
    var name: String = ""
    var particleColor: UIColor
    var particleBirthRate: CGFloat
    var particleSpeed: CGFloat
    var particleWind: CGFloat
}

final class Stella: Tweak {
    init() {
        if readPrefs(), StellaPreferences.shared.settings.enabled {
            guard let settings = StellaPreferences.shared.settings else { return }

            if settings.lockscreen {
                StellaManager.shared.lockscreenConfig = SnowflakeConfiguration(
                    name: "lockscreen",
                    particleColor: UIColor(hex: settings.lockscreenSnowColor),
                    particleBirthRate: CGFloat(settings.lockscreenSpawnRate),
                    particleSpeed: CGFloat(settings.lockscreenSnowSpeed),
                    particleWind: CGFloat(settings.lockscreenSnowWind)
                )

                Lockscreen().activate()
            }
            
            if settings.notifications {
                Notifications().activate()
            }

            if settings.musicPlayer {
                if #available(iOS 16, *) {
                    NewMusicPlayer().activate()
                } else {
                    OldMusicPlayer().activate()
                }
            }

            if !settings.homescreen { return }

            StellaManager.shared.homescreenConfig = SnowflakeConfiguration(
                name: "homescreen",
                particleColor: UIColor(hex: settings.homescreenSnowColor),
                particleBirthRate: CGFloat(settings.homescreenSpawnRate),
                particleSpeed: CGFloat(settings.homescreenSnowSpeed),
                particleWind: CGFloat(settings.homescreenSnowWind)
            )

            Homescreen().activate()
            
            if !StellaPreferences.shared.settings.homescreenDockEnabled { return }

            if UIDevice.current.model.contains("iPad") {
                iPadDock().activate()
            } else {
                iOSDock().activate()
            }
        }
    }

    private func readPrefs() -> Bool {
        do {
            try StellaPreferences.shared.loadSettings()
            return true
        } catch {
            print("Error reading prefs: \(error)")
        }
        return false
    }
}