import Orion
import UIKit

class StellaManager {
    static let shared = StellaManager()

    internal var lockscreenEmitterLayer: CAEmitterLayer?
    internal var homescreenEmitterLayer: CAEmitterLayer?
    internal var musicEmitterLayer: CAEmitterLayer?
    internal var dockEmitterLayer: CAEmitterLayer?

    internal var lockscreenConfig: SnowflakeConfiguration?
    internal var homescreenConfig: SnowflakeConfiguration?

    private let poolQueue = DispatchQueue(label: "com.stella.emitterPool")
    internal var notificationEmitterLayers: [String: CAEmitterLayer] = [:]

    public var lastLookEnabled: Bool = false
    public var lockscreenPaused: Bool = false

    private init() {
        if NSClassFromString("LastLookManager") != nil {
            if let lastLookManager = Dynamic.LastLookManager.as(interface:LastLookManager.self).sharedInstance() as? LastLookManager {
                lastLookEnabled = Ivars<Bool>(lastLookManager)[safelyAccessing: "enabled"] ?? false
            }
        }

        Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.clearEmitterLayerPool()
        }
    }

    func pauseAllLockscreenViews() {
        pauseLockscreenView()
        pauseMusicView()
        pauseNotificationEmitterLayers()
    }

    func resumeAllLockscreenViews() {
        resumeLockscreenView()
        resumeMusicView()
        resumeNotificationEmitterLayers()
    }

    // MARK: - Notifications
    func clearEmitterLayerPool() {
        poolQueue.sync {
            notificationEmitterLayers.removeAll()
        }
    }

    func pauseNotificationEmitterLayers() {
        notificationEmitterLayers.forEach { _, layer in
            pauseEmitterLayer(layer)
        }
    }

    func resumeNotificationEmitterLayers() {
        notificationEmitterLayers.forEach { _, layer in
            resumeEmitterLayer(layer)
        }
    }

    // returns a cached (notification) emitter layer or creates a new one
    func getEmitterLayer(withBounds bounds: CGRect, uniqueID: String) -> CAEmitterLayer? {
        return poolQueue.sync {
            if let layer = notificationEmitterLayers[uniqueID] {
                layer.emitterSize = CGSize(width: bounds.size.width, height: 0)
                layer.emitterPosition = CGPoint(x: bounds.size.width / 2, y: 0)
                layer.lifetime = 5.0
                return layer
            } else {
                let newLayer = SnowFactory.createStaticSnowEmitterLayer(withBounds: bounds)
                newLayer.name = uniqueID
                notificationEmitterLayers[uniqueID] = newLayer
                return newLayer
            }
        }
    }

    func resumeEmitterLayer(_ layer: CAEmitterLayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0
        layer.beginTime = 0.0
        let timeSyncPause = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.beginTime = timeSyncPause - pausedTime

        if lastLookEnabled, layer.lifetime == 0.0 {
            layer.lifetime = 20.0
        }
    }

    func pauseEmitterLayer(_ layer: CAEmitterLayer) {
        if lastLookEnabled {
            layer.lifetime = 0.0

            DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
                let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                layer.speed = 0.0
                layer.timeOffset = pausedTime
            }
        } else {
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0.0
            layer.timeOffset = pausedTime
        }
    }

    // MARK: - Lockscreen
    func pauseLockscreenView(calledFrom: String = #function) {
        guard let layer = lockscreenEmitterLayer else { return }

        lockscreenPaused = true
        pauseEmitterLayer(layer)
    }

    func resumeLockscreenView() {
        guard let layer = lockscreenEmitterLayer else { return }

        lockscreenPaused = false
        resumeEmitterLayer(layer)
    }

    // MARK: - Helper functions for homescreen CAEmitterLayers
    func resumeWithoutFadein(_ layer: CAEmitterLayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0
        layer.beginTime = 0.0
        let timeSyncPause = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.beginTime = timeSyncPause - pausedTime
    }

    func pauseWithoutFadeout(_ layer: CAEmitterLayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    // MARK: - Homescreen
    // we don't need fadeout for homescreen even if LastLook is enabled
    func pauseHomescreenView() {
        guard let homescreenEmitterLayer = homescreenEmitterLayer else { return }
        pauseWithoutFadeout(homescreenEmitterLayer)

        guard let dockEmitterLayer = dockEmitterLayer else { return }
        pauseWithoutFadeout(dockEmitterLayer)
    }

    func resumeHomescreenView() {
        guard let homescreenEmitterLayer = homescreenEmitterLayer else { return }
        resumeWithoutFadein(homescreenEmitterLayer)

        guard let dockEmitterLayer = dockEmitterLayer else { return }
        resumeWithoutFadein(dockEmitterLayer)
    }

    // MARK: - Music Player
    func pauseMusicView() {
        guard let layer = musicEmitterLayer else { return }

        pauseEmitterLayer(layer)
    }

    func resumeMusicView() {
        guard let layer = musicEmitterLayer else { return }

        resumeEmitterLayer(layer)
    }
}