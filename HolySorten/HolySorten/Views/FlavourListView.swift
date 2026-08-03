import SwiftUI
import SwiftData
import UIKit

enum FlavourSortOption: String, CaseIterable, Identifiable {
    case name
    case rating
    case newest

    var id: String { rawValue }

    var title: String {
        switch self {
        case .name: "Name"
        case .rating: "Bewertung"
        case .newest: "Zuletzt"
        }
    }
}

struct FlavourListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Flavour.name) private var flavours: [Flavour]

    @State private var searchText = ""
    @State private var sortOption: FlavourSortOption = .name
    @State private var showOnlyRated = false
    @State private var showingAddSheet = false
    @State private var path = NavigationPath()

    private var filtered: [Flavour] {
        var items = flavours

        if showOnlyRated {
            items = items.filter(\.hasRating)
        }

        if !searchText.isEmpty {
            items = items.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                    || $0.tasteNotes.localizedCaseInsensitiveContains(searchText)
                    || $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sortOption {
        case .name:
            return items.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .rating:
            return items.sorted {
                if $0.rating == $1.rating {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                return $0.rating > $1.rating
            }
        case .newest:
            return items.sorted { $0.updatedAt > $1.updatedAt }
        }
    }

    private var ratedCount: Int {
        flavours.filter(\.hasRating).count
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                HolyBackground()

                if flavours.isEmpty {
                    emptyState
                } else {
                    List {
                        headerSection
                        ForEach(filtered) { flavour in
                            NavigationLink(value: flavour.id) {
                                FlavourRowView(flavour: flavour)
                            }
                            .listRowBackground(Color.holySurface.opacity(0.55))
                            .listRowSeparatorTint(HolyTheme.muted.opacity(0.35))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    delete(flavour)
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Holy Sorten")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Sorte suchen…")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sortierung", selection: $sortOption) {
                            ForEach(FlavourSortOption.allCases) { option in
                                Text(option.title).tag(option)
                            }
                        }
                        Toggle("Nur bewertete", isOn: $showOnlyRated)
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Color.holyAccent)
                    }
                    .accessibilityLabel("Sorte hinzufügen")
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let flavour = flavours.first(where: { $0.id == id }) {
                    FlavourDetailView(flavour: flavour)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditFlavourView(mode: .add)
            }
        }
        .preferredColorScheme(.dark)
        .tint(Color.holyAccent)
    }

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                Text("Deine HOLY Energy® Bewertungen")
                    .font(.headline)
                    .foregroundStyle(HolyTheme.textPrimary)
                Text("\(ratedCount) von \(flavours.count) Sorten bewertet")
                    .font(.subheadline)
                    .foregroundStyle(HolyTheme.textSecondary)
            }
            .padding(.vertical, 4)
            .listRowBackground(Color.clear)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Keine Sorten", systemImage: "cup.and.saucer")
        } description: {
            Text("Füge deine erste HOLY-Sorte hinzu und vergebe Sterne.")
        } actions: {
            Button("Sorte hinzufügen") {
                showingAddSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
        .foregroundStyle(HolyTheme.textSecondary)
    }

    private func delete(_ flavour: Flavour) {
        withAnimation {
            modelContext.delete(flavour)
            try? modelContext.save()
        }
    }
}

struct FlavourRowView: View {
    let flavour: Flavour

    private let imageSize: CGFloat = 96

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            FlavourThumbnail(imageData: flavour.imageData, size: imageSize)

            VStack(alignment: .leading, spacing: 6) {
                Text(flavour.name)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(HolyTheme.textPrimary)
                    .lineLimit(2)

                if !flavour.tasteNotes.isEmpty {
                    Text(flavour.tasteNotes)
                        .font(.subheadline)
                        .foregroundStyle(HolyTheme.textSecondary)
                        .lineLimit(2)
                }

                StarRatingDisplay(rating: flavour.rating)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}

struct FlavourThumbnail: View {
    let imageData: Data?
    var size: CGFloat = 96

    var body: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.holySurface
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: size * 0.35))
                        .foregroundStyle(Color.holyAccent.opacity(0.7))
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: size * 0.18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}
