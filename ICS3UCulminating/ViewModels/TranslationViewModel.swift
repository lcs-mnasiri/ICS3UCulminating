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
        configureAudioSession()
    }
    
    // MARK: - Functions
    
    // Configure the audio session so the app is allowed to play sound
    private func configureAudioSession() {
        do {
            // This ensures the audio plays even if the ringer is off
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // Helper to get API language codes for translation (MyMemory API)
    private func getLanguageCode(for name: String) -> String {
        if name == "English" {
            return "en"
        } else if name == "French" {
            return "fr"
        } else if name == "Urdu" {
            return "ur"
        } else if name == "Dari" || name == "Hazaragi" {
            return "fa" // MyMemory uses 'fa' for both
        } else {
            return "en"
        }
    }
    
    // Helper to get Voice codes for Text-to-Speech (BCP-47)
    private func getVoiceCode(for name: String) -> String {
        if name == "English" {
            return "en-US"
        } else if name == "French" {
            return "fr-FR"
        } else if name == "Urdu" {
            return "ur-PK"
        } else if name == "Dari" {
            return "fa-AF" // Dari specific code
        } else if name == "Hazaragi" {
            return "fa-IR" // Closest available for Hazaragi
        } else {
            return "en-US"
        }
    }
    
    // This function looks up the translation using the MyMemory web service
    func translate() {
        let cleanedInput: String = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedInput.isEmpty == true {
            translatedText = ""
            return
        }
        
        isTranslating = true
        
        let sourceCode: String = getLanguageCode(for: sourceLanguage)
        let targetCode: String = getLanguageCode(for: targetLanguage)
        let langPair: String = sourceCode + "|" + targetCode
        
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = "api.mymemory.translated.net"
        components.path = "/get"
        components.queryItems = [
            URLQueryItem(name: "q", value: cleanedInput),
            URLQueryItem(name: "langpair", value: langPair)
        ]
        
        guard let url: URL = components.url else {
            translatedText = "Error: Invalid URL."
            isTranslating = false
            return
        }
        
        Task {
            do {
                let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
                let decoder: JSONDecoder = JSONDecoder()
                let result: TranslationResponse = try decoder.decode(TranslationResponse.self, from: data)
                
                self.translatedText = result.responseData.translatedText
                self.isTranslating = false
            } catch {
                self.translatedText = "Error: Connection failed."
                self.isTranslating = false
            }
        }
    }
    
    // Reads the input text out loud
    func speakInput() {
        if inputText.isEmpty == true { return }
        speak(text: inputText, languageName: sourceLanguage)
    }
    
    // Reads the translated text out loud
    func speakOutput() {
        if translatedText.isEmpty == true { return }
        speak(text: translatedText, languageName: targetLanguage)
    }
    
    // Generic speak function with improved voice matching
    private func speak(text: String, languageName: String) {
        // Stop any current speech immediately
        if synthesizer.isSpeaking == true {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        let preferredCode: String = getVoiceCode(for: languageName)
        
        // 1. Try to find the exact voice for the code (e.g., fa-AF)
        if let exactVoice = AVSpeechSynthesisVoice(language: preferredCode) {
            utterance.voice = exactVoice
        } else {
            // 2. Fallback: Search for any voice that starts with the same language (e.g., "fa")
            let languagePrefix = preferredCode.prefix(2)
            let allVoices = AVSpeechSynthesisVoice.speechVoices()
            
            var foundVoice: AVSpeechSynthesisVoice? = nil
            for voice in allVoices {
                if voice.language.hasPrefix(languagePrefix) {
                    foundVoice = voice
                    break
                }
            }
            
            if let voice = foundVoice {
                utterance.voice = voice
            } else {
                // 3. Last resort: If no matching voice exists, use English
                // (This usually only happens if the user hasn't downloaded any voices for that language)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            }
        }
        
        utterance.rate = 0.5
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }
}
