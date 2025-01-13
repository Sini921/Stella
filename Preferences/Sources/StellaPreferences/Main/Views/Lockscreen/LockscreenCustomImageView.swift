import SwiftUI
import libroot

struct LockscreenCustomImageView: View {
    @EnvironmentObject var preferenceStorage: PreferenceStorage

    var body: some View {
        CustomImageView(storageKey: .lockscreen)
            .environmentObject(preferenceStorage)
    }
}