import Orion
import StellaC

class NCNotificationShortLookViewControllerHook: ClassHook<NCNotificationShortLookViewController> {
    typealias Group = Notifications

    @Property(.nonatomic, .retain) var snowEmitterLayer: CAEmitterLayer? = nil

    @Property(.nonatomic, .retain) var currentBounds: CGRect = .zero
    @Property(.nonatomic, .retain) var uniqueID: String = ""

    @Property(.nonatomic, .retain) var manager = StellaManager.shared

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)

        if target.view.layer.sublayers?.contains(where: { $0 is CAEmitterLayer }) == true { return }

        if uniqueID.isEmpty {
            uniqueID = UUID().uuidString
        }

        let snowEmitterLayer = manager.getEmitterLayer(withBounds: target.view.bounds, uniqueID: uniqueID)

        target.view.layer.addSublayer(snowEmitterLayer!)
    }

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if (!CGRectEqualToRect(target.view.bounds, currentBounds)) {
            currentBounds = target.view.bounds
            snowEmitterLayer?.emitterSize = CGSizeMake(currentBounds.size.width * 0.9, 0)
            snowEmitterLayer?.emitterPosition = CGPoint(x: currentBounds.midX, y: -30)
        }
    }
}