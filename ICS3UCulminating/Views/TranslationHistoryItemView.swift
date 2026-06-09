import SwiftUI

/// A custom subview that displays a single translation entry from the history.
/// CONCEPT: Custom Subview (A reusable UI component extracted to its own file)
struct TranslationHistoryItemView: View {
    
    // MARK: - Stored properties
    
    /// The specific history item to display.
    let item: TranslationHistory
    
    /// The view model used to trigger speech.
    var viewModel: TranslationViewModel
    
    // MARK: - Computed properties
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // Display the original English text
                    Text(item.englishText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    // Display the translated Farsi text
                    // CONCEPT: Output (Showing stored data to the user)
                    Text(item.farsiText)
                        .font(.system(size: 20, weight: .medium))
                }
                
                Spacer()
                
                // Button to read the history item aloud
                Button(action: {
                    viewModel.speakHistory(text: item.farsiText)
                }) {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
    }
}

#Preview {
    // Create a mock item for the preview
    let mockItem = TranslationHistory(englishText: "Hello", farsiText: "سلام")
    return TranslationHistoryItemView(item: mockItem, viewModel: TranslationViewModel())
}
