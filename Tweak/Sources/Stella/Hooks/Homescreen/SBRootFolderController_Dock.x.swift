import Orion
import StellaC

class SBRootFolderController_DockHook: ClassHook<SBRootFolderController> {
    typealias Group = iOSDock

    @Property(.nonatomic, .retain) var dockEmitterLayer: CAEmitterLayer? = nil
    @Property(.nonatomic, .retain) var dockBounds: CGRect = .zero
    
    func viewDidLoad() {
        orig.viewDidLoad()

        setupDockSnowLayer()
    }

    // orion: new
    func setupDockSnowLayer() {
        if let dockView = target.dockIconListView?.superview {
            dockEmitterLayer = SnowFactory.createStaticSnowEmitterLayer()
            guard let dockEmitterLayer = dockEmitterLayer else { return }

            dockView.layer.addSublayer(dockEmitterLayer)
            StellaManager.shared.dockEmitterLayer = dockEmitterLayer
        }
    }

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if let dockView = target.dockIconListView?.superview {
            if (!CGRectEqualToRect(dockView.bounds, dockBounds)) {
                dockBounds = dockView.bounds
                dockEmitterLayer?.emitterSize = CGSizeMake(dockBounds.size.width * 0.8, 0)
                dockEmitterLayer?.emitterPosition = CGPoint(x: dockBounds.midX, y: 0)
            }
        }
    }
}