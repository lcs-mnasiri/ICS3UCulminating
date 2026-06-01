//
//  TranslationViewModel.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import Foundation

// VIEW MODEL
@Observable
class TranslationViewModel {
    
    // MARK: - Stored properties
    
    // The text the user wants to translate
    var inputText: String = ""
    
    // The resulting translation in Farsi (Dari)
    var translatedText: String = ""
    
    // A simple dictionary to store translations (English: Farsi)
    // This serves as our "data source" within the view model
    private let translations: [String: String] = [
        "hello": "سلام (Salam)",
        "how are you?": "چطور هستی؟ (Chutor hasti?)",
        "thank you": "تشکر (Tashakor)",
        "goodbye": "خدا حافظ (Khoda hafiz)",
        "water": "آب (Aab)",
        "bread": "نان (Nan)",
        "friend": "دوست (Dost)",
        "school": "مکتب (Maktab)",
        "teacher": "استاد (Ostad)",
        "student": "شاگرد (Shagerd)"
    ]
    
    // MARK: - Computed properties
    
    // MARK: - Initializer
    init() {
        // Initializer doesn't need to do anything specific for now
    }
    
    // MARK: - Functions
    
    // This function looks up the translation for the current input text
    func translate() {
        // Clear previous translation
        translatedText = ""
        
        // Convert input to lowercase to make matching easier
        let searchKey: String = inputText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try to find the translation in our dictionary
        if let result: String = translations[searchKey] {
            translatedText = result
        } else {
            // If not found, provide a friendly message
            translatedText = "Translation not found. Try 'hello' or 'thank you'."
        }
    }
}
