import Orion
import StellaC

class SBRootFolderControllerHook: ClassHook<SBRootFolderController> {
    typealias Group = Homescreen

    @Property(.nonatomic, .retain) var snowEmitterLayer: CAEmitterLayer? = nil
    @Property(.nonatomic, .retain) var currentBounds: CGRect = .zero

    @Property(.nonatomic, .retain) var manager = StellaManager.shared

    func viewDidLoad() {
        orig.viewDidLoad()

        setupHomeSnowLayer()
    }

    // orion: new
    func setupHomeSnowLayer() {
        snowEmitterLayer = SnowFactory.createSnowEmitterLayer(configuration: StellaManager.shared.homescreenConfig!)

        guard let snowEmitterLayer = snowEmitterLayer else { return }

        target.view.layer.addSublayer(snowEmitterLayer)

        manager.homescreenEmitterLayer = snowEmitterLayer

        if StellaPreferences.shared.settings.homescreenSnowBehindIcons {
            target.view.layer.insertSublayer(snowEmitterLayer, at: 0)
        }
    }

    func viewWillDisappear(_ animated: Bool) {
        orig.viewWillDisappear(animated)

        manager.pauseHomescreenView()
    }

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        manager.resumeHomescreenView()
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