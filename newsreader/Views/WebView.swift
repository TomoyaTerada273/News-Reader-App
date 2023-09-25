//
//  WebView.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import SwiftUI
import WebKit

// WebViewはWebコンテンツの表示を処理するためのものです
// makeUIView メソッドで WKWebView を初期化し、updateUIView メソッドで指定されたURLを読み込みます
struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
