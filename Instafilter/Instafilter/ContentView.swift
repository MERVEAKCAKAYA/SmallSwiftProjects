//
//  ContentView.swift
//  Instafilter
//
//  Created by Merve Akçakaya on 8.06.2026.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem:PhotosPickerItem?
    @State private var showingFilter = false
    
    @State private var currentFilter : CIFilter = CIFilter.sepiaTone()
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                PhotosPicker(selection:$selectedItem){
                    //yuklenen resim varsa goster yoksa ContentUnavailableView goster.
                    if let processedImage{
                        processedImage.resizable().scaledToFit()
                    }else{
                        ContentUnavailableView("No image selected", systemImage: "photo.badge.plus", description:Text("Tab to import photo"))
                    }
                }.buttonStyle(.plain) // no image selected yazısını gri yapmak için
                //kullanıcı bir resim sectiginde tetiklenir selectedItem degisir ve resmi yuklemek icin loadImage fonksiyonu cagrilir.
                    .onChange(of: selectedItem, loadImage)
                Spacer()
                HStack {
                    Text("Filter Intensity")
                    //degisen filter intensity degerini resime uygulamak icin applyProcessing fonksiyonu cagrilir.
                    Slider(value: $filterIntensity).onChange(of: filterIntensity, applyProcessing)
                }
                HStack {
                    Button("Change Filters",action: changeFilter)
                    Spacer()
                    if let processedImage{
                        ShareLink(item:processedImage, preview: SharePreview("Instafilter image",image:processedImage))
                    }
                    
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilter) {
                Button("Crystallize") { setFilter(CIFilter.crystallize() )}
                Button("Edges") { setFilter(CIFilter.edges() )}
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}
                Button("Pixellate") { setFilter(CIFilter.pixellate() )}
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}
                Button("Vignette") { setFilter(CIFilter.vignette() )}
                Button("Cancel", role: .cancel) { }
            }
        }
        
    }
    
    func changeFilter(){
        showingFilter = true
    }
    
    func loadImage(){
        Task{
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self)
            else{
                return
            }
            guard let inputImage = UIImage(data: imageData)
            else{
                return
            }
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
            
        }
    }
    
    func applyProcessing(){
        
        //bu inputkeys sayesinde slider'dan gelen değeri filtrelere uygulayabiliyoruz. en yaygın 3 tanesi bunlar.
        //bunları yazıp set etmeseydik slider değerine göre atama olmazdı.
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(Float(filterIntensity), forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(Float(filterIntensity) * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(Float(filterIntensity) * 10, forKey: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    func setFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
        filterCount += 1
        if filterCount >= 3{
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
