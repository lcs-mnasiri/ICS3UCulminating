//
//  TranslationViewModel.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import Foundation

// MARK: - API Response Models
// These structures help us read the data that comes back from the translation server
struct TranslationResponse: Codable {
    let responseData: ResponseData
}

struct ResponseData: Codable {
    let translatedText: String
}

// VIEW MODEL
@Observable
class TranslationViewModel {
    
    // MARK: - Stored properties
    
    // The text the user wants to translate
    var inputText: String = ""
    
    // The resulting translation in Farsi (Dari)
    var translatedText: String = ""
    
    // A boolean to track if we are currently waiting for a translation
    var isTranslating: Bool = false
    
    // MARK: - Computed properties
    
    // MARK: - Initializer
    init() {
        // Initializer doesn't need to do anything specific for now
    }
    
    // MARK: - Functions
    
    // This function looks up the translation for the current input text using a web service
    func translate() {
        
        // 1. Prepare for the translation
        // Convert input to lowercase and trim spaces
        let cleanedInput: String = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Don't do anything if the input is empty
        if cleanedInput.isEmpty == true {
            translatedText = ""
            return
        }
        
        // Show that we are working
        isTranslating = true
        translatedText = "Translating..."
        
        // 2. Build the URL for the translation service (MyMemory)
        // We use English (en) and Farsi (fa)
        let sourceLang: String = "en"
        let targetLang: String = "fa"
        let langPair: String = sourceLang + "|" + targetLang
        
        // Create the base URL components
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = "api.mymemory.translated.net"
        components.path = "/get"
        components.queryItems = [
            URLQueryItem(name: "q", value: cleanedInput),
            URLQueryItem(name: "langpair", value: langPair)
        ]
        
        // Make sure the URL is valid
        guard let url: URL = components.url else {
            translatedText = "Error: Could not create a valid search."
            isTranslating = false
            return
        }
        
        // 3. Start the network request
        // We use Task because network requests are "asynchronous" (they take time)
        Task {
            do {
                // Fetch the data from the internet
                let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
                
                // Try to decode the JSON data into our Swift structures
                let decoder: JSONDecoder = JSONDecoder()
                let result: TranslationResponse = try decoder.decode(TranslationResponse.self, from: data)
                
                // Update the UI on the main thread (automatic with @Observable)
                self.translatedText = result.responseData.translatedText
                self.isTranslating = false
                
            } catch {
                // If something goes wrong, show the error
                self.translatedText = "Error: Could not connect to the translator."
                self.isTranslating = false
            }
        }
    }
}
