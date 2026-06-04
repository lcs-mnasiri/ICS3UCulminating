//
//  TranslationView.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import SwiftUI

struct TranslationView: View {
    
    // MARK: - Stored properties
    
    // The view model that handles the translation logic
    @State var viewModel = TranslationViewModel()
    
    // MARK: - Computed properties
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    Text("Translator Pro")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 20)
                    
                    // FROM SECTION (Fixed to English)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("From:")
                            .font(.system(size: 20, weight: .bold))
                        
                        // Simple Label instead of Picker
                        Text("English")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        
                        // Input Field with Action Icons
                        HStack {
                            TextField("Enter English text...", text: $viewModel.inputText)
                                .font(.system(size: 18))
                                .onSubmit {
                                    viewModel.translate()
                                }
                            
                            Spacer()
                            
                            // Input Speaker Button
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
                            
                            Button(action: {
                                // Optional camera feature
                            }) {
                                Image(systemName: "camera.fill")
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
                    
                    // TO SECTION (Fixed to Farsi)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("To:")
                            .font(.system(size: 20, weight: .bold))
                        
                        // Simple Label instead of Picker
                        Text("Farsi")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        
                        // Output Text Area
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top) {
                                if viewModel.isTranslating {
                                    ProgressView()
                                        .padding(.top, 10)
                                } else {
                                    Text(viewModel.translatedText.isEmpty ? "Translation will appear here" : viewModel.translatedText)
                                        .font(.system(size: 24))
                                        .padding(.top, 10)
                                }
                                
                                Spacer()
                                
                                // Output Speaker Button
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
                                .opacity(viewModel.translatedText.isEmpty ? 0.3 : 1.0)
                            }
                            
                            HStack {
                                Spacer()
                                // Blue translate button
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
    TranslationView()
}
