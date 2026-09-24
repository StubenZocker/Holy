import SwiftUI

struct ContentView: View {
    @State private var filamentPreis: String = ""
    @State private var filamentGewicht: String = ""
    @State private var gewichtVerbraucht: String = ""
    @State private var anzahlKopien: String = "1"
    @State private var gesamtkosten: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filament Informationen")) {
                    HStack {
                        Text("Preis pro Rolle")
                        Spacer()
                        TextField("€", text: $filamentPreis)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Gewicht pro Rolle")
                        Spacer()
                        TextField("g", text: $filamentGewicht)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Druck Informationen")) {
                    HStack {
                        Text("Verbrauchtes Gewicht")
                        Spacer()
                        TextField("g", text: $gewichtVerbraucht)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Anzahl Kopien")
                        Spacer()
                        TextField("1", text: $anzahlKopien)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Ergebnis")) {
                    HStack {
                        Text("Gesamtkosten")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f €", gesamtkosten))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
                
                Section {
                    Button(action: berechneKosten) {
                        HStack {
                            Spacer()
                            Text("Berechnen")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    
                    Button(action: zuruecksetzen) {
                        HStack {
                            Spacer()
                            Text("Zurücksetzen")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("3D-Druck Rechner")
        }
    }
    
    func berechneKosten() {
        guard let preis = Double(filamentPreis.replacingOccurrences(of: ",", with: ".")),
              let gewicht = Double(filamentGewicht.replacingOccurrences(of: ",", with: ".")),
              let verbraucht = Double(gewichtVerbraucht.replacingOccurrences(of: ",", with: ".")),
              let kopien = Double(anzahlKopien.replacingOccurrences(of: ",", with: ".")) else {
            gesamtkosten = 0.0
            return
        }
        
        if gewicht > 0 {
            let kostenProGramm = preis / gewicht
            gesamtkosten = kostenProGramm * verbraucht * kopien
        } else {
            gesamtkosten = 0.0
        }
    }
    
    func zuruecksetzen() {
        filamentPreis = ""
        filamentGewicht = ""
        gewichtVerbraucht = ""
        anzahlKopien = "1"
        gesamtkosten = 0.0
    }
}

#Preview {
    ContentView()
}
