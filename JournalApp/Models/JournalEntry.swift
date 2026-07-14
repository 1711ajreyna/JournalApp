//
//  JournalEntry.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import Foundation
import SwiftData

// @Model tells SwiftData that JournalEntry should be
// saved persistently on the device.
//
// SwiftData models must be classes rather than structs.
@Model
final class JournalEntry {

    // MARK: - Required Properties

    // The title displayed in the journal list.
    var title: String

    // The full written content of the journal entry.
    var body: String

    // The date the entry was created or assigned.
    var date: Date

    // MARK: - Additional Assignment Features

    // Stores a category such as Work, Personal, or School.
    var category: String

    // Tracks whether the user marked the entry as a favorite.
    var isFavorite: Bool

    // Tracks whether the entry has been archived.
    var isArchived: Bool

    // Creates a new journal entry.
    //
    // Default values make it easier to create new entries.
    init(
        title: String,
        body: String,
        date: Date = .now,
        category: String = "Personal",
        isFavorite: Bool = false,
        isArchived: Bool = false
    ) {
        self.title = title
        self.body = body
        self.date = date
        self.category = category
        self.isFavorite = isFavorite
        self.isArchived = isArchived
    }
}
