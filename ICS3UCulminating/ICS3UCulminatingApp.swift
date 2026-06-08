//
//  ICS3UCulminatingApp.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import SwiftUI

@main
struct ICS3UCulminatingApp: App {
    
    // MARK: - Stored properties
    
    // Create the View Model here so it is shared between tabs.
    // We use @State because the app "owns" this data, and we want it to persist
    // for the entire life of the application.
    @State private var viewModel = TranslationViewModel()
    
    // MARK: - Computed properties
    
    // The body property defines the entry point for the app's user interface.
    var body: some Scene {
        WindowGroup {
            // A TabView allows the user to switch between different screens (tabs).
            TabView {
                
                // TAB 1: The Translator
                // This view handles the actual text translation.
                TranslationView(viewModel: viewModel)
                    .tabItem {
                        Label("Translate", systemImage: "character.book.closed")
                    }
                
                // TAB 2: The History
                // This view shows a list of previous translations.
                HistoryView(viewModel: viewModel)
                    .tabItem {
                        Label("History", systemImage: "clock.fill")
                    }
            }
        }
    }
}
