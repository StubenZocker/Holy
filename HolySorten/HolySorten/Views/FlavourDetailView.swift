import SwiftUI
import SwiftData
import UIKit

struct FlavourDetailView: View {
    @Bindable var flavour: Flavour
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showingEdit = false
    @State private var showingDeleteConfirm = false

    var body: some View {
        ZStack {
            HolyBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    photoHeader

                    VStack(alignment: .leading, spacing: 8) {
                        if flavour.isLimited {
                            LimitedTag()
                        }

                        Text(flavour.name)
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                            .foregroundStyle(HolyTheme.textPrimary)

                        if !flavour.tasteNotes.isEmpty {
                            Text(flavour.tasteNotes)
                                .font(.title3)
                                .foregroundStyle(HolyTheme.textSecondary)
                        }
                    }

                    ratingSection

                    if !flavour.notes.isEmpty {
                        notesSection
                    }

                    metaSection
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showingEdit = true
                    } label: {
                        Label("Bearbeiten", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        showingDeleteConfirm = true
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddEditFlavourView(mode: .edit(flavour))
        }
        .confirmationDialog(
            "Sorte löschen?",
            isPresented: $showingDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Löschen", role: .destructive) {
                modelContext.delete(flavour)
                try? modelContext.save()
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("„\(flavour.name)“ wird dauerhaft entfernt.")
        }
    }

    private var photoHeader: some View {
        Group {
            if let imageData = flavour.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 260)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.holyAccent.opacity(0.12), lineWidth: 1)
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.holySurface.opacity(0.72))
                    VStack(spacing: 10) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.holyAccent.opacity(0.7))
                        Text("Noch kein Foto")
                            .font(.subheadline)
                            .foregroundStyle(HolyTheme.textSecondary)
                    }
                }
                .frame(height: 200)
            }
        }
    }

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bewertung")
                .font(.headline)
                .foregroundStyle(HolyTheme.textPrimary)

            StarRatingView(rating: Binding(
                get: { flavour.rating },
                set: { newValue in
                    flavour.rating = newValue
                    flavour.updatedAt = Date()
                    try? modelContext.save()
                }
            ), size: 36)

            Text(flavour.ratingText)
                .font(.subheadline)
                .foregroundStyle(HolyTheme.textSecondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.holySurface.opacity(0.78), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notizen")
                .font(.headline)
                .foregroundStyle(HolyTheme.textPrimary)
            Text(flavour.notes)
                .font(.body)
                .foregroundStyle(HolyTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(Color.holySurface.opacity(0.78), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var metaSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(flavour.isCustom ? "Eigene Sorte" : "HOLY Katalog")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.holyAccent)

                if flavour.isLimited {
                    Text("·")
                        .foregroundStyle(HolyTheme.muted)
                    Text("Limitiert")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.holyAccent)
                }
            }
            Text("Zuletzt geändert: \(flavour.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundStyle(HolyTheme.muted)
        }
    }
}
