//
//  AddEntryView.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Displays a form for creating a new journal entry.
//

import SwiftUI
import SwiftData

struct AddEntryView: View {

    // Provides access to SwiftData.
    @Environment(\.modelContext)
    private var modelContext

    // Closes the sheet after saving or cancelling.
    @Environment(\.dismiss)
    private var dismiss

    // Reads the user's saved default category.
    @AppStorage("defaultCategory")
    private var defaultCategory = "Personal"

    // MARK: - Form State

    @State private var title = ""
    @State private var bodyText = ""
    @State private var date = Date.now
    @State private var category = ""
    @State private var tags = ""
    @State private var isFavorite = false

    // Handles validation and data insertion.
    private let viewModel = JournalViewModel()

    private let categories = [
        "Personal",
        "Work",
        "School"
    ]

    var body: some View {
        Form {

            // MARK: - Main Entry Section

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

            // MARK: - Entry Details

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
                    ForEach(
                        categories,
                        id: \.self
                    ) { category in
                        Label(
                            category,
                            systemImage: icon(
                                for: category
                            )
                        )
                        .tag(category)
                    }
                }

                TextField(
                    "Tags, separated by commas",
                    text: $tags
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Toggle(
                    "Mark as Favorite",
                    isOn: $isFavorite
                )
            }
        }
        .navigationTitle("New Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarLeading
            ) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button("Save") {
                    saveEntry()
                }
                .fontWeight(.semibold)
                .disabled(isSaveDisabled)
            }
        }
        .onAppear {
            // Use the category saved in Settings.
            if category.isEmpty {
                category = defaultCategory
            }
        }
    }

    // Prevents saving an empty title or body.
    private var isSaveDisabled: Bool {
        !viewModel.isValidEntry(
            title: title,
            body: bodyText
        )
    }

    // Creates the entry through the ViewModel.
    private func saveEntry() {
        let didSave = viewModel.addEntry(
            title: title,
            body: bodyText,
            date: date,
            category: category,
            tags: tags,
            isFavorite: isFavorite,
            context: modelContext
        )

        if didSave {
            dismiss()
        }
    }

    // Returns an icon for each category.
    private func icon(
        for category: String
    ) -> String {

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
