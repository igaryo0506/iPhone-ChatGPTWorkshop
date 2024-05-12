//
//  OpenAIResponse.swift
//  ChatGPTWorkshop1
//
//  Created by 五十嵐諒 on 2024/05/10.
//

import Foundation
struct OpenAIResponse: Codable {
    let object: String
    let id: String
    let model: String
    let systemFingerprint: String?
    let created: Int
    let choices: [Choice]
    enum CodingKeys: String,CodingKey {
        case object
        case id
        case model
        case systemFingerprint = "system_fingerprint"
        case created
        case choices
    }
    
    struct Choice: Codable {
        let finishReason: String
        let message: Message
        let logprobs: String?
        let index: Int
        
        struct Message: Codable {
            let content: String
            let role: String
        }
        enum CodingKeys: String, CodingKey {
            case finishReason = "finish_reason"
            case message
            case logprobs
            case index
        }
    }
}
