//
//  AddEntryView.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import SwiftUI
import SwiftData

// Displays a form used to create a new journal entry.
struct AddEntryView: View {

    // modelContext provides insert, delete, and save access
    // to the SwiftData container.
    @Environment(\.modelContext)
    private var modelContext

    // Used to close the sheet after saving or cancelling.
    @Environment(\.dismiss)
    private var dismiss

    // MARK: - Form State

    @State private var title = ""
    @State private var bodyText = ""
    @State private var date = Date.now
    @State private var category = "Personal"
    @State private var isFavorite = false

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
                    text: $title
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("Entry")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    TextEditor(text: $bodyText)
                        .frame(minHeight: 180)
                }
            }

            Section("Details") {
                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )

                Picker(
                    "Category",
                    selection: $category
                ) {
                    ForEach(categories, id: \.self) { category in
                        Label(
                            category,
                            systemImage: icon(for: category)
                        )
                        .tag(category)
                    }
                }

                Toggle(
                    "Mark as Favorite",
                    isOn: $isFavorite
                )
            }
        }
        .navigationTitle("New Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveEntry()
                }
                .fontWeight(.semibold)
                .disabled(isSaveDisabled)
            }
        }
    }

    // Prevents the user from saving an empty entry.
    private var isSaveDisabled: Bool {
        trimmedTitle.isEmpty || trimmedBody.isEmpty
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private var trimmedBody: String {
        bodyText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    // Creates and inserts a new SwiftData model.
    private func saveEntry() {
        guard !isSaveDisabled else {
            return
        }

        let newEntry = JournalEntry(
            title: trimmedTitle,
            body: trimmedBody,
            date: date,
            category: category,
            isFavorite: isFavorite
        )

        // Inserting the object adds it to SwiftData.
        modelContext.insert(newEntry)

        // SwiftData normally autosaves context changes.
        dismiss()
    }

    private func icon(for category: String) -> String {
        switch category {
        case "Work":
            return "briefcase"

        case "School":
            return "graduationcap"

        default:
            return "person"
        }
    }
}

#Preview {
    NavigationStack {
        AddEntryView()
    }
    .modelContainer(
        for: JournalEntry.self,
        inMemory: true
    )
}
