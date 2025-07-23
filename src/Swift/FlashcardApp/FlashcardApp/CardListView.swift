// CardListView.swift
import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var folder: Folder
    
    // MARK: - State Properties
    
    @State private var searchText = ""
    @State private var showingStarredOnly = false
    @State private var sortOrder = SortOrder.creationDateDescending
    
    @State private var selectedCardToEdit: Card?
    @State private var showingAddCardView = false

    // Enum to define the available sort options
    enum SortOrder: String, CaseIterable, Identifiable {
        case creationDateDescending = "作成日（新しい順）"
        case creationDateAscending = "作成日（古い順）"
        case alphabeticalAscending = "単語順（A→Z）"
        case alphabeticalDescending = "単語順（Z→A）"
        
        var id: String { self.rawValue }
    }
    
    // Manually filter and sort the cards based on the state properties
    private var filteredAndSortedCards: [Card] {
        guard let allCardsInFolder = folder.cards else { return [] }
        
        // 1. Filter by starred status
        let starredFiltered = showingStarredOnly ? allCardsInFolder.filter { $0.isStarred } : allCardsInFolder
        
        // 2. Filter by search text
        let searchFiltered: [Card]
        if searchText.isEmpty {
            searchFiltered = Array(starredFiltered)
        } else {
            searchFiltered = starredFiltered.filter { card in
                card.frontText.localizedCaseInsensitiveContains(searchText) ||
                card.backMeaning.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // 3. Sort by the selected order
        switch sortOrder {
        case .creationDateDescending:
            return searchFiltered.sorted { $0.creationDate > $1.creationDate }
        case .creationDateAscending:
            return searchFiltered.sorted { $0.creationDate < $1.creationDate }
        case .alphabeticalAscending:
            return searchFiltered.sorted { $0.frontText.localizedCaseInsensitiveCompare($1.frontText) == .orderedAscending }
        case .alphabeticalDescending:
            return searchFiltered.sorted { $0.frontText.localizedCaseInsensitiveCompare($1.frontText) == .orderedDescending }
        }
    }

    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if filteredAndSortedCards.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else if folder.cards?.isEmpty ?? true {
                ContentUnavailableView("カードがありません", systemImage: "square.on.square.badge.person.crop", description: Text("右上の「+」ボタンから新しい単語カードを追加してください。"))
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        if !filteredAndSortedCards.isEmpty {
                            NavigationLink(destination: FlashcardView(cards: filteredAndSortedCards)) {
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
                        }
                        
                        ForEach(filteredAndSortedCards) { card in
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
        .searchable(text: $searchText, prompt: "このフォルダのカードを検索")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Picker("並び替え", selection: $sortOrder) {
                        ForEach(SortOrder.allCases) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    
                    Toggle(isOn: $showingStarredOnly) {
                        Label("スター付きのみ", systemImage: "star.fill")
                    }
                    
                } label: {
                    Label("表示オプション", systemImage: "ellipsis.circle")
                }
                
                Button { showingAddCardView = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCardView) { CardEditView(folder: folder) }
        .sheet(item: $selectedCardToEdit) { card in CardEditView(cardToEdit: card) }
    }
    
    private func deleteCard(card: Card) {
        withAnimation {
            modelContext.delete(card)
        }
    }
    
    private func toggleStar(for card: Card) {
        withAnimation {
            card.isStarred.toggle()
        }
    }
}

// MARK: - CardRowView (Complete Implementation)

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


// MARK: - Preview (Final, Corrected Version)

#Preview {
    // This is the simplest, most reliable way to create a preview.
    // It avoids the do-catch and explicit return statements that cause errors.
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Folder.self, configurations: config)
    
    let sampleFolder = Folder(name: "Test", orderIndex: 0)
    
    let card1 = Card(frontText: "Apple", backMeaning: "りんご", backEtymology: "", backExample: "", backExampleJP: "")
    card1.folder = sampleFolder
    
    let card2 = Card(frontText: "Banana", backMeaning: "バナナ", backEtymology: "", backExample: "", backExampleJP: "")
    card2.isStarred = true
    card2.folder = sampleFolder
    
    container.mainContext.insert(sampleFolder)
    container.mainContext.insert(card1)
    // This typo has been corrected.
    container.mainContext.insert(card2)

    return NavigationStack {
         CardListView(folder: sampleFolder)
            .modelContainer(container)
    }
}
