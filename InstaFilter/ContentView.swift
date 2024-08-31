//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mayur  on 23/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showConfirmationAlert = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        VStack{
            Button("tap me") {
                showConfirmationAlert.toggle()
            }
            .background(.white)
            .frame(maxWidth: 50, maxHeight: .infinity)
            .background(backgroundColor)
        }
        .frame(width: 100, height: 100)
        .confirmationDialog("change background", isPresented: $showConfirmationAlert) {
            Button("Red") {
                backgroundColor = .red
            }
            Button("Green") {
                backgroundColor = .green
            }
            Button("Blue") {
                backgroundColor = .blue
            }
            Button("cance", role: .cancel) {}
        }
    }
}

#Preview {
    ContentView()
}
