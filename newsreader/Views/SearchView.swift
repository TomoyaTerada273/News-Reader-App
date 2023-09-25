//
//  SearchView.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchKeyword: String // ユーザーの入力を保持するためのバインディングプロパティ
    @State private var results: ResultJson? // 検索結果を保持するプロパティ
    
    var body: some View {
        NavigationStack {
            TextField("検索ワードを入力", text: $searchKeyword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                // 検索ボタンがタップされたときのアクションを実装
                // ここで検索ワードを使用してニュースを検索するための処理を追加します
                if !searchKeyword.isEmpty {
                    searchNews(withKeyword: searchKeyword)
                } else {
                    // 空の検索キーワードの場合、エラーメッセージを設定
                    self.results = ResultJson(articles: nil, error: "検索キーワードを入力してください。")
                }
            }) {
                Text("検索")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // 検索結果を表示するコンポーネントを追加
            if let arts = results?.articles {
                // ニュースの一覧を表示するコンポーネント
                NewsSearchView(articles: arts)
            }
            else if let error = results?.error {
                // エラーメッセージを表示するコンポーネント
                Text("エラーが発生しました: \(error)")
            } else {
                // ローディング中を表示するコンポーネント
                ProgressView("読み込み中...")
                
            }
        }.navigationTitle("Search News")
    }
    
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            SearchView(searchKeyword: .constant(""))
        }
    }
    
    // ニュースを検索する関数
    func searchNews(withKeyword keyword: String) {
        // ニュース検索の API エンドポイントを設定
        let apiKey = "da3e8ef1b30545fe82dc0639b9ecfd6d" // 自身の API キー
        let baseUrl = "https://newsapi.org/v2/everything"
        
        // URLComponentsを使用してクエリパラメータをセットアップ
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "language", value: "jp"),
            URLQueryItem(name: "sortBy", value: "publishedAt") // sortByを追加
        ]
        
        // URLを取得できなかったらリターンする
        guard let url = components?.url else {
            // エラーメッセージを設定: 不正なURL
            self.results = ResultJson(articles: nil, error: "無効なURLです。")
            return
        }
        
        // API リクエストを非同期で実行
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // データが取得できたらデコード
                let decoder = JSONDecoder()
                let res = try decoder.decode(ResultJson.self, from: data)
                
                // ニュースの検索結果を反映
                self.results = res
            } catch {
                // エラーが発生した場合
                self.results = ResultJson(articles: nil, error: error.localizedDescription)
            }
        }
    }
}

// 検索結果を表示するためのコンポーネント
struct NewsSearchView: View {
    let articles: [Article]
    
    var body: some View {
        List(articles, id: \.title) { item in
            // ニュースアイテムを表示するコンポーネント
            NewsItemView(item: item)
        }
    }
}
