// FlashcardAppApp.swift
import SwiftUI
import SwiftData

@main
struct FlashcardAppApp: App {
    let container: ModelContainer
    
    init() {
        let schema = Schema([Folder.self, Card.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            FolderListView()
        }
        .modelContainer(container)
    }
}
