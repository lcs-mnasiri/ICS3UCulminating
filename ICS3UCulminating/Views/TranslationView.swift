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
                VStack(alignment: .leading, spacing: 25) {
                    
                    Text("Translator Pro")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 20)
                    
                    // FROM SECTION
                    VStack(alignment: .leading, spacing: 15) {
                        Text("From:")
                            .font(.system(size: 20, weight: .bold))
                        
                        // Custom Language Picker
                        HStack(spacing: 0) {
                            ForEach(viewModel.sourceLanguages, id: \.self) { language in
                                Button(action: {
                                    viewModel.sourceLanguage = language
                                }) {
                                    Text(language)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(viewModel.sourceLanguage == language ? Color.white : Color.clear)
                                        .foregroundColor(viewModel.sourceLanguage == language ? .black : .gray)
                                        .clipShape(Capsule())
                                        .shadow(color: viewModel.sourceLanguage == language ? .black.opacity(0.1) : .clear, radius: 2)
                                }
                            }
                        }
                        .padding(4)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                        
                        // Input Field with Action Icons
                        HStack {
                            TextField("good morning", text: $viewModel.inputText)
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
                                // Action for camera/image
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
                    
                    // TO SECTION
                    VStack(alignment: .leading, spacing: 15) {
                        Text("To:")
                            .font(.system(size: 20, weight: .bold))
                        
                        // Custom Language Picker
                        HStack(spacing: 0) {
                            ForEach(viewModel.targetLanguages, id: \.self) { language in
                                Button(action: {
                                    viewModel.targetLanguage = language
                                }) {
                                    Text(language)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(viewModel.targetLanguage == language ? Color.white : Color.clear)
                                        .foregroundColor(viewModel.targetLanguage == language ? .black : .gray)
                                        .clipShape(Capsule())
                                        .shadow(color: viewModel.targetLanguage == language ? .black.opacity(0.1) : .clear, radius: 2)
                                }
                            }
                        }
                        .padding(4)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                        
                        // Output Text Area
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top) {
                                if viewModel.isTranslating {
                                    ProgressView()
                                        .padding(.top, 10)
                                } else {
                                    Text(viewModel.translatedText.isEmpty ? "Sub bakaire" : viewModel.translatedText)
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
                                // Blue translate/swap icon from prototype
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
