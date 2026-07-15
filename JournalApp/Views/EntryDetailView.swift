//
//  EntryDetailView.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Allows the user to view, edit, archive,
//  favorite, and delete an existing entry.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    // Creates bindings directly to the SwiftData model.
    @Bindable var entry: JournalEntry

    @State private var showDeleteConfirmation =
        false

    private let categories = [
        "Personal",
        "Work",
        "School"
    ]

    var body: some View {
        Form {

            Section("Journal Entry") {
                TextField(
                    "Title",
                    text: $entry.title
                )
                .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Entry")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextEditor(
                        text: $entry.body
                    )
                    .frame(minHeight: 220)
                    .padding(6)
                    .background(
                        Color.secondary.opacity(0.08)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 10
                        )
                    )
                }
            }

            Section("Details") {
                DatePicker(
                    "Date",
                    selection: $entry.date,
                    displayedComponents: [.date]
                )

                Picker(
                    "Category",
                    selection: $entry.category
                ) {
                    ForEach(
                        categories,
                        id: \.self
                    ) { category in
                        Text(category)
                            .tag(category)
                    }
                }

                TextField(
                    "Tags, separated by commas",
                    text: $entry.tags
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Toggle(
                    "Favorite",
                    isOn: $entry.isFavorite
                )

                Toggle(
                    "Archived",
                    isOn: $entry.isArchived
                )
            }

            Section {
                Button(
                    "Delete Entry",
                    role: .destructive
                ) {
                    showDeleteConfirmation = true
                }
            }
        }
        .navigationTitle("Edit Entry")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Delete this journal entry?",
            isPresented:
                $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                "Delete Entry",
                role: .destructive
            ) {
                deleteEntry()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {}
        } message: {
            Text(
                "This action cannot be undone."
            )
        }
    }

    // Deletes the entry and returns to the list.
    private func deleteEntry() {
        modelContext.delete(entry)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EntryDetailView(
            entry: JournalEntry(
                title: "Sample Entry",
                body: "This is a sample journal entry.",
                category: "Personal",
                tags: "sample, journal"
            )
        )
    }
    .modelContainer(
        for: JournalEntry.self,
        inMemory: true
    )
}
