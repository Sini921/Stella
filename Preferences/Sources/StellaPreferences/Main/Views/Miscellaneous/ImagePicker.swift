import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    var storageKey: StorageKey

    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(parent: self, storageKey: storageKey)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}