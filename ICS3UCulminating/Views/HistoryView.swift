//
//  HistoryView.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import SwiftUI

/// A view that displays a list of previous translations.
struct HistoryView: View {
    
    // MARK: - Stored properties
    
    /// The view model that handles the translation logic and stores the history.
    var viewModel: TranslationViewModel
    
    // MARK: - Computed properties
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Title for the screen
                    Text("History")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 20)
                    
                    // Check if there are any translations in the history
                    if viewModel.history.isEmpty {
                        // Empty state view shown when there is no history
                        VStack(spacing: 20) {
                            Spacer()
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No history yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Your translations will appear here.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                        
                    } else {
                        // Header section showing the count and a clear button
                        HStack {
                            Text("\(viewModel.history.count) translations")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            // Button to delete all history items
                            Button("Clear All") {
                                viewModel.clearHistory()
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.red)
                        }
                        .padding(.bottom, 10)
                        
                        // Iterate over each item in the history and display it
                        // CONCEPT: Array Iteration (Outputting each item from a collection)
                        ForEach(viewModel.history) { item in
                            // Use our Custom Subview here
                            TranslationHistoryItemView(item: item, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: TranslationViewModel())
}
