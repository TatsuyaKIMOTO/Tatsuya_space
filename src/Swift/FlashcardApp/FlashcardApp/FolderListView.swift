// FolderListView.swift
import SwiftUI
import SwiftData

// MARK: - FolderListView (Parent View)

struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var folders: [Folder]
    
    @State private var showingAddSheet = false
    @State private var folderToEdit: Folder?
    @State private var searchText = ""

    private var sortedFolders: [Folder] {
        folders.sorted { f1, f2 in
            if f1.isPinned != f2.isPinned {
                return f1.isPinned
            } else {
                return f1.orderIndex < f2.orderIndex
            }
        }
    }

    @Query(sort: \Card.creationDate, order: .reverse) private var allCards: [Card]
    
    private var cardSearchResults: [Card] {
        if searchText.isEmpty {
            return []
        }
        return allCards.filter {
            $0.frontText.localizedStandardContains(searchText)
        }
    }


    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if !searchText.isEmpty {
                    cardSearchResultsView
                } else {
                    folderListView
                }
            }
            .navigationTitle("マイフォルダ")
            // ★★★ 修正点 1 ★★★
            // NavigationStackに対して、どのようなデータ型(ここではFolder)が渡されたら
            // どのビュー(CardListView)に遷移するかのルールを定義します。
            .navigationDestination(for: Folder.self) { folder in
                CardListView(folder: folder)
            }
            .toolbar { toolbarItems() }
            .sheet(isPresented: $showingAddSheet) { AddFolderView(currentFolderCount: folders.count) }
            .sheet(item: $folderToEdit) { folder in AddFolderView(folderToEdit: folder) }
            .searchable(text: $searchText, prompt: "フォルダやカードを検索")
        }
    }
    
    // MARK: - Subviews

    @ViewBuilder
    private var folderListView: some View {
        if folders.isEmpty {
            ContentUnavailableView("フォルダがありません", systemImage: "folder.badge.plus", description: Text("右上の「+」ボタンから新しいフォルダを追加してください。"))
        } else {
            List {
                ForEach(sortedFolders) { folder in
                    FolderRow(
                        folder: folder,
                        onEdit: { self.folderToEdit = folder },
                        onPin: { self.togglePin(for: folder) },
                        onDelete: { self.deleteFolder(folder) }
                    )
                }
                .onDelete(perform: deleteFoldersWithOffsets)
                .onMove(perform: moveFolder)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var cardSearchResultsView: some View {
        if cardSearchResults.isEmpty {
            ContentUnavailableView("見つかりませんでした", systemImage: "magnifyingglass", description: Text(" \"\(searchText)\" に一致するカードはありません。"))
        } else {
            List {
                ForEach(cardSearchResults) { card in
                    if let folder = card.folder {
                        // ★★★ 修正点 2 ★★★
                        // 遷移先のビューを直接指定する destination: ではなく、
                        // 遷移のトリガーとなるデータ(folder)を value: で渡します。
                        NavigationLink(value: folder) {
                            CardSearchResultRow(card: card)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }


    // MARK: - Toolbar & Functions
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if !folders.isEmpty && searchText.isEmpty {
                EditButton()
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                self.showingAddSheet = true
            } label: { Image(systemName: "plus") }
        }
    }
    
    private func deleteFoldersWithOffsets(offsets: IndexSet) {
        withAnimation {
            let foldersToDelete = offsets.map { self.sortedFolders[$0] }
            for folder in foldersToDelete { self.modelContext.delete(folder) }
            self.updateOrderIndexes()
        }
    }
    
    private func deleteFolder(_ folder: Folder) {
        withAnimation {
            self.modelContext.delete(folder)
            self.updateOrderIndexes()
        }
    }
    
    private func moveFolder(from source: IndexSet, to destination: Int) {
        guard self.searchText.isEmpty else { return }
        var reorderedFolders = self.sortedFolders
        reorderedFolders.move(fromOffsets: source, toOffset: destination)
        self.updateOrderIndexes(for: reorderedFolders)
    }
    
    private func togglePin(for folder: Folder) {
        withAnimation { folder.isPinned.toggle() }
    }
    
    private func updateOrderIndexes(for updatedList: [Folder]? = nil) {
        let listToUpdate = updatedList ?? self.sortedFolders
        
        for (index, folder) in listToUpdate.enumerated() {
            if folder.orderIndex != index {
                folder.orderIndex = index
            }
        }
    }
}


// MARK: - FolderRow

private struct FolderRow: View {
    @Environment(\.editMode) private var editMode
    
    let folder: Folder
    let onEdit: () -> Void
    let onPin: () -> Void
    let onDelete: () -> Void

    private var isEditing: Bool {
        self.editMode?.wrappedValue.isEditing ?? false
    }

    var body: some View {
        if self.isEditing {
            editModeView
        } else {
            normalModeView
        }
    }
    
    private var normalModeView: some View {
        // ★★★ 修正点 3 ★★★
        // こちらの NavigationLink も同様に value: を使う形式に変更します。
        NavigationLink(value: folder) {
            HStack(spacing: 15) {
                Image(systemName: "folder.fill").font(.title).foregroundColor(.accent)
                VStack(alignment: .leading) {
                    Text(self.folder.name).font(.headline)
                    Text("カード \(self.folder.cards?.count ?? 0)枚").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                if self.folder.isPinned {
                    Image(systemName: "pin.fill").foregroundColor(.secondary).font(.caption)
                }
            }
            .padding(.vertical, 8)
        }
        .contextMenu {
            Button(action: self.onEdit) { Label("名前を変更", systemImage: "pencil") }
            Button(action: self.onPin) { Label(self.folder.isPinned ? "ピンを外す" : "ピン留め", systemImage: self.folder.isPinned ? "pin.slash.fill" : "pin.fill") }
            Divider()
            Button(role: .destructive, action: self.onDelete) { Label("削除", systemImage: "trash") }
        }
    }
    
    private var editModeView: some View {
        HStack(spacing: 15) {
            Button(action: self.onEdit) {
                Image(systemName: "pencil.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.borderless)

            Text(self.folder.name)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: self.onPin) {
                Image(systemName: self.folder.isPinned ? "pin.circle.fill" : "pin.circle")
                    .font(.title2)
                    .foregroundColor(self.folder.isPinned ? .yellow : .secondary)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - CardSearchResultRow

private struct CardSearchResultRow: View {
    let card: Card

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(card.frontText)
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            Text(card.backMeaning)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            if let folderName = card.folder?.name {
                HStack {
                    Image(systemName: "folder.fill")
                    Text(folderName)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.elementBackground)
        .cornerRadius(12)
    }
}


// MARK: - Preview

#Preview {
    FolderListView()
        .modelContainer(for: [Folder.self, Card.self], inMemory: true)
}
