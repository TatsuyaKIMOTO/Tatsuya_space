// Models.swift
import Foundation
import SwiftData

// フォルダのデータモデル
@Model
final class Folder {
    var id: UUID
    var name: String
    var timestamp: Date

    // フォルダが削除されたら、中のカードも一緒に削除される設定 (cascade)
    @Relationship(deleteRule: .cascade, inverse: \Card.folder)
    var cards: [Card]? // このフォルダに属するカードのリスト

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.timestamp = Date()
    }
}

// 単語カードのデータモデル
@Model
final class Card {
    var id: UUID
    var frontText: String       // 表面: 単語
    var backMeaning: String     // 裏面: 意味
    var backEtymology: String   // 裏面: 語源
    var backExample: String     // 裏面: 例文
    var backExampleJP: String   // 裏面: 例文の日本語訳

    var folder: Folder? // このカードが属するフォルダ

    init(frontText: String, backMeaning: String, backEtymology: String, backExample: String, backExampleJP: String) {
        self.id = UUID()
        self.frontText = frontText
        self.backMeaning = backMeaning
        self.backEtymology = backEtymology
        self.backExample = backExample
        self.backExampleJP = backExampleJP
    }
}
