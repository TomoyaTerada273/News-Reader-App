//
//  NewsItemView.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import SwiftUI

struct NewsItemView: View {
    // Article.swift
    let item: Article
    
    // 日付フォーマッターを初期化するプロパティ。ニュース記事の公開日時を整形する．
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 日付フォーマット
        return formatter
    }()
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString,
              let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        return date.agoText()
    }
    
    
    var body: some View {
        // WebView.swift
        NavigationLink(destination: WebView(urlString: item.url ?? "")) {
            // アイテムの表示
            VStack(alignment: .leading, spacing: 8) {
//                if let imageUrlString = item.urlToImage,
//                   let imageUrl = URL(string: imageUrlString) {
//                    // RemoteImage.swift
//                    RemoteImage(url: imageUrl)
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 150)
//                        .clipped()
//                        .accessibility(label: Text("ニュースの画像"))
//                }
                Text(item.title ?? "")
                    .font(.headline)
                Text(item.author ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
//                Text(item.description ?? "")
//                    .font(.body)
//                    .lineLimit(3) // 3行まで表示
//                    .foregroundColor(.secondary)
                Text(formatDate(item.publishedAt))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
