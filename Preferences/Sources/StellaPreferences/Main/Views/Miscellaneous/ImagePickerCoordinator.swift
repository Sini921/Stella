import PhotosUI
import Foundation

class ImagePickerCoordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: ImagePicker
    var storageKey: StorageKey

    init(parent: ImagePicker, storageKey: StorageKey) {
        self.parent = parent
        self.storageKey = storageKey
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let provider = results.first?.itemProvider else { return }

        if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.parent.selectedImage = image
                        self.saveImageToPreferenceStorage(image: image)
                    } else {
                        // Try to load the image data directly
                        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { (data, error) in
                            DispatchQueue.main.async {
                                if let data = data, let image = UIImage(data: data) {
                                    self.parent.selectedImage = image
                                    self.saveImageToPreferenceStorage(image: image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func saveImageToPreferenceStorage(image: UIImage) {
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 25, height: 25))

        guard let data = resizedImage.pngData() else { return }

        DispatchQueue.main.async {
            switch self.storageKey {
            case .lockscreen:
                self.parent.preferenceStorage.lockscreenCustomImageData = data
            case .homescreen:
                self.parent.preferenceStorage.homescreenCustomImageData = data
            }
        }
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}