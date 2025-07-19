//
//  Item.swift
//  FlashcardApp
//
//  Created by Tatsuya KIMOTO on 2025/07/19.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
