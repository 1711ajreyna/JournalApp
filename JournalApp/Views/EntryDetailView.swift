//
//  EntryDetailView.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import SwiftUI
import SwiftData

// Allows the user to view and edit one existing entry.
struct EntryDetailView: View {

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    // @Bindable creates bindings directly to properties
    // on the SwiftData model.
    //
    // Changes made in these fields are tracked by SwiftData.
    @Bindable var entry: JournalEntry

    @State private var showDeleteConfirmation = false

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

                    TextEditor(text: $entry.body)
                        .frame(minHeight: 220)
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
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .tag(category)
                    }
                }

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
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                "Delete Entry",
                role: .destructive
            ) {
                deleteEntry()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    // Deletes the model from SwiftData.
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
                category: "Personal"
            )
        )
    }
    .modelContainer(
        for: JournalEntry.self,
        inMemory: true
    )
}
