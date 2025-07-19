// FolderListView.swift
import SwiftUI
import SwiftData

struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.timestamp, order: .reverse) private var folders: [Folder]
    
    @State private var showingAddFolderView = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色を設定
                Color.appBackground.ignoresSafeArea()
                
                // フォルダがない場合の表示
                if folders.isEmpty {
                    ContentUnavailableView("フォルダがありません", systemImage: "folder.badge.plus", description: Text("右上の「+」ボタンから新しいフォルダを追加してください。"))
                } else {
                    List {
                        ForEach(folders) { folder in
                            NavigationLink(destination: CardListView(folder: folder)) {
                                HStack(spacing: 15) {
                                    Image(systemName: "folder.fill")
                                        .font(.title)
                                        .foregroundColor(.accent) // テーマカラーを使用
                                    
                                    VStack(alignment: .leading) {
                                        Text(folder.name)
                                            .font(.headline)
                                        Text("カード \(folder.cards?.count ?? 0)枚")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .onDelete(perform: deleteFolders)
                        // 行の背景色と区切り線を調整
                        .listRowBackground(Color.elementBackground)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain) // Listのスタイルを変更して背景色を活かす
                }
            }
            .navigationTitle("マイフォルダ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddFolderView = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !folders.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddFolderView) {
                // この部分で 'AddFolderView' が呼び出されている
                AddFolderView()
            }
        }
    }

    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(folders[index])
            }
        }
    }
}

// ↓↓↓ ここからが重要です！このコードがファイルに含まれているか確認してください。 ↓↓↓

// フォルダ追加用のビュー
struct AddFolderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var folderName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("フォルダ名", text: $folderName)
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
                        addFolder()
                        dismiss()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
        }
    }
    
    private func addFolder() {
        if !folderName.isEmpty {
            let newFolder = Folder(name: folderName)
            modelContext.insert(newFolder)
        }
    }
}

// プレビュー用のコード（ビルドエラーとは直接関係ありませんが、含めておきます）
#Preview {
    FolderListView()
        .modelContainer(for: Folder.self, inMemory: true)
}
