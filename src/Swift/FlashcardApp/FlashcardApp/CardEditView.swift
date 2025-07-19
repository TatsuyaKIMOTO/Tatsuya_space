// CardEditView.swift
import SwiftUI
import SwiftData

struct CardEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // 編集対象のカード。nilの場合は新規作成モード
    var cardToEdit: Card?
    // 新規作成時にどのフォルダに属するかを指定
    var folder: Folder?
    
    @State private var frontText = ""
    @State private var backMeaning = ""
    @State private var backEtymology = ""
    @State private var backExample = ""
    @State private var backExampleJP = ""
    
    // ビューのタイトルを動的に変更
    var navigationTitle: String {
        cardToEdit == nil ? "新しいカード" : "カードを編集"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("表面")) {
                    TextField("単語", text: $frontText)
                }
                Section(header: Text("裏面")) {
                    TextField("意味", text: $backMeaning, axis: .vertical)
                    TextField("語源（任意）", text: $backEtymology, axis: .vertical)
                    
                    // 例文入力エリア
                    VStack(alignment: .leading) {
                        Text("例文").font(.caption).foregroundColor(.gray)
                        TextEditor(text: $backExample)
                            .frame(height: 100)
                    }
                    
                    // 例文日本語訳入力エリア
                    VStack(alignment: .leading) {
                        Text("例文の日本語訳").font(.caption).foregroundColor(.gray)
                        TextEditor(text: $backExampleJP)
                            .frame(height: 100)
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
                        save()
                        dismiss()
                    }
                    .disabled(frontText.isEmpty || backMeaning.isEmpty)
                }
            }
            .onAppear(perform: loadCardData)
        }
    }
    
    // 編集モードの場合、既存のデータをフォームに読み込む
    private func loadCardData() {
        guard let card = cardToEdit else { return }
        frontText = card.frontText
        backMeaning = card.backMeaning
        backEtymology = card.backEtymology
        backExample = card.backExample
        backExampleJP = card.backExampleJP
    }

    // 保存処理（新規作成と更新を兼ねる）
    private func save() {
        if let card = cardToEdit {
            // 更新の場合
            card.frontText = frontText
            card.backMeaning = backMeaning
            card.backEtymology = backEtymology
            card.backExample = backExample
            card.backExampleJP = backExampleJP
        } else {
            // 新規作成の場合
            let newCard = Card(
                frontText: frontText,
                backMeaning: backMeaning,
                backEtymology: backEtymology,
                backExample: backExample,
                backExampleJP: backExampleJP
            )
            // 新規作成時のみフォルダと関連付ける
            newCard.folder = folder
            modelContext.insert(newCard)
        }
    }
}
