import SwiftUI
import SwiftData

@main
struct HolySortenApp: App {
    var body: some Scene {
        WindowGroup {
            FlavourListView()
        }
        .modelContainer(for: Flavour.self) { result in
            switch result {
            case .success(let container):
                FlavourSeeder.seedIfNeeded(in: container.mainContext)
            case .failure(let error):
                assertionFailure("SwiftData konnte nicht gestartet werden: \(error)")
            }
        }
    }
}
