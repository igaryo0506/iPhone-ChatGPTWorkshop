//
//  OpenAIClient.swift
//  ChatGPTWorkshop1
//
//  Created by 五十嵐諒 on 2024/05/10.
//

import Foundation

class OpenAIClient {
    private let apiKey: String
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchSynonyms(for word: String, completion: @escaping ([String]?) -> Void) {
        let sampleContent = ResponseContent(similarWords: ["a", "b", "c"])
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(sampleContent), let stringData = String(data: jsonData, encoding: .utf8) else {
            print("failed to encode data")
            return
        }
        let formattedData = stringData.replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
        let systemMessage = "You are a helpful assistant designed to output JSON. Response should be the style of \(formattedData)"
        
        let userMessage = "Please tell me 3 words similar to \(word)"

        let request = OpenAIRequest(
            model: "gpt-3.5-turbo",
            responseFormat: .init(type: "json_object"),
            messages: [
                OpenAIRequest.Message(
                    role: .system,
                    content: systemMessage
                ),
                OpenAIRequest.Message(
                    role: .user,
                    content: userMessage)
            ]
        )
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
        } catch {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                guard let jsonContent = decodedResponse.choices[0].message.content.data(using: .utf8) else {
                    fatalError("Unable to convert string to Data")
                }
                
                do {
                    let content = try JSONDecoder().decode(ResponseContent.self, from: jsonContent)
                    completion(content.similarWords)
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            } catch(let error) {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}
