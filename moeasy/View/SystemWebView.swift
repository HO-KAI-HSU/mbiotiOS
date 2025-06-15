//
//  SystemWebView.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2024/5/19.
//

import SwiftUI
import WebKit

struct SystemWebView: View {

    
    var body: some View {
        WebView()
    }
}

#Preview {
    SystemWebView()
}

struct WebView: UIViewRepresentable {
    
    let webView: WKWebView
    
    init() {
        webView = WKWebView(frame: .zero)
      
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let userDefault = UserDefaults.standard
        let url = userDefault.string(forKey: "url_preference") ?? ""
        let urlString = URL(string: url)
        let request = URLRequest(url: urlString!)
        webView.load(request)
    }
}
