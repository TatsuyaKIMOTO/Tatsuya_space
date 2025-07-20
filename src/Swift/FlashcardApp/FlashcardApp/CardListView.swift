import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var folder: Folder
    
    @State private var cards: [Card] = []
    
    enum ActiveSheet: Identifiable {
        case add
        case edit(Card)
        
        var id: Int {
            switch self {
            case .add: return 0
            case .edit(let card): return card.id.hashValue
            }
        }
    }
    
    @State private var activeSheet: ActiveSheet?
    @State private var showDeleteAlert = false
    @State private var cardToDelete: Card?
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if cards.isEmpty {
                ContentUnavailableView(
                    "カードがありません",
                    systemImage: "square.on.square.badge.person.crop",
                    description: Text("右上の「+」ボタンから新しい単語カードを追加してください。")
                )
            } else {
                CardListContentView(
                    cards: cards,
                    onEdit: { activeSheet = .edit($0) },
                    onDelete: { card in
                        cardToDelete = card
                        showDeleteAlert = true
                    }
                )
            }
        }
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    activeSheet = .add
                } label: {
                    Label("カードを追加", systemImage: "plus")
                }
            }
        }
        .sheet(item: $activeSheet, onDismiss: fetchCards) { sheet in
            switch sheet {
            case .add:
                CardEditView(folder: folder)
            case .edit(let card):
                CardEditView(cardToEdit: card)
            }
        }
        .alert("本当に削除しますか？", isPresented: $showDeleteAlert) {
            Button("削除", role: .destructive) {
                if let card = cardToDelete {
                    deleteCard(card)
                }
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("削除したカードは元に戻せません。")
        }
        .onAppear(perform: fetchCards)
    }
    
    private func fetchCards() {
        let folderID = folder.id
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate<Card> { $0.folder?.id == folderID },
            sortBy: [SortDescriptor(\.id)]
        )
        do {
            cards = try modelContext.fetch(descriptor)
        } catch {
            print("カードの取得に失敗しました: \(error.localizedDescription)")
            cards = []
        }
    }
    
    private func deleteCard(_ card: Card) {
        withAnimation {
            modelContext.delete(card)
            fetchCards()
        }
    }
}

struct CardListContentView: View {
    let cards: [Card]
    let onEdit: (Card) -> Void
    let onDelete: (Card) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                NavigationLink(destination: FlashcardView(cards: cards)) {
                    HStack {
                        Spacer()
                        Image(systemName: "play.circle.fill")
                        Text("学習を開始")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.accent.opacity(0.4), radius: 8, y: 4)
                }
                .padding([.horizontal, .top])
                
                ForEach(cards) { card in
                    CardRowView(card: card, onEdit: onEdit, onDelete: onDelete)
                }
            }
            .padding(.vertical)
        }
    }
}

struct CardRowView: View {
    let card: Card
    let onEdit: (Card) -> Void
    let onDelete: (Card) -> Void
    
    var body: some View {
        Button(action: { onEdit(card) }) {
            VStack(alignment: .leading, spacing: 5) {
                Text(card.frontText)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(card.backMeaning)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.elementBackground)
            .cornerRadius(12)
        }
        .padding(.horizontal)
        .accessibilityLabel("\(card.frontText), 意味: \(card.backMeaning)")
        .contextMenu {
            Button {
                onEdit(card)
            } label: {
                Label("編集", systemImage: "pencil")
            }
            Button(role: .destructive) {
                onDelete(card)
            } label: {
                Label("削除", systemImage: "trash")
            }
        }
    }
}
