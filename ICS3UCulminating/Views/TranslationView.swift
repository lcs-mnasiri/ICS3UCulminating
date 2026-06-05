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
                    
                    // FROM SECTION (English)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("From:")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("English")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        
                        HStack {
                            TextField("Enter English text...", text: $viewModel.inputText)
                                .font(.system(size: 18))
                                .onSubmit {
                                    viewModel.translate()
                                }
                            
                            Spacer()
                            
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
                    
                    // TO SECTION (Farsi)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("To:")
                            .font(.system(size: 20, weight: .bold))
                        
                        Text("Farsi")
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        
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
                    
                    // HISTORY SECTION
                    if viewModel.history.isEmpty == false {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("History")
                                    .font(.system(size: 20, weight: .bold))
                                
                                Spacer()
                                
                                Button("Clear") {
                                    viewModel.clearHistory()
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                            }
                            
                            ForEach(viewModel.history) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.englishText)
                                                .font(.system(size: 14))
                                                .foregroundColor(.secondary)
                                            Text(item.farsiText)
                                                .font(.system(size: 18, weight: .medium))
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.speakHistory(text: item.farsiText)
                                        }) {
                                            Image(systemName: "speaker.wave.2")
                                                .font(.system(size: 12))
                                                .foregroundColor(.blue)
                                                .padding(6)
                                                .background(Color.blue.opacity(0.1))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
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
