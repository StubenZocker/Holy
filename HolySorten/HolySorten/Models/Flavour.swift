import Foundation
import SwiftData

@Model
final class Flavour {
    var id: UUID
    var name: String
    var tasteNotes: String
    var rating: Int
    var notes: String
    var imageData: Data?
    var createdAt: Date
    var updatedAt: Date
    var isCustom: Bool

    init(
        name: String,
        tasteNotes: String = "",
        rating: Int = 0,
        notes: String = "",
        imageData: Data? = nil,
        isCustom: Bool = true
    ) {
        self.id = UUID()
        self.name = name
        self.tasteNotes = tasteNotes
        self.rating = max(0, min(5, rating))
        self.notes = notes
        self.imageData = imageData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isCustom = isCustom
    }

    var hasRating: Bool { rating > 0 }

    var ratingText: String {
        hasRating ? "\(rating) von 5" : "Noch nicht bewertet"
    }
}
