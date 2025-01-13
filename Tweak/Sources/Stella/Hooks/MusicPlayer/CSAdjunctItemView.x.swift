import Orion
import StellaC

// This hook may seem redundant but it is necessary to ensure that the music player does not clip the snow particles (< iOS 16)
class CSAdjunctItemViewHook: ClassHook<CSAdjunctItemView> {
    typealias Group = NewMusicPlayer

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.clipsToBounds = false
    }
}