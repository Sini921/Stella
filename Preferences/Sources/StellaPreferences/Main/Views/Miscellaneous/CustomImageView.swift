import SwiftUI
import PhotosUI

enum StorageKey {
    case lockscreen
    case homescreen
}

struct CustomImageView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    var storageKey: StorageKey

    let imageSizeOptions = [
        (title: "Very small", value: 8.0),
        (title: "Small", value: 10.0),
        (title: "Normal", value: 12.0),
        (title: "Big", value: 14.0),
    ]

    var body: some View {
        Form {
            Section(header: Text("Custom Image for \(storageKey == .lockscreen ? "Lockscreen" : "Homescreen")")) {
                Toggle(isOn: bindingForKey()) {
                    Text("Enable")
                }
            }

            Section(header: Text("Customize")) {
                Picker("Size of image", selection: sizeBindingForKey()) {
                    ForEach(imageSizeOptions, id: \.value) { option in
                        Text(option.title).tag(option.value)
                    }
                }.pickerStyle(SegmentedPickerStyle())

                HStack {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Select Image")
                    }

                    Spacer()

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Rectangle())
                            .cornerRadius(8)
                    } else if let existingImage = loadImageFromPreferenceStorage() {
                        Image(uiImage: existingImage)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Rectangle())
                            .cornerRadius(8)
                    }
                }
            }
        }
        .navigationTitle("Custom Image")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, storageKey: storageKey)
        }
        .onAppear {
            if let existingImage = loadImageFromPreferenceStorage() {
                selectedImage = existingImage
            }
        }
    }

    private func bindingForKey() -> Binding<Bool> {
        switch storageKey {
        case .lockscreen:
            return $preferenceStorage.lockscreenCustomImageEnabled
        case .homescreen:
            return $preferenceStorage.homescreenCustomImageEnabled
        }
    }

    private func sizeBindingForKey() -> Binding<Double> {
        switch storageKey {
        case .lockscreen:
            return $preferenceStorage.lockscreenCustomImageSize
        case .homescreen:
            return $preferenceStorage.homescreenCustomImageSize
        }
    }

    private func loadImageFromPreferenceStorage() -> UIImage? {
        let data: Data?
        switch storageKey {
        case .lockscreen:
            data = preferenceStorage.lockscreenCustomImageData
        case .homescreen:
            data = preferenceStorage.homescreenCustomImageData
        }
        
        guard let imageData = data else { return nil }
        return UIImage(data: imageData)
    }
}