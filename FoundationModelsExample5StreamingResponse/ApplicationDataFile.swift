//
//  ApplicationDataFile.swift
//  FoundationModelsExample5StreamingResponse
//
//  Created by Quanpeng Yang on 3/5/26.
//

import SwiftUI
import FoundationModels
import Observation

@Observable
class ApplicationData {
    var response: AttributedString = ""
    var prompt: String = ""
    
    @ObservationIgnored var session: LanguageModelSession
    
    static let shared: ApplicationData = ApplicationData()
    
    private init() {
        // Initialize the session
        session = LanguageModelSession()
    }
    
    func sendPrompt() async {
        do {
            let tempResponse = response
            
            // Stream partial responses from the model
            let answer = session.streamResponse(to: prompt)
            
            for try await partial in answer {
                var newPartial = AttributedString("\(partial.content)")
                newPartial.font = .system(size: 16, weight: .regular)
                
                var newResponse = tempResponse
                newResponse.append(newPartial)
                
                response = newResponse
            }
            
            // Add spacing after the streamed response
            response.append(AttributedString("\n\n"))
        } catch {
            response.append(AttributedString("Error accessing the model: \(error)\n\n"))
        }
        
        prompt = ""
    }
}
