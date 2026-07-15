//
//  ArchivedEntriesView.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Displays archived entries and allows users
//  to restore, search, edit, or delete them.
//

import SwiftUI
import SwiftData

struct ArchivedEntriesView: View {

    @Environment(\.modelContext)
    private var modelContext

    @Query(
        sort: \JournalEntry.date,
        order: .reverse
    )
    private var entries: [JournalEntry]

    @State private var searchText = ""

    private let viewModel =
        JournalViewModel()

    // Keeps only archived entries matching the search.
    private var archivedEntries:
        [JournalEntry] {

        entries.filter { entry in
            let matchesSearch =
                searchText.isEmpty ||
                entry.title
                    .localizedCaseInsensitiveContains(
                        searchText
                    ) ||
                entry.body
                    .localizedCaseInsensitiveContains(
                        searchText
                    ) ||
                entry.tags
                    .localizedCaseInsensitiveContains(
                        searchText
                    )

            return entry.isArchived &&
                   matchesSearch
        }
    }

    var body: some View {
        Group {
            if archivedEntries.isEmpty {
                emptyState
            } else {
                archivedList
            }
        }
        .navigationTitle("Archived")
        .searchable(
            text: $searchText,
            prompt:
                "Search archived entries"
        )
    }

    // MARK: - Archived List

    private var archivedList: some View {
        List {
            ForEach(archivedEntries) { entry in
                NavigationLink {
                    EntryDetailView(
                        entry: entry
                    )
                } label: {
                    EntryRowView(
                        entry: entry
                    )
                }
                .swipeActions(
                    edge: .leading,
                    allowsFullSwipe: true
                ) {
                    Button {
                        viewModel.restore(entry)
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
                    Button(
                        role: .destructive
                    ) {
                        viewModel.delete(
                            entry,
                            context: modelContext
                        )
                    } label: {
                        Label(
                            "Delete",
                            systemImage: "trash"
                        )
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Empty State

    private var emptyState: some View {
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
        } actions: {
            if !searchText.isEmpty {
                Button("Clear Search") {
                    searchText = ""
                }
            }
        }
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
