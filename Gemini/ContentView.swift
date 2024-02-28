//
//  ContentView.swift
//  Gemini
//
//  Created by Michel Lapointe on 2024-02-28.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var textInput = ""
    @State var aiResponse: LocalizedStringKey = "Hello! How can I help you today?"
    
    var body: some View {
        VStack {
            Image(.geminiLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
            ScrollView {
                Text(aiResponse)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
        }
        
        HStack {
            TextField("Enter a message", text: $textInput)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.black)
            Button(action: sendMessage, label: {
                Image(systemName: "paperplane.fill")
            })
        }
        
        .foregroundStyle(.white)
        .padding()
        .background {
            ZStack {
                Color.black
            }
            .ignoresSafeArea()
        }
    }
    
    func sendMessage() {
        aiResponse = ""
        
        Task {
            do {
                let response = try await model.generateContent(textInput)
                
                guard let text = response.text else  {
                    textInput = "Sorry, I could not process that.\nPlease try again."
                    return
                }
                
                textInput = ""
                aiResponse = (.init(text))
                
            } catch {
                aiResponse = "Something went wrong!\n\(error.localizedDescription)"
            }
        }
    }
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12") // You can specify different devices here
    }
}
#endif
