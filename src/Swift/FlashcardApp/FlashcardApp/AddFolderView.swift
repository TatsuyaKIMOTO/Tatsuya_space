// AddFolderView.swift
import SwiftUI
import SwiftData

struct AddFolderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var folderToEdit: Folder?
    var currentFolderCount: Int?
    
    @State private var folderName: String = ""
    
    var navigationTitle: String {
        folderToEdit == nil ? "新しいフォルダ" : "フォルダ名を変更"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("フォルダ名")) {
                    TextField("例：日常英会話", text: $folderName)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("キャンセル") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveFolder()
                        dismiss()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
            .onAppear(perform: loadFolderData)
        }
    }
    
    private func loadFolderData() {
        if let folder = folderToEdit { folderName = folder.name }
    }
    
    private func saveFolder() {
        if let folder = folderToEdit {
            folder.name = folderName
            folder.timestamp = Date()
        } else {
            let newFolder = Folder(name: folderName, orderIndex: currentFolderCount ?? 0)
            modelContext.insert(newFolder)
        }
    }
}
