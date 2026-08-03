import SwiftUI
import SwiftData
import PhotosUI
import UIKit

enum FlavourEditorMode {
    case add
    case edit(Flavour)

    var title: String {
        switch self {
        case .add: "Neue Sorte"
        case .edit: "Sorte bearbeiten"
        }
    }
}

struct AddEditFlavourView: View {
    let mode: FlavourEditorMode

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var tasteNotes: String = ""
    @State private var notes: String = ""
    @State private var rating: Int = 0
    @State private var imageData: Data?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showValidationAlert = false
    @State private var showingCamera = false

    var body: some View {
        NavigationStack {
            ZStack {
                HolyBackground()

                Form {
                    Section("Foto") {
                        photoPicker
                    }
                    .listRowBackground(Color.holySurface.opacity(0.7))

                    Section("Details") {
                        TextField("Name der Sorte", text: $name)
                        TextField("Geschmack (z. B. Mango, Kiwi)", text: $tasteNotes)
                        TextField("Notizen", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    .listRowBackground(Color.holySurface.opacity(0.7))

                    Section("Bewertung") {
                        VStack(alignment: .leading, spacing: 12) {
                            StarRatingView(rating: $rating, size: 32)
                            Text(rating == 0 ? "Tippe auf die Sterne" : "\(rating) von 5 Sternen")
                                .font(.caption)
                                .foregroundStyle(HolyTheme.textSecondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.holySurface.opacity(0.7))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") { save() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.holyAccent)
                }
            }
            .alert("Name fehlt", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Bitte gib einen Namen für die Sorte ein.")
            }
            .onAppear(perform: loadIfEditing)
            .onChange(of: selectedPhoto) { _, newItem in
                Task { await loadPhoto(from: newItem) }
            }
            .fullScreenCover(isPresented: $showingCamera) {
                CameraPicker(imageData: $imageData)
                    .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
        .tint(Color.holyAccent)
    }

    private var photoPicker: some View {
        VStack(spacing: 14) {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(HolyTheme.backgroundBottom.opacity(0.5))
                    .frame(height: 140)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title2)
                            Text("Foto hinzufügen")
                                .font(.subheadline)
                        }
                        .foregroundStyle(HolyTheme.textSecondary)
                    }
            }

            // Getrennte Zeilen + borderless: verhindert, dass Form-Gesten
            // Mediathek und Kamera gleichzeitig auslösen.
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Aus Mediathek wählen", systemImage: "photo")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.borderless)

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button {
                    showingCamera = true
                } label: {
                    Label("Mit Kamera aufnehmen", systemImage: "camera")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderless)
            }

            if imageData != nil {
                Button(role: .destructive) {
                    imageData = nil
                    selectedPhoto = nil
                } label: {
                    Label("Foto entfernen", systemImage: "trash")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderless)
            }
        }
        .font(.subheadline)
        .padding(.vertical, 4)
    }

    private func loadIfEditing() {
        guard case .edit(let flavour) = mode else { return }
        name = flavour.name
        tasteNotes = flavour.tasteNotes
        notes = flavour.notes
        rating = flavour.rating
        imageData = flavour.imageData
    }

    private func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self) {
            await MainActor.run {
                imageData = compressImageData(data)
            }
        }
    }

    private func compressImageData(_ data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return data }
        let maxDimension: CGFloat = 1200
        let size = image.size
        let scale = min(1, maxDimension / max(size.width, size.height))
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.78)
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            showValidationAlert = true
            return
        }

        switch mode {
        case .add:
            let flavour = Flavour(
                name: trimmed,
                tasteNotes: tasteNotes.trimmingCharacters(in: .whitespacesAndNewlines),
                rating: rating,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                imageData: imageData,
                isCustom: true
            )
            modelContext.insert(flavour)
        case .edit(let flavour):
            flavour.name = trimmed
            flavour.tasteNotes = tasteNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            flavour.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            flavour.rating = rating
            flavour.imageData = imageData
            flavour.updatedAt = Date()
        }

        try? modelContext.save()
        dismiss()
    }
}
