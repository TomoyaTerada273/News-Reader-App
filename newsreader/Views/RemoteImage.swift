//
//  RemoteImage.swift
//  newsreader
//
//  Created by 寺田智哉 on 2023/09/14.
//

import SwiftUI
// リモートの画像をダウンロードして表示するためのカスタムビュータイプ。
// loadImage メソッドを使用して、指定されたURLから画像を非同期でダウンロードし、表示します。
struct RemoteImage: View {
    let url: URL
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(.gray)
                .onAppear(perform: loadImage)
        }
    }
    
    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
