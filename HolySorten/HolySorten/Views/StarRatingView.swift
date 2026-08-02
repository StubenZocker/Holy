import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var maxRating: Int = 5
    var size: CGFloat = 28
    var isEditable: Bool = true

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(star <= rating ? Color.holyAccent : Color.holyMuted)
                    .symbolEffect(.bounce, value: rating)
                    .onTapGesture {
                        guard isEditable else { return }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            rating = rating == star ? 0 : star
                        }
                    }
                    .accessibilityLabel("\(star) Stern\(star == 1 ? "" : "e")")
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Bewertung")
        .accessibilityValue(rating == 0 ? "Keine Bewertung" : "\(rating) von \(maxRating)")
        .accessibilityAdjustableAction { direction in
            guard isEditable else { return }
            switch direction {
            case .increment:
                rating = min(maxRating, rating + 1)
            case .decrement:
                rating = max(0, rating - 1)
            @unknown default:
                break
            }
        }
    }
}

struct StarRatingDisplay: View {
    let rating: Int
    var size: CGFloat = 14

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(star <= rating ? Color.holyAccent : Color.holyMuted.opacity(0.5))
            }
        }
        .accessibilityLabel(rating == 0 ? "Noch nicht bewertet" : "\(rating) von 5 Sternen")
    }
}
