import Orion
import StellaC

class SBLockScreenManagerHook: ClassHook<SBLockScreenManager> {
    typealias Group = Lockscreen

    @Property(.nonatomic, .retain) var manager = StellaManager.shared

    func lockUI(fromSource source: Int, withOptions options: Any?) {
        orig.lockUI(fromSource: source, withOptions: options)
        
        if !manager.lockscreenPaused {
            manager.pauseAllLockscreenViews()
        }
    }
} 
