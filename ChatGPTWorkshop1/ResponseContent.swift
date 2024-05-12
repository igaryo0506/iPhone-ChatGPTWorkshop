//
//  SimilarWords.swift
//  ChatGPTWorkshop1
//
//  Created by 五十嵐諒 on 2024/05/12.
//

import Foundation

struct ResponseContent: Codable {
    let similarWords: [String]
    
    enum CodingKeys: String, CodingKey {
        case similarWords = "similar_words"
    }
}
