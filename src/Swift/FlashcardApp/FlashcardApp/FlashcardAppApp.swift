import SwiftUI
import SwiftData

@main
struct FlashcardAppApp: App {
    let sharedModelContainer: ModelContainer = {
        do {
            return try createModelContainer()
        } catch {
            // ここでユーザー通知やリトライも検討可能
            print("ModelContainerの作成に失敗しました: \(error.localizedDescription)")
            return try! createInMemoryModelContainer()
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            FolderListView()
                .environment(\.modelContext, sharedModelContainer.mainContext)
                .task {
                    await setupInitialDataIfNeeded()
                }
        }
    }
    
    // MARK: - ModelContainer生成
    
    static func createModelContainer() throws -> ModelContainer {
        let schema = Schema([Folder.self, Card.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [config])
    }
    
    static func createInMemoryModelContainer() throws -> ModelContainer {
        let schema = Schema([Folder.self, Card.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }
    
    // MARK: - 初期データ設定
    
    func setupInitialDataIfNeeded() async {
        let fetchRequest = FetchDescriptor<Folder>()
        do {
            let folders = try sharedModelContainer.mainContext.fetch(fetchRequest)
            if folders.isEmpty {
                let newFolder = Folder(name: "はじめてのフォルダ")
                sharedModelContainer.mainContext.insert(newFolder)
                do {
                    try sharedModelContainer.mainContext.save()
                    print("初期フォルダを作成しました。")
                } catch {
                    print("フォルダの保存に失敗しました: \(error.localizedDescription)")
                }
            }
        } catch {
            print("初期データ取得に失敗しました: \(error.localizedDescription)")
        }
    }
}
