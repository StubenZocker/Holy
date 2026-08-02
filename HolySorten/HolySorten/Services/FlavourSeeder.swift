import Foundation
import SwiftData

enum FlavourSeeder {
    /// Offizielle HOLY Energy®-Sorten (holy.com), vorausgefüllt zum Bewerten.
    static let catalog: [(name: String, tasteNotes: String)] = [
        ("Lion's Lemonade", "Mango, Kiwi"),
        ("Caipirinha Crab", "Limette, Zuckerrohr"),
        ("Mojito Macaw", "Limette, Minze"),
        ("Daiquiri Dolphin", "Erdbeere, Limette"),
        ("Capybara Colada", "Ananas, Kokos"),
        ("Matcha Misaki", "Matcha, Erdbeere"),
        ("BURRsday Bunny", "Lychee"),
        ("Energy Eel", "Guarana"),
        ("Cotton Candy Caterpillar", "Zuckerwatte"),
        ("Citrus Cobra", "Zitrus, Calamansi"),
        ("Thai Lime Toucan", "Kaffirlimette"),
        ("Tangerine Tarantula", "Mandarine"),
        ("Kola Koala", "Cola"),
        ("Lollipop Lovebird", "Kirsch-Lolli"),
        ("Woodruff Wolf", "Waldmeister"),
        ("Frosty Fox", "Eisbonbon"),
        ("Baked Apple Boar", "Bratapfel"),
        ("Bubblegum Butterfly", "Kaugummi"),
        ("Grapefruit Giraffe", "Grapefruit"),
        ("Raspberry Raptor", "Himbeere, Yuzu"),
        ("Gorilla's Grape", "Grüne Traube"),
        ("Cactus Camel", "Kaktusfeige"),
        ("Strawberry Shark", "Erdbeere, Mandarine"),
        ("Apple Alligator", "Saurer Apfel"),
        ("Blueberry Bear", "Blaubeere, Kokos"),
        ("Peach Panther", "Pfirsich, Aprikose"),
        ("Fruity Frog", "Mango, Maracuja, Ananas"),
        ("Tropical Tiger", "Maracuja, Ananas"),
        ("Lemon Lizard", "Zitrone, Gurke"),
        ("Peacock Punch", "Ananas, Limette, Kokos"),
        ("Wildberry Wolf", "Waldbeeren"),
        ("Watermelon Whale", "Wassermelone"),
        ("Kiwi Komodo", "Kiwi"),
        ("Blood Orange Bat", "Blutorange"),
        ("Cherry Cheetah", "Kirsche"),
        ("Dragonfruit Dragon", "Drachenfrucht"),
        ("Pomegranate Piranha", "Granatapfel"),
        ("Açaí Anaconda", "Açaí")
    ]

    static func seedIfNeeded(in context: ModelContext) {
        var descriptor = FetchDescriptor<Flavour>()
        descriptor.fetchLimit = 1

        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        for item in catalog {
            let flavour = Flavour(
                name: item.name,
                tasteNotes: item.tasteNotes,
                rating: 0,
                notes: "",
                isCustom: false
            )
            context.insert(flavour)
        }

        try? context.save()
    }
}
