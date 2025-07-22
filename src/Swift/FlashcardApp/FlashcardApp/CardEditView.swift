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
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case front, meaning, etymology, example, exampleJP
    }
    
    var navigationTitle: String {
        cardToEdit == nil ? "新しいカード" : "カードを編集"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("表面").textCase(.none).font(.subheadline)) {
                    TextField("単語", text: $frontText)
                        .focused($focusedField, equals: .front)
                }
                
                Section(header: Text("裏面").textCase(.none).font(.subheadline)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("意味")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        TextEditor(text: $backMeaning)
                            .frame(minHeight: 80)
                            .focused($focusedField, equals: .meaning)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("語源（任意）")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        TextEditor(text: $backEtymology)
                            .frame(minHeight: 80)
                            .focused($focusedField, equals: .etymology)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("例文")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        TextEditor(text: $backExample)
                            .frame(minHeight: 100)
                            .focused($focusedField, equals: .example)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("例文の日本語訳")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        TextEditor(text: $backExampleJP)
                            .frame(minHeight: 100)
                            .focused($focusedField, equals: .exampleJP)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ナビゲーションバーのボタン
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
                
                // ★★★ ここが、この問題の唯一の、そして完全な解決策です ★★★
                // キーボードのツールバー
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    // 「完了」テキストを、役割が明確な「キーボードを隠す」アイコンに変更します
                    Button {
                        focusedField = nil // フォーカスを外してキーボードを閉じる
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
            .onAppear(perform: loadCardData)
        }
    }
    
    private func loadCardData() {
        if let card = cardToEdit {
            frontText = card.frontText
            backMeaning = card.backMeaning
            backEtymology = card.backEtymology
            backExample = card.backExample
            backExampleJP = card.backExampleJP
        }
    }

    private func save() {
        // 新規作成か更新かを判定
        let card: Card
        if let cardToEdit = cardToEdit {
            card = cardToEdit
        } else {
            card = Card(frontText: "", backMeaning: "", backEtymology: "", backExample: "", backExampleJP: "")
            card.folder = folder
            modelContext.insert(card)
        }
        
        // 共通のプロパティ更新
        card.frontText = frontText
        card.backMeaning = backMeaning
        card.backEtymology = backEtymology
        card.backExample = backExample
        card.backExampleJP = backExampleJP
        
        // 新規作成の場合、creationDateが自動で設定される
        if cardToEdit == nil {
            card.creationDate = Date()
        }
    }
}

#Preview {
    CardEditView()
}
