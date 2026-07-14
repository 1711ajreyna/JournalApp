//
//  Class04App.swift
//  Class04
//
//  Created by Andrew Reyna.
//

import SwiftUI
import SwiftData

// @main marks this structure as the starting point of the app.
@main
struct Class04App: App {

    var body: some Scene {
        WindowGroup {

            // NavigationStack allows navigation from the list
            // to the add, edit, and archived screens.
            NavigationStack {
                EntryListView()
            }
        }

        // Creates the SwiftData storage container.
        //
        // The container saves and loads JournalEntry objects
        // and provides modelContext to the view hierarchy.
        .modelContainer(for: JournalEntry.self)
    }
}
