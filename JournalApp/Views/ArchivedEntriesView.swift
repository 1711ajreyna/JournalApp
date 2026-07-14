//
//  ArchivedEntriesView.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import SwiftUI
import SwiftData

// Displays only entries whose isArchived value is true.
struct ArchivedEntriesView: View {

    @Environment(\.modelContext)
    private var modelContext

    // Fetch all entries newest first.
    @Query(
        sort: \JournalEntry.date,
        order: .reverse
    )
    private var entries: [JournalEntry]

    @State private var searchText = ""

    // Keep only archived entries that also match the search.
    private var archivedEntries: [JournalEntry] {
        entries.filter { entry in
            let matchesSearch =
                searchText.isEmpty ||
                entry.title.localizedCaseInsensitiveContains(
                    searchText
                ) ||
                entry.body.localizedCaseInsensitiveContains(
                    searchText
                )

            return entry.isArchived && matchesSearch
        }
    }

    var body: some View {
        Group {
            if archivedEntries.isEmpty {
                ContentUnavailableView {
                    Label(
                        searchText.isEmpty
                            ? "No Archived Entries"
                            : "No Results",
                        systemImage: searchText.isEmpty
                            ? "archivebox"
                            : "magnifyingglass"
                    )
                } description: {
                    Text(
                        searchText.isEmpty
                            ? "Entries you archive will appear here."
                            : "Try searching with different text."
                    )
                }
            } else {
                List {
                    ForEach(archivedEntries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry)
                        } label: {
                            EntryRowView(entry: entry)
                        }
                        .swipeActions(
                            edge: .leading,
                            allowsFullSwipe: true
                        ) {
                            Button {
                                restore(entry)
                            } label: {
                                Label(
                                    "Restore",
                                    systemImage:
                                        "arrow.uturn.backward"
                                )
                            }
                            .tint(.green)
                        }
                        .swipeActions(
                            edge: .trailing
                        ) {
                            Button(role: .destructive) {
                                delete(entry)
                            } label: {
                                Label(
                                    "Delete",
                                    systemImage: "trash"
                                )
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Archived")
        .searchable(
            text: $searchText,
            prompt: "Search archived entries"
        )
    }

    private func restore(_ entry: JournalEntry) {
        entry.isArchived = false
    }

    private func delete(_ entry: JournalEntry) {
        modelContext.delete(entry)
    }
}

#Preview {
    NavigationStack {
        ArchivedEntriesView()
    }
    .modelContainer(
        for: JournalEntry.self,
        inMemory: true
    )
}
