//
//  JournalViewModel.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Handles journal validation, filtering, sorting,
//  and SwiftData operations.
//

import Foundation
import Observation
import SwiftData

// Represents the available journal sorting options.
enum EntrySortOrder: String, CaseIterable, Identifiable {
    case newest = "Newest"
    case oldest = "Oldest"

    var id: String {
        rawValue
    }
}

// @Observable allows SwiftUI views to react to changes
// made to properties in this ViewModel.
@Observable
final class JournalViewModel {

    // MARK: - Search and Filter State

    var searchText = ""
    var selectedCategory = "All"
    var sortOrder: EntrySortOrder = .newest

    // Categories displayed in the filter section.
    let categories = [
        "All",
        "Personal",
        "Work",
        "School",
        "Favorites"
    ]

    // MARK: - Filtering and Sorting

    // Filters entries by archive status, category, title,
    // body content, and tags.
    func filteredEntries(
        from entries: [JournalEntry]
    ) -> [JournalEntry] {

        let results = entries.filter { entry in

            // Archived entries should not appear
            // in the main journal list.
            let matchesArchive = !entry.isArchived

            let matchesCategory: Bool

            if selectedCategory == "All" {
                matchesCategory = true
            } else if selectedCategory == "Favorites" {
                matchesCategory = entry.isFavorite
            } else {
                matchesCategory =
                    entry.category == selectedCategory
            }

            // Search the title, body, and tags.
            let matchesSearch =
                searchText.isEmpty ||
                entry.title.localizedCaseInsensitiveContains(
                    searchText
                ) ||
                entry.body.localizedCaseInsensitiveContains(
                    searchText
                ) ||
                entry.tags.localizedCaseInsensitiveContains(
                    searchText
                )

            return matchesArchive &&
                   matchesCategory &&
                   matchesSearch
        }

        switch sortOrder {
        case .newest:
            return results.sorted {
                $0.date > $1.date
            }

        case .oldest:
            return results.sorted {
                $0.date < $1.date
            }
        }
    }

    // Returns the number of entries in a category.
    func entryCount(
        for category: String,
        from entries: [JournalEntry]
    ) -> Int {

        entries.filter { entry in
            guard !entry.isArchived else {
                return false
            }

            if category == "All" {
                return true
            }

            if category == "Favorites" {
                return entry.isFavorite
            }

            return entry.category == category
        }
        .count
    }

    // MARK: - Entry Validation

    // Returns true when the title and body contain text.
    func isValidEntry(
        title: String,
        body: String
    ) -> Bool {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanBody = body.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return !cleanTitle.isEmpty &&
               !cleanBody.isEmpty
    }

    // MARK: - SwiftData Operations

    // Validates and inserts a new journal entry.
    //
    // Returns true when the entry was successfully created.
    @discardableResult
    func addEntry(
        title: String,
        body: String,
        date: Date,
        category: String,
        tags: String,
        isFavorite: Bool,
        context: ModelContext
    ) -> Bool {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanBody = body.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanTags = cleanedTags(from: tags)

        guard isValidEntry(
            title: cleanTitle,
            body: cleanBody
        ) else {
            return false
        }

        let entry = JournalEntry(
            title: cleanTitle,
            body: cleanBody,
            date: date,
            category: category,
            tags: cleanTags,
            isFavorite: isFavorite
        )

        context.insert(entry)
        return true
    }

    // Toggles the favorite status of an entry.
    func toggleFavorite(_ entry: JournalEntry) {
        entry.isFavorite.toggle()
    }

    // Moves an entry to the archive.
    func archive(_ entry: JournalEntry) {
        entry.isArchived = true
    }

    // Restores an archived entry.
    func restore(_ entry: JournalEntry) {
        entry.isArchived = false
    }

    // Deletes an entry from SwiftData.
    func delete(
        _ entry: JournalEntry,
        context: ModelContext
    ) {
        context.delete(entry)
    }

    // MARK: - Tag Formatting

    // Removes extra spaces and empty tag values.
    private func cleanedTags(
        from text: String
    ) -> String {

        text
            .split(separator: ",")
            .map {
                $0.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
            .filter {
                !$0.isEmpty
            }
            .joined(separator: ", ")
    }
}
