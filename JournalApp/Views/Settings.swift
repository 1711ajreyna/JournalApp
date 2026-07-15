//
//  SettingsView.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Displays persistent profile and app settings
//  using @AppStorage.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Persistent Settings

    @AppStorage("displayName")
    private var displayName = ""

    @AppStorage("preferredTheme")
    private var preferredTheme = "System"

    @AppStorage("defaultCategory")
    private var defaultCategory = "Personal"

    @AppStorage("showEntryCounts")
    private var showEntryCounts = true

    private let themes = [
        "System",
        "Light",
        "Dark"
    ]

    private let categories = [
        "Personal",
        "Work",
        "School"
    ]

    var body: some View {
        Form {

            // MARK: - Profile

            Section {
                TextField(
                    "Display Name",
                    text: $displayName
                )
            } header: {
                Text("Profile")
            } footer: {
                Text(
                    "Your name will appear in the journal title."
                )
            }

            // MARK: - Appearance

            Section("Appearance") {
                Picker(
                    "Theme",
                    selection: $preferredTheme
                ) {
                    ForEach(
                        themes,
                        id: \.self
                    ) { theme in
                        Text(theme)
                            .tag(theme)
                    }
                }
            }

            // MARK: - Journal Preferences

            Section("Journal Preferences") {
                Picker(
                    "Default Category",
                    selection: $defaultCategory
                ) {
                    ForEach(
                        categories,
                        id: \.self
                    ) { category in
                        Text(category)
                            .tag(category)
                    }
                }

                Toggle(
                    "Show Category Counts",
                    isOn: $showEntryCounts
                )
            }

            // MARK: - Settings Summary

            Section("Current Settings") {
                LabeledContent(
                    "Theme",
                    value: preferredTheme
                )

                LabeledContent(
                    "Default Category",
                    value: defaultCategory
                )

                LabeledContent(
                    "Category Counts",
                    value: showEntryCounts
                        ? "On"
                        : "Off"
                )
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
