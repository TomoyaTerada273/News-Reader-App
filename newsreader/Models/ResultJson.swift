//
//  ResultJson.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import Foundation

struct ResultJson: Codable {
    let articles: [Article]?
    let error: String?  // エラーメッセージを保持するプロパティ
    
    enum CodingKeys: String, CodingKey {
        case articles
        case error
    }
}
