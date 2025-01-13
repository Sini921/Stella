import SwiftUI
import Comet
import StellaPreferencesC

class RootListController: CMViewController {
    private var respringButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(content: RootView(onToggle:handleToggle))
        self.title = nil

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
    
        respringButton = UIBarButtonItem(title: "Respring", style: .plain, target:self, action: #selector(respringButtonTapped))
        respringButton.isEnabled = false
        respringButton.tintColor = .clear

        self.navigationItem.rightBarButtonItem = respringButton
    }

    @objc private func respringButtonTapped() {
        Respring.execute()
    }

    private func handleToggle() {
        respringButton.isEnabled.toggle()
        respringButton.tintColor = respringButton.tintColor == nil ? .clear : nil
    }
}
