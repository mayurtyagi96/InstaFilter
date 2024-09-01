//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mayur  on 23/08/24.
//
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var pickerPhotos = [PhotosPickerItem]()
    @State private var selectedPhotos = [Image]()
    
    var body: some View{
        PhotosPicker(selection: $pickerPhotos, maxSelectionCount: 3, matching: .images){
            Label("select photo from library", systemImage: "photo")
        }
        ScrollView{
            ForEach(0..<selectedPhotos.count, id: \.self){ index in
                selectedPhotos[index]
                    .resizable()
                    .scaledToFit()
            }
        }
        .onChange(of: pickerPhotos) {
            Task{
                selectedPhotos.removeAll()
                for photo in pickerPhotos{
                    if let loadedImage = try await photo.loadTransferable(type: Image.self) {
                        selectedPhotos.append(loadedImage)
                    }
                }
            }
            
            
            
        }
    }
}

#Preview {
    ContentView()
}
