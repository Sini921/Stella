import Orion
import StellaC

class MRUCoverSheetViewControllerHook: ClassHook<MRUCoverSheetViewController> {
    typealias Group = OldMusicPlayer

    @Property(.nonatomic, .retain) var currentBounds: CGRect = .zero
    @Property(.nonatomic, .retain) var snowEmitterLayer: CAEmitterLayer? = nil
    
    func viewDidLoad() {
        orig.viewDidLoad()

        snowEmitterLayer = SnowFactory.createStaticSnowEmitterLayer()

        guard let snowEmitterLayer = snowEmitterLayer else { return }
        
        StellaManager.shared.musicEmitterLayer = snowEmitterLayer

        target.view.layer.addSublayer(snowEmitterLayer)
    }

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if (!CGRectEqualToRect(target.view.bounds, currentBounds)) {
            currentBounds = target.view.bounds
            snowEmitterLayer?.emitterSize = CGSizeMake(currentBounds.size.width * 0.9, 0)
            snowEmitterLayer?.emitterPosition = CGPoint(x: currentBounds.midX, y: 0)
        }
    }
}