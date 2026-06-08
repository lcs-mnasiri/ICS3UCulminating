//
//  TranslationView.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import SwiftUI

/// The main user interface for translating text from English to Farsi.
struct TranslationView: View {
    
    // MARK: - Stored properties
    
    /// The view model that handles the translation logic and data.
    /// We receive this from the parent (ICS3UCulminatingApp) so data is shared across the app.
    var viewModel: TranslationViewModel
    
    // MARK: - Computed properties
    
    var body: some View {
        // We use @Bindable here to allow SwiftUI components (like TextField)
        // to have a two-way connection to the View Model's properties.
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Title for the screen
                    Text("Translator Pro")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 20)
                    
                    // MARK: - FROM SECTION (English)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("From:")
                            .font(.system(size: 20, weight: .bold))
                        
                        // Badge showing the source language
                        Text("English")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        
                        HStack {
                            // TextField for user input. The '$' creates a binding to the viewModel.
                            // CONCEPT: Input (Gathering information from the user)
                            TextField("Enter English text...", text: $viewModel.inputText)
                                .font(.system(size: 18))
                                .onSubmit {
                                    // Trigger translation when the user presses 'return'
                                    viewModel.translate()
                                }
                            
                            Spacer()
                            
                            // Button to read the input text aloud
                            Button(action: {
                                viewModel.speakInput()
                            }) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.bottom, 5)
                        
                        Divider()
                    }
                    
                    // MARK: - TO SECTION (Farsi)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("To:")
                            .font(.system(size: 20, weight: .bold))
                        
                        // Badge showing the target language
                        Text("Farsi")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top) {
                                // Show a loading spinner if a translation is in progress
                                if viewModel.isTranslating {
                                    ProgressView()
                                        .padding(.top, 10)
                                } else {
                                    // Display the translated text or a placeholder
                                    // CONCEPT: Output (Showing the processed result to the user)
                                    Text(viewModel.translatedText.isEmpty ? "Translation will appear here" : viewModel.translatedText)
                                        .font(.system(size: 24))
                                        .padding(.top, 10)
                                }
                                
                                Spacer()
                                
                                // Button to read the translated text aloud
                                Button(action: {
                                    viewModel.speakOutput()
                                }) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                }
                                .padding(.top, 12)
                                // Dim the button if there is no text to speak
                                .opacity(viewModel.translatedText.isEmpty ? 0.3 : 1.0)
                            }
                            
                            HStack {
                                Spacer()
                                // Main button to trigger the translation
                                Button(action: {
                                    viewModel.translate()
                                }) {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

#Preview {
    TranslationView(viewModel: TranslationViewModel())
}
