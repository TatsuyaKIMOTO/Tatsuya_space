// CardListView.swift
import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var folder: Folder
    
    // @Queryは、新しく作成したcreationDateで、降順（新しいものが先）にソートします。
    @Query(sort: \Card.creationDate, order: .reverse) private var allCards: [Card]
    
    @State private var selectedCardToEdit: Card?
    @State private var showingAddCardView = false

    // 取得した全てのカードの中から、このフォルダに属するものだけを抽出します。
    private var cards: [Card] {
        allCards.filter { $0.folder?.id == folder.id }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if cards.isEmpty {
                ContentUnavailableView("カードがありません", systemImage: "square.on.square.badge.person.crop", description: Text("右上の「+」ボタンから新しい単語カードを追加してください。"))
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        NavigationLink(destination: FlashcardView(cards: cards)) {
                            HStack {
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                Text("学習を開始")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.accentColor.opacity(0.4), radius: 8, y: 4)
                        }
                        
                        ForEach(cards) { card in
                            CardRowView(
                                card: card,
                                onEdit: { self.selectedCardToEdit = card },
                                onDelete: { self.deleteCard(card: card) }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddCardView = true }) {
                    Label("カードを追加", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCardView) {
            CardEditView(folder: folder)
        }
        .sheet(item: $selectedCardToEdit) { card in
            CardEditView(cardToEdit: card)
        }
    }

    private func deleteCard(card: Card) {
        withAnimation {
            modelContext.delete(card)
        }
    }
}


// MARK: - CardRowView (省略せずに完全に実装)

private struct CardRowView: View {
    let card: Card
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onEdit) {
            HStack(spacing: 0) {
                Color.accentColor
                    .frame(width: 5)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.frontText)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(card.backMeaning)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.elementBackground)
            .cornerRadius(12)
            .shadow(
                color: .black.opacity(0.15),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: onEdit) {
                Label("編集", systemImage: "pencil")
            }
            Button(role: .destructive, action: onDelete) {
                Label("削除", systemImage: "trash")
            }
        }
    }
}


// MARK: - Preview (省略せずに完全に実装)

#Preview {
    // ★★★ これが、この問題の唯一の、そして完全な解決策です ★★★
    // do-catchブロックをViewBuilderの外側で完結させ、
    // 成功した場合にのみ、returnを使わずにViewを返します。
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Folder.self, configurations: config)
        
        let sampleFolder = Folder(name: "Test", orderIndex: 0)
        
        let card1 = Card(frontText: "Apple", backMeaning: "りんご", backEtymology: "", backExample: "", backExampleJP: "")
        card1.folder = sampleFolder
        let card2 = Card(frontText: "Banana", backMeaning: "バナナ", backEtymology: "", backExample: "", backExampleJP: "")
        card2.folder = sampleFolder
        
        container.mainContext.insert(sampleFolder)
        container.mainContext.insert(card1)
        container.mainContext.insert(card2)
        
        // NavigationStackをdoブロックの中に含めます
        return NavigationStack {
            CardListView(folder: sampleFolder)
                .modelContainer(container)
        }
        
    } catch {
        return Text("プレビューの作成に失敗しました: \(error.localizedDescription)")
    }
}
