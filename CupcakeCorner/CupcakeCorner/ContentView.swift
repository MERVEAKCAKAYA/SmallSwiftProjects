//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Merve Akçakaya on 29.04.2026.
//

import SwiftUI

struct Response: Codable{
    var results: [Result]
}

struct Result: Codable{
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State var results = [Result]()
    @State var order =  Order()
    var body: some View {
//        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")){phase in
//            switch phase{
//            case .empty:
//                ProgressView()
//            case .success(let image):
//                image.resizable().scaledToFit()
//            case .failure:
//                Image(systemName: "photo")
//            @unknown default:
//                EmptyView()
//            }
//        }.frame(width: 200, height: 200)
//        
//        List(results, id: \.trackId) { result in
//            Text(result.trackName).font(.headline)
//            Text(result.collectionName)
//        }
//        
//        .task {
//            await loadData()
//        }
        
        NavigationStack{
            Form{
                Section(){
                    Picker("Select your cake style", selection: $order.type){
                        ForEach(Order.types.indices, id: \.self){
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cupcakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section(){
                    Toggle("Any special request? ",isOn: $order.specialRequestEnabled )
                    if order.specialRequestEnabled{
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                Section(){
                    NavigationLink("Delivery Address"){
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("CUPCAKE CORNER")
        }
    }
    func loadData() async{
        //URL'i dene eğer başarısız olursa fonksiyondan çık.
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song")else{
            print("Invalid URL")
            return
        }
        do{
            //URLSession bir tuple dondurur (data: Data, response: URLResponse) biz response kısmını umursamıyoruz şu an o yüzden _ kullandık.
            let (data, _) = try await URLSession.shared.data(from: url)
            //decode(Response.self, from: data) burada ilk parametre hangi türde decode edileceği bilgisidir.
            //burada try? kullandığı için catche düşmez sessizce nil döner. kötü bir kullanım.
            if let decodedData = try? JSONDecoder().decode(Response.self, from: data){
                self.results = decodedData.results
            }
            
        }catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
