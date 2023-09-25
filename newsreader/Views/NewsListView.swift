//
//  NewsListView.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import SwiftUI

struct NewsListView: View {
    let category: String
    @State private var results: ResultJson?
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationStack {
            contentBody
        }
        .onAppear {
            loadNews(category: category)
        }
    }
    
    private var contentBody: some View {
        Group {
            if let arts = results?.articles {
                newsList(articles: arts)
            } else if let error = results?.error {
                errorView(error: error)
            } else {
                loadingView
            }
        }
        .navigationTitle("\(category.capitalized) News")
    }
    
    private var loadingView: some View {
        ProgressView("読み込み中...")
    }
    
    private func errorView(error: String) -> some View {
        Text("エラーが発生しました: \(error)")
    }
    
    private func newsList(articles: [Article]) -> some View {
        List(articles, id: \.title) { item in
            NewsItemView(item: item)
        }
    }
    private func loadNews(category: String) {
        let now = Date()
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)! // 1か月前の日付
        
        let apiKey = "da3e8ef1b30545fe82dc0639b9ecfd6d" // ご自身のAPIキーを使用してください
        let urlString = "https://newsapi.org/v2/top-headlines?category=\(category)&from=\(dateFormatter.string(from: oneMonthAgo))&to=\(dateFormatter.string(from: now))&sortBy=publishedAt&apiKey=\(apiKey)&language=jp"
        
        // URLを取得できなかったらリターンする
        guard let url = URL(string: urlString) else {
            // エラーメッセージを設定: 不正なURL
            DispatchQueue.main.async {
                self.results = ResultJson(articles: nil, error: "無効なURLです。")
            }
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // APIリクエストエラーが発生した場合
                DispatchQueue.main.async {
                    self.results = ResultJson(articles: nil, error: error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                // データが取得できなかった場合
                DispatchQueue.main.async {
                    self.results = ResultJson(articles: nil, error: "データの読み込み中にエラーが発生しました。")
                }
                return
            }
            
            // データが取得できたら...
            let decoder = JSONDecoder()
            
            do {
                let res = try decoder.decode(ResultJson.self, from: data)
                
                // URLセッション結果は別スレッドで動いているので、メインスレッドでUIの更新をする
                DispatchQueue.main.async {
                    self.results = res
                }
            } catch {
                // データの解析エラーが発生した場合
                DispatchQueue.main.async {
                    self.results = ResultJson(articles: nil, error: "データの解析中にエラーが発生しました。")
                }
            }
        }
        
        // タスクを実行する
        task.resume()
    }
}
