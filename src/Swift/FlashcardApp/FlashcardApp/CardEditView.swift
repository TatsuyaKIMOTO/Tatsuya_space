// CardEditView.swift
import SwiftUI
import SwiftData

struct CardEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var cardToEdit: Card?
    var folder: Folder?
    
    @State private var frontText = ""
    @State private var backMeaning = ""
    @State private var backEtymology = ""
    @State private var backExample = ""
    @State private var backExampleJP = ""

    var navigationTitle: String {
        cardToEdit == nil ? "新しいカード" : "カードを編集"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("表面")) {
                    TextField("単語", text: $frontText)
                        .textFieldStyle(.roundedBorder)
                }
                Section(header: Text("裏面")) {
                    TextField("意味", text: $backMeaning, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    TextField("語源（任意）", text: $backEtymology, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    
                    VStack(alignment: .leading) {
                        Text("例文").font(.caption).foregroundColor(.gray)
                        TextEditor(text: $backExample)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.vertical, 4)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("例文の日本語訳").font(.caption).foregroundColor(.gray)
                        TextEditor(text: $backExampleJP)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                            .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if save() {
                            dismiss()
                        }
                    }
                    .disabled(frontText.isEmpty || backMeaning.isEmpty)
                }
            }
            .onAppear(perform: loadCardData)
        }
    }

    private func loadCardData() {
        guard let card = cardToEdit else { return }
        frontText = card.frontText
        backMeaning = card.backMeaning
        backEtymology = card.backEtymology
        backExample = card.backExample
        backExampleJP = card.backExampleJP
    }

    private func save() -> Bool {
        if let card = cardToEdit {
            card.frontText = frontText
            card.backMeaning = backMeaning
            card.backEtymology = backEtymology
            card.backExample = backExample
            card.backExampleJP = backExampleJP
        } else {
            let newCard = Card(
                frontText: frontText,
                backMeaning: backMeaning,
                backEtymology: backEtymology,
                backExample: backExample,
                backExampleJP: backExampleJP
            )
            newCard.folder = folder
            modelContext.insert(newCard)
        }
        return true
    }
}
