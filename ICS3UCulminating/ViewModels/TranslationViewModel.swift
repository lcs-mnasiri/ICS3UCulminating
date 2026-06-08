//
//  TranslationViewModel.swift
//  ICS3UCulminating
//
//  Created by Machid on 6/1/26.
//

import Foundation
import AVFoundation

// MARK: - API Response Models

/// Represents the top-level structure of the translation API response.
struct TranslationResponse: Codable {
    let responseData: ResponseData
}

/// Contains the actual translated text returned by the API.
struct ResponseData: Codable {
    let translatedText: String
}

// MARK: - History Model

/// Represents a single translation entry in the user's history.
struct TranslationHistory: Identifiable, Codable {
    let id: UUID = UUID()
    let englishText: String
    let farsiText: String
}

// MARK: - View Model

/// The main logic handler for the translation application.
/// It manages the input text, translated output, and communication with the translation API.
@Observable
class TranslationViewModel {
    
    // MARK: - Stored properties
    
    /// The text the user wants to translate.
    // CONCEPT: Input (Storing user-provided data)
    var inputText: String = ""
    
    /// The resulting translation text.
    // CONCEPT: Output (Storing the result of processing)
    var translatedText: String = ""
    
    /// Indicates whether a translation is currently in progress.
    var isTranslating: Bool = false
    
    /// A list of previous translations.
    // CONCEPT: Array (A collection used to store multiple items)
    var history: [TranslationHistory] = []
    
    /// The language to translate from.
    let sourceLanguage: String = "English"
    
    /// The language to translate to.
    let targetLanguage: String = "Farsi"
    
    /// Use a single synthesizer instance for speech to avoid overlaps and memory issues.
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // MARK: - Initializer
    
    init() {
        setupAudioSession()
    }
    
    // MARK: - Functions
    
    /// Configures the audio session so that text-to-speech can play correctly.
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // We use .playback to ensure sound plays even if the silent switch is on.
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    /// Performs the translation by sending a request to the MyMemory web service.
    func translate() {
        // Remove leading/trailing whitespace to avoid empty or invalid queries.
        let cleanedInput: String = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Don't translate if the input is empty.
        if cleanedInput.isEmpty == true {
            translatedText = ""
            return
        }
        
        // Update state so the UI can show a loading spinner.
        isTranslating = true
        
        // Define the language pair: English (en) to Farsi (fa).
        let langPair: String = "en|fa"
        
        // Build the URL for the MyMemory API.
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = "api.mymemory.translated.net"
        components.path = "/get"
        components.queryItems = [
            URLQueryItem(name: "q", value: cleanedInput),
            URLQueryItem(name: "langpair", value: langPair)
        ]
        
        // Ensure the URL is valid.
        guard let url: URL = components.url else {
            translatedText = "Error: Invalid URL."
            isTranslating = false
            return
        }
        
        // Use a Task to perform the network request asynchronously.
        Task {
            do {
                // Fetch the data from the API.
                let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
                
                // Decode the JSON data into our Swift models.
                let decoder: JSONDecoder = JSONDecoder()
                let result: TranslationResponse = try decoder.decode(TranslationResponse.self, from: data)
                
                // Update the UI properties on the main thread (automatic with @Observable).
                self.translatedText = result.responseData.translatedText
                self.isTranslating = false
                
                // Add this translation to the top of our history list.
                let newEntry = TranslationHistory(englishText: cleanedInput, farsiText: result.responseData.translatedText)
                self.history.insert(newEntry, at: 0)
                
            } catch {
                // Handle network or decoding errors.
                self.translatedText = "Error: Connection failed."
                self.isTranslating = false
            }
        }
    }
    
    /// Reads the input English text aloud.
    func speakInput() {
        if inputText.isEmpty == false {
            speak(text: inputText, voiceCode: "en-US")
        }
    }
    
    /// Reads the translated Farsi text aloud.
    func speakOutput() {
        if translatedText.isEmpty == false {
            speak(text: translatedText, voiceCode: "fa-IR")
        }
    }
    
    /// Reads a specific piece of text from the history.
    func speakHistory(text: String) {
        speak(text: text, voiceCode: "fa-IR")
    }
    
    /// Internal function to handle text-to-speech logic.
    private func speak(text: String, voiceCode: String) {
        // 1. Re-activate the audio session before speaking to ensure it is ready.
        setupAudioSession()
        
        // 2. Stop any current speech to prevent overlapping.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // 3. Create the "utterance" (the thing to be said).
        let utterance = AVSpeechUtterance(string: text)
        
        // 4. Assign the requested voice based on the language code.
        if let voice = AVSpeechSynthesisVoice(language: voiceCode) {
            utterance.voice = voice
        } else {
            // Fallback for Farsi: scan for any Persian voice if the specific code is not found.
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
        
        // 5. Apply standard speech settings.
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 1.0
        
        // 6. Tell the synthesizer to start speaking.
        synthesizer.speak(utterance)
    }
    
    /// Clears all entries from the translation history.
    func clearHistory() {
        history.removeAll()
    }
}
