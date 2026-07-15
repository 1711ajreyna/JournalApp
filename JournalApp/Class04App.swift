//
//  Class04App.swift
//  JournalApp
//
//  Created by Andrew Reyna.
//
//  Configures the app's tabs, theme,
//  and SwiftData model container.
//

import SwiftUI
import SwiftData

@main
struct Class04App: App {

    // Reads the selected theme from Settings.
    @AppStorage("preferredTheme")
    private var preferredTheme = "System"

    var body: some Scene {
        WindowGroup {
            TabView {

                // Main journal tab.
                NavigationStack {
                    EntryListView()
                }
                .tabItem {
                    Label(
                        "Journal",
                        systemImage: "book.closed"
                    )
                }

                // Archived entries tab.
                NavigationStack {
                    ArchivedEntriesView()
                }
                .tabItem {
                    Label(
                        "Archived",
                        systemImage: "archivebox"
                    )
                }

                // Profile and settings tab.
                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label(
                        "Settings",
                        systemImage: "gearshape"
                    )
                }
            }
            .preferredColorScheme(
                selectedColorScheme
            )
        }

        // Creates the SwiftData storage container.
        .modelContainer(
            for: JournalEntry.self
        )
    }

    // Converts the saved theme name into
    // a SwiftUI color scheme.
    private var selectedColorScheme:
        ColorScheme? {

        switch preferredTheme {
        case "Light":
            return .light

        case "Dark":
            return .dark

        default:
            return nil
        }
    }
}
