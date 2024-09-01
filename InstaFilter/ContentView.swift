//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mayur  on 23/08/24.
//
import SwiftUI

struct ContentView: View {
    
    var body: some View{
        let image = Image(.example)
        ShareLink(item: image, preview: SharePreview("hello", image: image)){
            Label("Tap to share", systemImage: "swift")
        }
    }
}

#Preview {
    ContentView()
}
