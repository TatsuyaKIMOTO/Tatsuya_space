// CardListView.swift
import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var folder: Folder
    
    // ★★★ This is the final and correct solution (1) ★★★
    // We remove ALL sorting from the @Query to prevent the build error.
    // We will sort the array manually later.
    @Query private var allCards: [Card]
    
    @State private var selectedCardToEdit: Card?
    @State private var showingAddCardView = false

    // We now perform a safe, manual sort on the array AFTER it has been fetched.
    private var cards: [Card] {
        allCards
            .filter { $0.folder?.id == folder.id }
            .sorted { c1, c2 in
                // Rule 1: Starred cards come first.
                if c1.isStarred != c2.isStarred {
                    return c1.isStarred // isStarred (true) comes before not starred (false)
                }
                // Rule 2: Otherwise, sort by creation date (newest first).
                return c1.creationDate > c2.creationDate
            }
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
                                onStar: { self.toggleStar(for: card) },
                                onDelete: { self.deleteCard(card: card) }
                            )
                        }
                    }
                    .padding()
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
        .sheet(isPresented: $showingAddCardView) { CardEditView(folder: folder) }
        .sheet(item: $selectedCardToEdit) { card in CardEditView(cardToEdit: card) }
    }

    private func deleteCard(card: Card) {
        withAnimation { modelContext.delete(card) }
    }
    
    private func toggleStar(for card: Card) {
        withAnimation {
            card.isStarred.toggle()
        }
    }
}

// MARK: - CardRowView

private struct CardRowView: View {
    let card: Card
    let onEdit: () -> Void
    let onStar: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onEdit) {
            HStack(spacing: 0) {
                Color.accentColor.frame(width: 5)
                
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
                
                Button(action: onStar) {
                    Image(systemName: card.isStarred ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(card.isStarred ? .yellow : .gray.opacity(0.5))
                        .padding()
                }
                .buttonStyle(.borderless)
            }
            .background(Color.elementBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: onStar) {
                Label(card.isStarred ? "スターを外す" : "スターを付ける", systemImage: card.isStarred ? "star.slash.fill" : "star.fill")
            }
            Button(action: onEdit) { Label("編集", systemImage: "pencil") }
            Button(role: .destructive, action: onDelete) { Label("削除", systemImage: "trash") }
        }
    }
}


// MARK: - Preview

#Preview {
    // This is the correct structure for a Preview with a do-catch block.
    // The view is returned implicitly at the end of the do block.
    // The catch block returns a Text view.
    // This resolves the 'Cannot use explicit return' error.
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Folder.self, configurations: config)
        
        let sampleFolder = Folder(name: "Test", orderIndex: 0)
        
        let card1 = Card(frontText: "Apple", backMeaning: "りんご", backEtymology: "", backExample: "", backExampleJP: "")
        card1.folder = sampleFolder
        let card2 = Card(frontText: "Banana", backMeaning: "バナナ", backEtymology: "", backExample: "", backExampleJP: "")
        card2.isStarred = true
        card2.folder = sampleFolder
        
        container.mainContext.insert(sampleFolder)
        container.mainContext.insert(card1)
        container.mainContext.insert(card2)
        
        return NavigationStack {
             CardListView(folder: sampleFolder)
                .modelContainer(container)
        }
        
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
