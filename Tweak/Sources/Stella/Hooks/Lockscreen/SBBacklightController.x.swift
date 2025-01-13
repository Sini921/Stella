import Orion
import StellaC

class SBBacklightControllerHook: ClassHook<SBBacklightController> {
    typealias Group = Lockscreen

    @Property(.nonatomic, .retain) var manager = StellaManager.shared

    func turnOnScreenFully(withBacklightSource arg1: Int64) {
        orig.turnOnScreenFully(withBacklightSource: arg1)
        
        if manager.lockscreenPaused {
            manager.resumeAllLockscreenViews()
        }
    }
}