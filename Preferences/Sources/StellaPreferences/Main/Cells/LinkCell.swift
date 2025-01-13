import SwiftUI

struct LinkCell: View {
    let iconPath: String?
    let title: String
    let subtitle: String
    let url: String
    let fallbackUrl: String?

    init(iconPath: String? = nil, title: String, subtitle: String, url: String, fallbackUrl: String? = nil) {
        self.iconPath = iconPath
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.fallbackUrl = fallbackUrl
    }

    var body: some View {
        Button(action: {
            openURL(url: url, fallbackURL: fallbackUrl)
        }) {
            HStack {
                if let iconPath = iconPath, FileManager.default.fileExists(atPath: iconPath) {
                    Image(uiImage: UIImage(contentsOfFile: iconPath)!)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 4)
                }
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func openURL(url: String, fallbackURL: String?) {
        if let link = URL(string: url), UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link)
        } else if let fallbackLink = fallbackURL, let fallbackURL = URL(string: fallbackLink) {
            UIApplication.shared.open(fallbackURL)
        }
    }
}