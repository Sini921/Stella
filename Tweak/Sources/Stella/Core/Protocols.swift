import Foundation

@objc protocol LastLookManager {
    func sharedInstance() -> AnyObject
    var isActive: Bool { get }
    var currentMode: Int { get }
}
