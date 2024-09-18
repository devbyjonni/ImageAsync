
import SwiftUI

struct AlertView {
    static func alert(error: ViewModelError, retryAction: @escaping () -> Void) -> Alert {
        return Alert(
            title: Text(error.title),
            message: Text(error.message),
            primaryButton: .default(Text("Retry"), action: retryAction),
            secondaryButton: .cancel()
        )
    }
}
