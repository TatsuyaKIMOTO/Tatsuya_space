// FlashcardAppApp.swift
import SwiftUI
import SwiftData

@main
struct FlashcardAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Folder.self,
            Card.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FolderListView() // ここをContentViewからFolderListViewに変更
        }
        .modelContainer(sharedModelContainer)
    }
}
