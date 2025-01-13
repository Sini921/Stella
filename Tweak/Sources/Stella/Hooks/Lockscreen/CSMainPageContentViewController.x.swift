import Orion
import StellaC

class CSMainPageContentViewControllerHook: ClassHook<CSMainPageContentViewController> {
    typealias Group = Lockscreen

    @Property(.nonatomic, .retain) var snowEmitterLayer: CAEmitterLayer? = nil
    @Property(.nonatomic, .retain) var currentBounds: CGRect = .zero
    
    @Property(.nonatomic, .retain) var manager = StellaManager.shared

    func viewDidLoad() {
        orig.viewDidLoad()

        snowEmitterLayer = SnowFactory.createSnowEmitterLayer(configuration: manager.lockscreenConfig!)
        guard let snowEmitterLayer = snowEmitterLayer else { return }

        manager.lockscreenEmitterLayer = snowEmitterLayer
        
        target.view.layer.addSublayer(snowEmitterLayer)
    }

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        if manager.lockscreenPaused {
            manager.resumeAllLockscreenViews()
        }
    }

    func viewDidDisappear(_ animated: Bool) {
        orig.viewDidDisappear(animated)

        if !manager.lockscreenPaused {
            manager.pauseAllLockscreenViews()
        }
    }

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if (!CGRectEqualToRect(target.view.bounds, currentBounds)) {
            currentBounds = target.view.bounds
            snowEmitterLayer?.emitterSize = CGSizeMake(currentBounds.size.width, 0)
            snowEmitterLayer?.emitterPosition = CGPoint(x: currentBounds.midX, y: -30)
        }
    }
}