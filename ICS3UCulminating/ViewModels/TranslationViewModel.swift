//
//  TranslationViewModel.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import Foundation
import AVFoundation

// MARK: - API Response Models
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
    
    // The resulting translation
    var translatedText: String = ""
    
    // Tracking translation state
    var isTranslating: Bool = false
    
    // Selected languages
    var sourceLanguage: String = "English"
    var targetLanguage: String = "Dari"
    
    // Available languages based on the prototype screenshot
    let sourceLanguages: [String] = ["English", "French", "Urdu"]
    let targetLanguages: [String] = ["Hazaragi", "Dari", "English"]
    
    // Speech synthesizer for the audio feature
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // MARK: - Computed properties
    
    // MARK: - Initializer
    init() {
        // Initializer doesn't need to do anything specific for now
    }
    
    // MARK: - Functions
    
    // Helper to get API language codes
    private func getLanguageCode(for name: String) -> String {
        if name == "English" {
            return "en"
        } else if name == "French" {
            return "fr"
        } else if name == "Urdu" {
            return "ur"
        } else if name == "Dari" || name == "Hazaragi" {
            // MyMemory uses 'fa' (Persian) for Dari and Hazaragi
            return "fa"
        } else {
            return "en"
        }
    }
    
    // This function looks up the translation for the current input text using a web service
    func translate() {
        
        // 1. Prepare for the translation
        let cleanedInput: String = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Don't do anything if the input is empty
        if cleanedInput.isEmpty == true {
            translatedText = ""
            return
        }
        
        // Show that we are working
        isTranslating = true
        
        // 2. Build the URL for the translation service (MyMemory)
        let sourceCode: String = getLanguageCode(for: sourceLanguage)
        let targetCode: String = getLanguageCode(for: targetLanguage)
        let langPair: String = sourceCode + "|" + targetCode
        
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
        Task {
            do {
                let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
                
                let decoder: JSONDecoder = JSONDecoder()
                let result: TranslationResponse = try decoder.decode(TranslationResponse.self, from: data)
                
                // Update the UI
                self.translatedText = result.responseData.translatedText
                self.isTranslating = false
                
            } catch {
                self.translatedText = "Error: Could not connect to the translator."
                self.isTranslating = false
            }
        }
    }
    
    // This function reads the translated text out loud
    func speak() {
        // Don't do anything if there is no text to read
        if translatedText.isEmpty == true {
            return
        }
        
        // Stop any current speech before starting new one
        if synthesizer.isSpeaking == true {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Create an utterance (the thing to be spoken)
        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: translatedText)
        
        // Try to set the correct voice based on the target language
        let targetCode: String = getLanguageCode(for: targetLanguage)
        utterance.voice = AVSpeechSynthesisVoice(language: targetCode)
        
        // Set the speech rate (0.5 is normal speed)
        utterance.rate = 0.5
        
        // Start speaking
        synthesizer.speak(utterance)
    }
}
