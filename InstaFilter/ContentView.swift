//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mayur  on 23/08/24.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var amount = 1.0
    
    var body: some View{
        VStack{
            Slider(value: $amount, in: 1...1000)
                .onChange(of: amount) { oldValue, newValue in
                    loadImage()
                }
            image?
                .resizable()
                .scaledToFit()
        }
        
    }
    func loadImage(){
        let inputImage = UIImage(resource: .example)
        let ciImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let filter = CIFilter.pixellate()
        
        filter.inputImage = ciImage
        
        let inputKeys = filter.inputKeys
        
        if inputKeys.contains(kCIInputScaleKey){
            filter.setValue(amount, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = filter.outputImage else {return}
        guard let cgimage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        let uiImage = UIImage(cgImage: cgimage)
        image = Image(uiImage: uiImage)
        
    }
//    var body: some View {
//        ContentUnavailableView("No content Available", image: "swift")
//        
//        ContentUnavailableView {
//            Label("No snippets", systemImage: "swift")
//        } description: {
//            Text("You don't have any saved snippets yet.")
//        } actions: {
//            Button("Create Snippet") {
//                // create a snippet
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        
//        ContentUnavailableView {
//            Label("no content available", systemImage: "swift")
//        } description: {
//            Text("there is no content available")
//        } actions: {
//            Button("create snippet") {
//                print("New snippet created")
//            }
//        }
//    }
}

#Preview {
    ContentView()
}
