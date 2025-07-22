// FolderListView.swift
import SwiftUI
import SwiftData

// MARK: - FolderListView (Parent View)

struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    
    // ★★★ This is the final and correct solution. ★★★
    // We remove ALL sorting from the @Query macro to prevent compiler errors.
    @Query private var folders: [Folder]
    
    @State private var showingAddSheet = false
    @State private var folderToEdit: Folder?
    @State private var searchText = ""

    // We now perform a safe, manual sort on the array AFTER it has been fetched.
    private var sortedFolders: [Folder] {
        folders.sorted { f1, f2 in
            if f1.isPinned != f2.isPinned {
                return f1.isPinned // Pinned (true) comes first
            } else {
                return f1.orderIndex < f2.orderIndex // Then sort by orderIndex
            }
        }
    }

    private var searchResults: [Folder] {
        if searchText.isEmpty {
            return sortedFolders
        } else {
            return sortedFolders.filter { folder in
                folder.name.localizedStandardContains(searchText) ||
                (folder.cards?.contains(where: { card in
                    card.frontText.localizedStandardContains(searchText)
                }) ?? false)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if folders.isEmpty && searchText.isEmpty {
                    ContentUnavailableView("フォルダがありません", systemImage: "folder.badge.plus", description: Text("右上の「+」ボタンから新しいフォルダを追加してください。"))
                } else {
                    List {
                        ForEach(searchResults) { folder in
                            FolderRow(
                                folder: folder,
                                onEdit: { self.folderToEdit = folder },
                                onPin: { self.togglePin(for: folder) },
                                onDelete: { self.deleteFolder(folder) }
                            )
                        }
                        .onDelete(perform: deleteFoldersWithOffsets)
                        .onMove(perform: moveFolder)
                        .listRowBackground(Color.elementBackground)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("マイフォルダ")
            .toolbar { toolbarItems() }
            .sheet(isPresented: $showingAddSheet) { AddFolderView(currentFolderCount: folders.count) }
            .sheet(item: $folderToEdit) { folder in AddFolderView(folderToEdit: folder) }
            .searchable(text: $searchText, prompt: "フォルダやカードを検索")
        }
    }

    // MARK: - Toolbar & Functions
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if !folders.isEmpty {
                EditButton()
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                self.folderToEdit = nil
                self.showingAddSheet = true
            } label: { Image(systemName: "plus") }
        }
    }
    
    private func deleteFoldersWithOffsets(offsets: IndexSet) {
        withAnimation {
            let foldersToDelete = offsets.map { self.searchResults[$0] }
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
        var reorderedFolders = self.searchResults
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


// MARK: - FolderRow (No Changes)

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
        NavigationLink(destination: CardListView(folder: folder)) {
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


// MARK: - Preview (No Changes)

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Folder.self, configurations: config)
        
        let folder1 = Folder(name: "TOEIC Words", orderIndex: 0)
        let card1 = Card(frontText: "Apple", backMeaning: "りんご", backEtymology: "", backExample: "", backExampleJP: "")
        card1.folder = folder1
        
        let folder2 = Folder(name: "Phrases", orderIndex: 1)
        folder2.isPinned = true
        let card2 = Card(frontText: "Banana", backMeaning: "バナナ", backEtymology: "", backExample: "", backExampleJP: "")
        card2.folder = folder2

        container.mainContext.insert(folder1)
        container.mainContext.insert(card1)
        container.mainContext.insert(folder2)
        container.mainContext.insert(card2)
        
        return FolderListView()
            .modelContainer(container)
        
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
