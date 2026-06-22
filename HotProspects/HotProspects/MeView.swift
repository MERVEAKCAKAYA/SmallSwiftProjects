//
//  MeView.swift
//  HotProspects
//
//  Created by Merve Akçakaya on 16.06.2026.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @AppStorage("name") private var name = "Billinmiyor"
    @AppStorage("email") private var email = "bilinmiyor@gmail.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        NavigationStack{
           Form {
                Section(header: Text("QR Code Bilgiler")) {
                    TextField("Adınız", text: $name).textContentType(.name).onChange(of:name){updateQRCode()}
                    TextField("E-posta", text: $email).textContentType(.emailAddress)
                        .onChange(of:email){updateQRCode()}
                    Image(uiImage: qrCode)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .contextMenu{
                            ShareLink(item: Image(uiImage: qrCode), preview:SharePreview("My QR Code",image: Image(uiImage: qrCode)))
                        }
                }
            }
        }.onAppear(perform: updateQRCode)
    }
    func updateQRCode() {
            qrCode = generateQRCode(from: "\(name)\n\(email)")
        }

    func generateQRCode(from string: String) -> UIImage{
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgImage)
               
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
