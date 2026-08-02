# Holy Sorten

Kleine iPhone-App (SwiftUI) zum Sammeln, Fotografieren und Bewerten von [HOLY Energy®](https://holy.com)-Sorten — komplett auf Deutsch.

## Features

- **Katalog vorausgefüllt** mit aktuellen HOLY Energy®-Sorten von holy.com
- **Eigene Sorten hinzufügen** (Name, Geschmack, Notizen)
- **Fotos** aus der Mediathek hinzufügen oder ändern
- **Sterne-Bewertung** (1–5), direkt in der Detailansicht oder beim Bearbeiten
- **Suche, Sortierung & Filter** (Name, Bewertung, zuletzt geändert, nur bewertete)
- **Lokale Speicherung** mit SwiftData (bleibt auf dem Gerät)

## Voraussetzungen

- macOS mit **Xcode 15+**
- iOS **17.0+** (Simulator oder iPhone)

## Starten

1. `HolySorten/HolySorten.xcodeproj` in Xcode öffnen
2. Team unter *Signing & Capabilities* wählen (für Gerät/Simulator)
3. Zielgerät wählen → **Run** (⌘R)

Beim ersten Start werden die HOLY-Sorten automatisch angelegt. Tippe auf eine Sorte, vergebe Sterne und füge optional ein Foto hinzu.

## Projektstruktur

```
HolySorten/
├── HolySorten.xcodeproj
└── HolySorten/
    ├── HolySortenApp.swift
    ├── Models/Flavour.swift
    ├── Services/FlavourSeeder.swift
    ├── Views/
    │   ├── FlavourListView.swift
    │   ├── FlavourDetailView.swift
    │   ├── AddEditFlavourView.swift
    │   ├── StarRatingView.swift
    │   └── Theme.swift
    ├── Assets.xcassets
    └── Info.plist
```
