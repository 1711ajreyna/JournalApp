//
//  EntryRowView.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Displays one journal entry inside a list row.
//

import SwiftUI

struct EntryRowView: View {

    let entry: JournalEntry

    var body: some View {
        HStack(
            alignment: .top,
            spacing: 14
        ) {

            // Category icon.
            ZStack {
                RoundedRectangle(
                    cornerRadius: 12
                )
                .fill(
                    categoryColor.opacity(0.15)
                )
                .frame(
                    width: 46,
                    height: 46
                )

                Image(
                    systemName: categoryIcon
                )
                .foregroundStyle(
                    categoryColor
                )
                .font(.title3)
            }

            VStack(
                alignment: .leading,
                spacing: 7
            ) {

                HStack {
                    Text(entry.title)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    if entry.isFavorite {
                        Image(
                            systemName: "star.fill"
                        )
                        .foregroundStyle(.yellow)
                        .accessibilityLabel(
                            "Favorite"
                        )
                    }
                }

                // Short preview of the journal body.
                Text(entry.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack {
                    categoryBadge

                    Spacer()

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

                // Show tags when the entry has any.
                if !entry.tags
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty {

                    Label(
                        entry.tags,
                        systemImage: "tag"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 5)
    }

    // MARK: - Category Badge

    private var categoryBadge: some View {
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
    }

    // MARK: - Category Styling

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

#Preview {
    EntryRowView(
        entry: JournalEntry(
            title: "Project Notes",
            body: "Finished the search and category features.",
            category: "School",
            tags: "SwiftUI, homework",
            isFavorite: true
        )
    )
    .padding()
}
