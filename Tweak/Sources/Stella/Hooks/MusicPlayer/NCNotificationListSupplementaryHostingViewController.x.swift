import Orion
import StellaC

// This hook may seem redundant but it is necessary to ensure that the music player does not clip the snow particles (> iOS 16)
@available(iOS 16, *)
class NCNotificationListSupplementaryHostingViewControllerHook: ClassHook<NCNotificationListSupplementaryHostingViewController> {
    typealias Group = NewMusicPlayer

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        target.view.clipsToBounds = false
    }
}