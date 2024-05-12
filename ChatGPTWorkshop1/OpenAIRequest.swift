//
//  OpenAIRequest.swift
//  ChatGPTWorkshop1
//
//  Created by 五十嵐諒 on 2024/05/10.
//

import Foundation
struct OpenAIRequest: Codable {
    let model: String
    let responseFormat: ResponseFormat
    let messages: [Message]
    
    struct ResponseFormat: Codable {
        let type:String
    }
    struct Message: Codable {
        enum Role: String, Codable {
            case system
            case user
        }
        let role: Role
        let content: String
    }
    enum CodingKeys: String, CodingKey {
        case model
        case responseFormat = "response_format"
        case messages
    }
}

