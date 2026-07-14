//
//  EntryRowView.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import SwiftUI

// Displays one journal entry inside a List.
struct EntryRowView: View {

    // The entry displayed by this row.
    let entry: JournalEntry

    var body: some View {
        HStack(alignment: .top, spacing: 14) {

            // Category icon.
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 46, height: 46)

                Image(systemName: categoryIcon)
                    .foregroundStyle(categoryColor)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 7) {

                HStack {
                    Text(entry.title)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    // Show a star when the entry is a favorite.
                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .accessibilityLabel("Favorite")
                    }
                }

                // Show a short preview of the journal body.
                Text(entry.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack {
                    // Category badge.
                    Text(entry.category)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(categoryColor)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(
                            categoryColor.opacity(0.12)
                        )
                        .clipShape(Capsule())

                    Spacer()

                    // Formatted journal date.
                    Text(
                        entry.date,
                        format: .dateTime
                            .month(.abbreviated)
                            .day()
                            .year()
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 5)
    }

    // Returns an icon based on the category.
    private var categoryIcon: String {
        switch entry.category {
        case "Work":
            return "briefcase.fill"

        case "School":
            return "graduationcap.fill"

        default:
            return "person.fill"
        }
    }

    // Returns a visual color based on the category.
    private var categoryColor: Color {
        switch entry.category {
        case "Work":
            return .blue

        case "School":
            return .orange

        default:
            return .purple
        }
    }
}
