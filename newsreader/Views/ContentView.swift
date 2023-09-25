//
//  ContentView.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/18.
//

import SwiftUI
import WebKit
import ARKit


struct ContentView: View {
    @State var results: ResultJson?
    let dateFormatter = DateFormatter()
    @State private var searchKeyword: String = "" // ユーザーの検索ワード

    // カテゴリー一覧
    let categories: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]


    var body: some View {
        TabView {
            // 検索ビューを表示
            SearchView(searchKeyword: $searchKeyword)
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                .transition(.move(edge: .top))
                .tabItem {
                    Image(systemName: "0.circle.fill")
                    Text("探す")
                }
            ForEach(categories, id: \.self) { category in
                NewsListView(category: category)
                    .tabItem {
                        Image(systemName: "\(categories.firstIndex(of: category)! + 1).circle.fill")
                        Text(category.capitalized)
                    }
                    .tag(category) // タブのタグを設定
            }
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
        .navigationTitle("ニュースリスト")
    }

    private var loadingView: some View {
        ProgressView("読み込み中...")
    }

    private func errorView(error: String) -> some View {
        Text("エラーが発生しました: \(error)")
    }

    private func newsList(articles: [Article]) -> some View {
        List(articles, id: \.title) { item in
            // NewsItemView.swift
            NewsItemView(item: item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
