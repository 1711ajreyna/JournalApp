//
//  EntryListView.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import SwiftUI
import SwiftData

// Represents the two available sort directions.
enum EntrySortOrder: String, CaseIterable, Identifiable {
    case newest = "Newest"
    case oldest = "Oldest"

    var id: String {
        rawValue
    }
}

// The main home screen of the journal app.
struct EntryListView: View {

    // Gives this view access to SwiftData delete operations.
    @Environment(\.modelContext)
    private var modelContext

    // Loads journal entries from SwiftData.
    //
    // The base query is sorted newest first, satisfying
    // the assignment's required default sorting.
    @Query(
        sort: \JournalEntry.date,
        order: .reverse
    )
    private var entries: [JournalEntry]

    // MARK: - View State

    @State private var searchText = ""
    @State private var categoryFilter = "All"
    @State private var sortOrder: EntrySortOrder = .newest
    @State private var showingAddEntry = false

    private let categoryOptions = [
        "All",
        "Personal",
        "Work",
        "School"
    ]

    // Applies archive, category, search, and sort rules.
    private var filteredEntries: [JournalEntry] {
        let visibleEntries = entries.filter { entry in

            // Archived entries are excluded from the home list.
            let matchesArchive = !entry.isArchived

            // All displays every category.
            let matchesCategory =
                categoryFilter == "All" ||
                entry.category == categoryFilter

            // Search both the title and body.
            let matchesSearch =
                searchText.isEmpty ||
                entry.title.localizedCaseInsensitiveContains(
                    searchText
                ) ||
                entry.body.localizedCaseInsensitiveContains(
                    searchText
                )

            return matchesArchive &&
                   matchesCategory &&
                   matchesSearch
        }

        // @Query already supplies newest-first data.
        //
        // Reverse the array when the user selects oldest.
        switch sortOrder {
        case .newest:
            return visibleEntries

        case .oldest:
            return visibleEntries.reversed()
        }
    }

    var body: some View {
        Group {
            if filteredEntries.isEmpty {
                emptyState
            } else {
                entryList
            }
        }
        .navigationTitle("My Journal")
        .searchable(
            text: $searchText,
            prompt: "Search title or entry"
        )
        .toolbar {
            leadingToolbar
            trailingToolbar
        }
        .sheet(isPresented: $showingAddEntry) {
            NavigationStack {
                AddEntryView()
            }
        }
    }

    // MARK: - Main List

    private var entryList: some View {
        List {

            Section {
                Picker(
                    "Sort Order",
                    selection: $sortOrder
                ) {
                    ForEach(EntrySortOrder.allCases) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                ForEach(filteredEntries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        EntryRowView(entry: entry)
                    }

                    // Leading swipe action for favorite status.
                    .swipeActions(
                        edge: .leading,
                        allowsFullSwipe: true
                    ) {
                        Button {
                            toggleFavorite(entry)
                        } label: {
                            Label(
                                entry.isFavorite
                                    ? "Unfavorite"
                                    : "Favorite",
                                systemImage: entry.isFavorite
                                    ? "star.slash"
                                    : "star"
                            )
                        }
                        .tint(.yellow)
                    }

                    // Trailing swipe actions for archive and delete.
                    .swipeActions(
                        edge: .trailing,
                        allowsFullSwipe: false
                    ) {
                        Button(role: .destructive) {
                            delete(entry)
                        } label: {
                            Label(
                                "Delete",
                                systemImage: "trash"
                            )
                        }

                        Button {
                            archive(entry)
                        } label: {
                            Label(
                                "Archive",
                                systemImage: "archivebox"
                            )
                        }
                        .tint(.orange)
                    }
                }

                // Standard swipe-to-delete support.
                .onDelete(perform: deleteEntries)
            } header: {
                Text(sectionTitle)
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView {
            Label(
                emptyStateTitle,
                systemImage: emptyStateIcon
            )
        } description: {
            Text(emptyStateDescription)
        } actions: {
            if searchText.isEmpty &&
                categoryFilter == "All" {

                Button("Create Entry") {
                    showingAddEntry = true
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Clear Filters") {
                    searchText = ""
                    categoryFilter = "All"
                }
            }
        }
    }

    // MARK: - Toolbars

    @ToolbarContentBuilder
    private var leadingToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker(
                    "Filter Category",
                    selection: $categoryFilter
                ) {
                    ForEach(
                        categoryOptions,
                        id: \.self
                    ) { category in
                        Text(category)
                            .tag(category)
                    }
                }
            } label: {
                Label(
                    categoryFilter == "All"
                        ? "Filter"
                        : categoryFilter,
                    systemImage:
                        "line.3.horizontal.decrease.circle"
                )
            }
        }
    }

    @ToolbarContentBuilder
    private var trailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {

            NavigationLink {
                ArchivedEntriesView()
            } label: {
                Image(systemName: "archivebox")
            }
            .accessibilityLabel("Archived Entries")

            Button {
                showingAddEntry = true
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityLabel("Add Entry")
        }
    }

    // MARK: - Display Text

    private var sectionTitle: String {
        if categoryFilter == "All" {
            return "\(filteredEntries.count) Entries"
        }

        return "\(categoryFilter) Entries"
    }

    private var emptyStateTitle: String {
        if !searchText.isEmpty {
            return "No Search Results"
        }

        if categoryFilter != "All" {
            return "No \(categoryFilter) Entries"
        }

        return "No Journal Entries"
    }

    private var emptyStateIcon: String {
        if !searchText.isEmpty {
            return "magnifyingglass"
        }

        return "book.closed"
    }

    private var emptyStateDescription: String {
        if !searchText.isEmpty {
            return "No entries match your search."
        }

        if categoryFilter != "All" {
            return "Try another category or create a new entry."
        }

        return "Tap the plus button to write your first entry."
    }

    // MARK: - SwiftData Operations

    private func toggleFavorite(_ entry: JournalEntry) {
        entry.isFavorite.toggle()
    }

    private func archive(_ entry: JournalEntry) {
        entry.isArchived = true
    }

    private func delete(_ entry: JournalEntry) {
        modelContext.delete(entry)
    }

    // Handles deletion when the user uses the standard
    // List swipe-to-delete gesture.
    private func deleteEntries(at offsets: IndexSet) {
        for offset in offsets {
            guard filteredEntries.indices.contains(offset) else {
                continue
            }

            let entry = filteredEntries[offset]
            modelContext.delete(entry)
        }
    }
}

#Preview {
    NavigationStack {
        EntryListView()
    }
    .modelContainer(
        for: JournalEntry.self,
        inMemory: true
    )
}
