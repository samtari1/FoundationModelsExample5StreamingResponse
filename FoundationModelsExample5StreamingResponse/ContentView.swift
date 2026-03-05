//
//  ContentView.swift
//  FoundationModelsExample5StreamingResponse
//
//  Created by Quanpeng Yang on 3/5/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var appData = ApplicationData.shared
    @State private var position = ScrollPosition(idType: String.self)
    
    var body: some View {
        VStack {
            ScrollView {
                Text(appData.response)
                    .padding()
                    .textSelection(.enabled)
                    .id("textID")
            }
            .frame(minWidth: 350, maxWidth: .infinity, minHeight: 300, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scrollPosition($position)
            
            HStack {
                TextField("Insert Prompt", text: $appData.prompt)
                    .textFieldStyle(.roundedBorder)
                    .disabled(appData.session.isResponding)
                
                Button("Send") {
                    Task {
                        if !appData.prompt.isEmpty {
                            // Insert prompt in chat box
                            var newPrompt = AttributedString("\(appData.prompt)\n\n")
                            newPrompt.font = .system(size: 16, weight: .bold)
                            appData.response.append(newPrompt)
                            
                            // Send prompt to model
                            await appData.sendPrompt()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(appData.session.isResponding)
            }
        }
        .padding()
        .onChange(of: appData.response) {
            position.scrollTo(edge: .bottom)
        }
    }
}
