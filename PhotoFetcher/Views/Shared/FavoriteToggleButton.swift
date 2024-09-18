
import SwiftUI

struct FavoriteToggleButton: View {
    var isFavorite: Bool
    var toggleAction: () -> Void

    var body: some View {
        Button(action: {
            withAnimation {
                toggleAction()
            }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .font(.title2)
                .padding()
        }
    }
}
