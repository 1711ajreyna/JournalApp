//
//  JournalEntry.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var title: String
    var body: String
    var date: Date
    var category: String
    var tags: String
    var isFavorite: Bool
    var isArchived: Bool

    init(
        title: String,
        body: String,
        date: Date = .now,
        category: String = "Personal",
        tags: String = "",
        isFavorite: Bool = false,
        isArchived: Bool = false
    ) {
        self.title = title
        self.body = body
        self.date = date
        self.category = category
        self.tags = tags
        self.isFavorite = isFavorite
        self.isArchived = isArchived
    }
}
