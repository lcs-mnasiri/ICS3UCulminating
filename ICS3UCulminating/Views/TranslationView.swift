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
            VStack(spacing: 30) {
                
                // Input Section
                VStack(alignment: .leading) {
                    Text("English")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    TextField("Type something...", text: $viewModel.inputText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.translate()
                        }
                }
                
                // Action Button
                Button(action: {
                    viewModel.translate()
                }) {
                    HStack {
                        if viewModel.isTranslating == true {
                            ProgressView()
                                .padding(.trailing, 5)
                        }
                        
                        Text(viewModel.isTranslating ? "Translating..." : "Translate")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isTranslating ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isTranslating)
                
                Divider()
                
                // Output Section
                VStack(alignment: .leading) {
                    Text("Farsi (Dari)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(minHeight: 100)
                        
                        Text(viewModel.translatedText)
                            .padding()
                            .foregroundColor(viewModel.isTranslating ? .secondary : .primary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Translator")
        }
    }
}

#Preview {
    TranslationView()
}
