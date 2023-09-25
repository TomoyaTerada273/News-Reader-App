//
//  Article.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import Foundation

struct Article: Codable {
    let title: String?
    let url: String?
    let description: String?
    let publishedAt: String?
    let urlToImage: String?
    let author: String?
}
