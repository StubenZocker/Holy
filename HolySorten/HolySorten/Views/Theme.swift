import SwiftUI

enum HolyTheme {
    /// Matches `AccentColor` / launch screen green.
    static let background = Color(red: 0.45, green: 0.95, blue: 0.55)
    static let backgroundDeep = Color(red: 0.36, green: 0.86, blue: 0.48)

    static let surface = Color.white
    /// Dark green for accents on the bright background.
    static let accent = Color(red: 0.05, green: 0.22, blue: 0.12)
    static let accentSoft = Color(red: 0.10, green: 0.38, blue: 0.22)
    static let textPrimary = Color(red: 0.04, green: 0.16, blue: 0.09)
    static let textSecondary = Color(red: 0.14, green: 0.32, blue: 0.20)
    static let muted = Color(red: 0.22, green: 0.42, blue: 0.30)

    // Legacy aliases used across views
    static let backgroundTop = background
    static let backgroundBottom = backgroundDeep
}

extension Color {
    static let holyAccent = HolyTheme.accent
    static let holyMuted = HolyTheme.muted
    static let holySurface = HolyTheme.surface
    static let holyBackground = HolyTheme.background
}

struct HolyBackground: View {
    var body: some View {
        LinearGradient(
            colors: [HolyTheme.background, HolyTheme.backgroundDeep],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            GeometryReader { geo in
                Circle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: geo.size.width * 0.85)
                    .blur(radius: 50)
                    .offset(x: -geo.size.width * 0.3, y: -geo.size.height * 0.12)
                Circle()
                    .fill(HolyTheme.backgroundDeep.opacity(0.55))
                    .frame(width: geo.size.width * 0.7)
                    .blur(radius: 45)
                    .offset(x: geo.size.width * 0.4, y: geo.size.height * 0.55)
            }
            .allowsHitTesting(false)
        }
    }
}

struct LimitedTag: View {
    var compact: Bool = false

    var body: some View {
        Text("Limitiert")
            .font(compact ? .caption2.weight(.bold) : .caption.weight(.bold))
            .foregroundStyle(HolyTheme.background)
            .padding(.horizontal, compact ? 7 : 9)
            .padding(.vertical, compact ? 3 : 4)
            .background(
                Color.holyAccent,
                in: RoundedRectangle(cornerRadius: compact ? 6 : 8, style: .continuous)
            )
            .accessibilityLabel("Limitierte Sorte")
    }
}
