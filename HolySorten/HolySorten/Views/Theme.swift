import SwiftUI

enum HolyTheme {
    static let backgroundTop = Color(red: 0.06, green: 0.14, blue: 0.12)
    static let backgroundBottom = Color(red: 0.03, green: 0.07, blue: 0.08)
    static let surface = Color(red: 0.10, green: 0.18, blue: 0.16)
    static let accent = Color(red: 0.45, green: 0.95, blue: 0.55)
    static let accentSoft = Color(red: 0.30, green: 0.75, blue: 0.50)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.72, green: 0.82, blue: 0.78)
    static let muted = Color(red: 0.40, green: 0.50, blue: 0.46)
}

extension Color {
    static let holyAccent = HolyTheme.accent
    static let holyMuted = HolyTheme.muted
    static let holySurface = HolyTheme.surface
}

struct HolyBackground: View {
    var body: some View {
        LinearGradient(
            colors: [HolyTheme.backgroundTop, HolyTheme.backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay {
            GeometryReader { geo in
                Circle()
                    .fill(HolyTheme.accent.opacity(0.08))
                    .frame(width: geo.size.width * 0.7)
                    .blur(radius: 60)
                    .offset(x: -geo.size.width * 0.25, y: -geo.size.height * 0.1)
                Circle()
                    .fill(HolyTheme.accentSoft.opacity(0.06))
                    .frame(width: geo.size.width * 0.6)
                    .blur(radius: 50)
                    .offset(x: geo.size.width * 0.45, y: geo.size.height * 0.55)
            }
            .allowsHitTesting(false)
        }
    }
}
