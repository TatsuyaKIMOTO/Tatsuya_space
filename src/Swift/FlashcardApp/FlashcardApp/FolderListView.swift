// FolderListView.swift
import SwiftUI
import SwiftData

// MARK: - FolderListView (親ビュー)
// データの管理と、Listの表示、ツールバーの管理に専念します。

struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    @Query private var allFolders: [Folder]
    
    @State private var showingAddSheet = false
    @State private var folderToEdit: Folder?
    @State private var searchText = ""

    private var sortedAndFilteredFolders: [Folder] {
        let sorted = allFolders.sorted { f1, f2 in
            if f1.isPinned != f2.isPinned { return f1.isPinned }
            return f1.orderIndex < f2.orderIndex
        }
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
                        // ForEachの中身を、新しく作る「部品」であるFolderRowに置き換えます。
                        ForEach(sortedAndFilteredFolders) { folder in
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
                    // ★★★ 不要で間違ったコードを削除しました ★★★
                    // ListはツールバーのEditButtonから環境を自動で受け取るため、この行は不要です。
                    // .environment(\.editMode, self.editMode)
                }
            }
            .navigationTitle("マイフォルダ")
            .toolbar { toolbarItems() }
            .sheet(isPresented: $showingAddSheet) { AddFolderView(currentFolderCount: allFolders.count) }
            .sheet(item: $folderToEdit) { folder in AddFolderView(folderToEdit: folder) }
            .searchable(text: $searchText, prompt: "フォルダを検索")
        }
    }

    // MARK: - Toolbar & Functions
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if self.editMode?.wrappedValue.isEditing == false {
                Button {
                    self.folderToEdit = nil
                    self.showingAddSheet = true
                } label: { Image(systemName: "plus.circle.fill").font(.title2) }
            }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            if !allFolders.isEmpty { EditButton() }
        }
    }
    
    private func deleteFoldersWithOffsets(offsets: IndexSet) {
        withAnimation {
            let foldersToDelete = offsets.map { self.sortedAndFilteredFolders[$0] }
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
        var reorderedFolders = self.sortedAndFilteredFolders
        reorderedFolders.move(fromOffsets: source, toOffset: destination)
        self.updateOrderIndexes(for: reorderedFolders)
    }
    private func togglePin(for folder: Folder) {
        withAnimation { folder.isPinned.toggle() }
    }
    private func updateOrderIndexes(for updatedList: [Folder]? = nil) {
        let listToUpdate = updatedList ?? self.allFolders.sorted { f1, f2 in
            if f1.isPinned != f2.isPinned { return f1.isPinned }
            return f1.orderIndex < f2.orderIndex
        }
        for (index, folder) in listToUpdate.enumerated() {
            if folder.orderIndex != index { folder.orderIndex = index }
        }
    }
}


// MARK: - FolderRow (新しく作成する、フォルダ一行の表示と機能を管理する専用ビュー)

private struct FolderRow: View {
    @Environment(\.editMode) private var editMode
    
    let folder: Folder
    let onEdit: () -> Void
    let onPin: () -> Void
    let onDelete: () -> Void

    private var isEditing: Bool {
        self.editMode?.wrappedValue.isEditing ?? false
    }

    // ★★★ これが問題解決の核心部分です ★★★
    // 編集モードの状態に応じて、返すビューの「種類」そのものを切り替えます。
    var body: some View {
        if self.isEditing {
            // 【編集モード時】多機能な編集コントロールを持つHStackを表示します。
            editModeView
        } else {
            // 【通常モード時】画面遷移と長押しメニューを持つNavigationLinkを表示します。
            normalModeView
        }
    }

    // 【通常モード専用ビュー】
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
    
    // 【編集モード専用ビュー】
    private var editModeView: some View {
        HStack(spacing: 15) {
            // ① 名前変更ボタン (鉛筆アイコン)
            Button(action: self.onEdit) {
                Image(systemName: "pencil.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.borderless)

            // フォルダ名
            Text(self.folder.name)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
            
            // ② ピン留め切り替えボタン
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


// MARK: - Preview (プレビューコードも完全に動作するものに修正)

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Folder.self, configurations: config)
        
        let folder1 = Folder(name: "TOIC頻出単語", orderIndex: 0)
        let folder2 = Folder(name: "日常英会話", orderIndex: 1)
        folder2.isPinned = true
        container.mainContext.insert(folder1)
        container.mainContext.insert(folder2)
        
        return FolderListView()
            .modelContainer(container)
        
    } catch {
        return Text("プレビューの作成に失敗しました: \(error.localizedDescription)")
    }
}
