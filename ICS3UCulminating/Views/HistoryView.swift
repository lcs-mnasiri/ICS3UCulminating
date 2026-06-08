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
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        // Display the original English text
                                        Text(item.englishText)
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                        // Display the translated Farsi text
                                        Text(item.farsiText)
                                            .font(.system(size: 20, weight: .medium))
                                    }
                                    
                                    Spacer()
                                    
                                    // Button to read the history item aloud
                                    Button(action: {
                                        viewModel.speakHistory(text: item.farsiText)
                                    }) {
                                        Image(systemName: "speaker.wave.2")
                                            .font(.system(size: 14))
                                            .foregroundColor(.blue)
                                            .padding(10)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                            }
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
