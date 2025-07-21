// FolderListView.swift
import SwiftUI
import SwiftData

struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    // @Queryではソートを行わず、全件取得に専念します。
    @Query private var allFolders: [Folder]
    
    @State private var showingAddSheet = false
    @State private var folderToEdit: Folder?
    @State private var searchText = ""

    // ソートとフィルタリングをコードで手動で行う算出プロパティです。
    // これにより、コンパイラのエラーを確実に回避します。
    private var sortedAndFilteredFolders: [Folder] {
        // 先にソート処理
        let sorted = allFolders.sorted { folder1, folder2 in
            // ルール1: ピン留めの状態が違うなら、ピン留めされた方を常に前にする
            if folder1.isPinned != folder2.isPinned {
                return folder1.isPinned
            }
            // ルール2: ピン留めの状態が同じなら、orderIndexが小さい方を前にする
            return folder1.orderIndex < folder2.orderIndex
        }
        
        // 次に検索フィルタを適用
        if searchText.isEmpty {
            return sorted
        } else {
            return sorted.filter { $0.name.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                if allFolders.isEmpty {
                    ContentUnavailableView("フォルダがありません", systemImage: "folder.badge.plus", description: Text("右上の「+」ボタンから新しいフォルダを追加してください。"))
                } else {
                    List {
                        // 表示するデータを、手動でソート・フィルタした新しい配列に変更します。
                        ForEach(sortedAndFilteredFolders) { folder in
                            NavigationLink(destination: CardListView(folder: folder)) {
                                folderRow(for: folder)
                            }
                            .contextMenu { contextMenuItems(for: folder) }
                        }
                        .onDelete(perform: deleteFoldersWithOffsets)
                        .onMove(perform: moveFolder)
                        .listRowBackground(Color.elementBackground)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .animation(.default, value: sortedAndFilteredFolders)
                    .environment(\.editMode, editMode)
                }
            }
            .navigationTitle("マイフォルダ")
            .toolbar { toolbarItems() }
            .sheet(isPresented: $showingAddSheet) { AddFolderView(currentFolderCount: allFolders.count) }
            .sheet(item: $folderToEdit) { folder in AddFolderView(folderToEdit: folder) }
            .searchable(text: $searchText, prompt: "フォルダを検索")
        }
    }

    // MARK: - Subviews (省略せずに完全に記述)

    private func folderRow(for folder: Folder) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "folder.fill").font(.title).foregroundColor(.accent)
            VStack(alignment: .leading) {
                Text(folder.name).font(.headline)
                Text("カード \(folder.cards?.count ?? 0)枚").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            if folder.isPinned {
                Image(systemName: "pin.fill").foregroundColor(.secondary).font(.caption)
            }
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func contextMenuItems(for folder: Folder) -> some View {
        if editMode?.wrappedValue.isEditing == false {
            Button { folderToEdit = folder } label: { Label("名前を変更", systemImage: "pencil") }
            Button { togglePin(for: folder) } label: { Label(folder.isPinned ? "ピンを外す" : "ピン留め", systemImage: folder.isPinned ? "pin.slash.fill" : "pin.fill") }
            Divider()
            Button(role: .destructive) { deleteFolder(folder: folder) } label: { Label("削除", systemImage: "trash") }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                folderToEdit = nil
                showingAddSheet = true
            } label: { Image(systemName: "plus.circle.fill").font(.title2) }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            if !allFolders.isEmpty { EditButton() }
        }
    }

    // MARK: - Functions (省略せずに完全に記述)

    private func deleteFoldersWithOffsets(offsets: IndexSet) {
        withAnimation {
            let foldersToDelete = offsets.map { sortedAndFilteredFolders[$0] }
            for folder in foldersToDelete {
                modelContext.delete(folder)
            }
            updateOrderIndexes()
        }
    }
    
    private func deleteFolder(folder: Folder) {
        withAnimation {
            modelContext.delete(folder)
            updateOrderIndexes()
        }
    }
    
    private func moveFolder(from source: IndexSet, to destination: Int) {
        guard searchText.isEmpty else { return }
        
        var reorderedFolders = allFolders.sorted { f1, f2 in
            if f1.isPinned != f2.isPinned { return f1.isPinned }
            return f1.orderIndex < f2.orderIndex
        }
        reorderedFolders.move(fromOffsets: source, toOffset: destination)
        
        updateOrderIndexes(for: reorderedFolders)
    }
    
    private func togglePin(for folder: Folder) {
        withAnimation { folder.isPinned.toggle() }
    }
    
    private func updateOrderIndexes(for updatedList: [Folder]? = nil) {
        let listToUpdate = updatedList ?? allFolders.sorted { f1, f2 in
            if f1.isPinned != f2.isPinned { return f1.isPinned }
            return f1.orderIndex < f2.orderIndex
        }
        
        for (index, folder) in listToUpdate.enumerated() {
            if folder.orderIndex != index {
                folder.orderIndex = index
            }
        }
    }
}
