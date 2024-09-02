//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mayur  on 23/08/24.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var intensity = 0.5
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    @State private var showFiltersDialogBox = false
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View{
        NavigationStack{
            VStack{
                Spacer()
                PhotosPicker(selection: $selectedImage){
                    if let processedImage{
                        processedImage
                            .resizable()
                            .scaledToFit()
                    }else{
                        ContentUnavailableView("No Picture", systemImage:  "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedImage, loadImage)
                Spacer()
                
                HStack{
                    Text("Intensity")
                    Slider(value: $intensity)
                        .onChange(of: intensity, applyProcessing)
                }
                .padding(.vertical)
                HStack{
                    Button("Change Filter"){
                        showFiltersDialogBox = true
                    }
                    Spacer()
                    if let processedImage{
                        ShareLink(item: processedImage, preview: SharePreview("InstaFilter Image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
            .confirmationDialog("Select Filter", isPresented: $showFiltersDialogBox) {
                Button("Crystallize") { changeFilter(CIFilter.crystallize()) }
                Button("Edges") { changeFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { changeFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { changeFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { changeFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { changeFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { changeFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }

    }
    
    @MainActor func changeFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
        filterCount += 1
        if filterCount > 20{
            requestReview()
        }
    }
    
    func loadImage(){
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let image = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(intensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(intensity * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(intensity * 10, forKey: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
