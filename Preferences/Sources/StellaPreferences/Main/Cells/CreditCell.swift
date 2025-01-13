import SwiftUI

struct CreditCell: View {
    let imagePath: String
    let username: String
    let description: String
    
    @State private var imageData: Data? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 38, height: 38)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(username)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .onAppear {
            loadImageFromFilePath()
        }
        .onTapGesture {
            openURL()
        }
    }
    
    private func loadImageFromFilePath() {
        guard let image = UIImage(contentsOfFile: imagePath) else { return }
        imageData = image.pngData()
    }

    private func openURL() {
        guard let twitterURL = URL(string: "https://twitter.com/\(username)") else { return }
        UIApplication.shared.open(twitterURL)
    }
}
