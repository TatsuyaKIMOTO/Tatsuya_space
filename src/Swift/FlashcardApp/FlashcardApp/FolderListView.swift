import SwiftUI
import SwiftData

struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.timestamp, order: .reverse) private var folders: [Folder]
    
    @State private var showingAddFolderView = false
    @State private var errorMessage: String? = nil  // エラー表示用
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if folders.isEmpty {
                    ContentUnavailableView("フォルダがありません",
                                           systemImage: "folder.badge.plus",
                                           description: Text("右上の「+」ボタンから新しいフォルダを追加してください。"))
                } else {
                    List {
                        ForEach(folders) { folder in
                            NavigationLink(destination: CardListView(folder: folder)) {
                                HStack(spacing: 15) {
                                    Image(systemName: "folder.fill")
                                        .font(.title)
                                        .foregroundColor(.accent)
                                    
                                    VStack(alignment: .leading) {
                                        Text(folder.name)
                                            .font(.headline)
                                        // 修正：非Optionalとして直接アクセス
                                        Text("作成日時: \(folder.timestamp.formatted(date: .numeric, time: .shortened))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("カード \(folder.cards?.count ?? 0)枚")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 8)
                                .contentShape(Rectangle()) // タップ領域拡大
                            }
                        }
                        .onDelete(perform: deleteFolders)
                        .listRowBackground(Color.elementBackground)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("マイフォルダ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddFolderView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("フォルダ追加")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !folders.isEmpty {
                        EditButton()
                            .accessibilityLabel("編集モード切替")
                    }
                }
            }
            .sheet(isPresented: $showingAddFolderView) {
                AddFolderView { result in
                    showingAddFolderView = false
                    switch result {
                    case .success(let folderName):
                        addFolder(named: folderName)
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .alert("エラー", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private func addFolder(named name: String) {
        if folders.contains(where: { $0.name == name }) {
            errorMessage = "同じ名前のフォルダが既に存在します。"
            return
        }
        let newFolder = Folder(name: name)
        modelContext.insert(newFolder)
        do {
            try modelContext.save()
        } catch {
            errorMessage = "フォルダの保存に失敗しました: \(error.localizedDescription)"
        }
    }
    
    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.map { folders[$0] }.forEach { modelContext.delete($0) }
            do {
                try modelContext.save()
            } catch {
                errorMessage = "削除の保存に失敗しました: \(error.localizedDescription)"
            }
        }
    }
}

// 以下 AddFolderView は以前のままで問題ありません
struct AddFolderView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var folderName: String = ""
    @State private var errorMessage: String? = nil
    
    var onComplete: (Result<String, Error>) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("フォルダ名", text: $folderName)
                        .accessibilityLabel("フォルダ名入力")
                }
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("新しいフォルダ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            errorMessage = "フォルダ名を入力してください。"
                            return
                        }
                        onComplete(.success(folderName))
                        dismiss()
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onDisappear {
                folderName = ""
                errorMessage = nil
            }
        }
    }
}
