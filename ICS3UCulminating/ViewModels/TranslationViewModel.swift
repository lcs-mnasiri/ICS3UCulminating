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

// MARK: - History Model
struct TranslationHistory: Identifiable, Codable {
    let id: UUID = UUID()
    let englishText: String
    let farsiText: String
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
    
    // History of translations
    var history: [TranslationHistory] = []
    
    // Fixed languages for this version
    let sourceLanguage: String = "English"
    let targetLanguage: String = "Farsi"
    
    // Use a single synthesizer instance for speech
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // MARK: - Initializer
    init() {
        setupAudioSession()
    }
    
    // MARK: - Functions
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("Audio session setup failed")
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
        
        // English (en) to Farsi (fa)
        let langPair: String = "en|fa"
        
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
                
                // Update the UI
                self.translatedText = result.responseData.translatedText
                self.isTranslating = false
                
                // Add to history
                let newEntry = TranslationHistory(englishText: cleanedInput, farsiText: result.responseData.translatedText)
                self.history.insert(newEntry, at: 0) // Add to the top of the list
                
            } catch {
                self.translatedText = "Error: Connection failed."
                self.isTranslating = false
            }
        }
    }
    
    // Reads input text (English)
    func speakInput() {
        if inputText.isEmpty == false {
            speak(text: inputText, voiceCode: "en-US")
        }
    }
    
    // Reads translated text (Farsi)
    func speakOutput() {
        if translatedText.isEmpty == false {
            speak(text: translatedText, voiceCode: "fa-IR")
        }
    }
    
    // Reads a specific history item
    func speakHistory(text: String) {
        speak(text: text, voiceCode: "fa-IR")
    }
    
    // Resilient speak function
    private func speak(text: String, voiceCode: String) {
        setupAudioSession()
        
        // Ensure any current speech is stopped and reset
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        
        // Attempt to assign the requested voice
        if let voice = AVSpeechSynthesisVoice(language: voiceCode) {
            utterance.voice = voice
        } else {
            // Fallback for Farsi: scan for any Persian voice
            if voiceCode == "fa-IR" {
                let voices = AVSpeechSynthesisVoice.speechVoices()
                for v in voices {
                    if v.language.hasPrefix("fa") {
                        utterance.voice = v
                        break
                    }
                }
            }
        }
        
        // Slower rate can sometimes help with buffer issues
        utterance.rate = 0.4 
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
    
    // Function to clear history
    func clearHistory() {
        history.removeAll()
    }
}
