//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mayur  on 23/08/24.
//
import StoreKit
import SwiftUI

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View{
        Button("Leave Review"){
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
