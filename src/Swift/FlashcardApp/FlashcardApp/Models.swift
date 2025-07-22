// Models.swift
import Foundation
import SwiftData

@Model
final class Folder {
    var id: UUID
    var name: String
    var timestamp: Date
    var isPinned: Bool
    var orderIndex: Int

    @Relationship(deleteRule: .cascade, inverse: \Card.folder)
    var cards: [Card]?

    init(name: String, orderIndex: Int) {
        self.id = UUID()
        self.name = name
        self.timestamp = Date()
        self.isPinned = false
        self.orderIndex = orderIndex
    }
}

@Model
final class Card {
    var id: UUID
    var creationDate: Date
    var frontText: String
    var backMeaning: String
    var backEtymology: String
    var backExample: String
    var backExampleJP: String
    var folder: Folder?

    init(frontText: String, backMeaning: String, backEtymology: String, backExample: String, backExampleJP: String) {
        self.id = UUID()
        self.creationDate = Date()
        self.frontText = frontText
        self.backMeaning = backMeaning
        self.backEtymology = backEtymology
        self.backExample = backExample
        self.backExampleJP = backExampleJP
    }
}
