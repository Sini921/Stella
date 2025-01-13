import Orion
import StellaC

class SBFloatingDockViewControllerHook: ClassHook<SBFloatingDockViewController> {
    typealias Group = iPadDock

    @Property(.nonatomic, .retain) var dockEmitterLayer: CAEmitterLayer? = nil
    @Property(.nonatomic, .retain) var dockBounds: CGRect = .zero

    func viewDidLoad() {
        orig.viewDidLoad()

        setupDockSnowLayer()
    }

    // orion: new
    func setupDockSnowLayer() {
        guard let platterView = target.dockView.mainPlatterView else { return }

        dockEmitterLayer = SnowFactory.createStaticSnowEmitterLayer(withBounds: platterView.bounds)
        guard let dockEmitterLayer = dockEmitterLayer else { return }

        platterView.layer.addSublayer(dockEmitterLayer)
        StellaManager.shared.dockEmitterLayer = dockEmitterLayer
    }

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)

        if (!CGRectEqualToRect(target.dockView.mainPlatterView.bounds, dockBounds)) {
            dockBounds = target.dockView.mainPlatterView.bounds
            dockEmitterLayer?.emitterSize = CGSizeMake(dockBounds.size.width * 0.8, 0)
            dockEmitterLayer?.emitterPosition = CGPoint(x: dockBounds.midX, y: 0)
        }
    }
}