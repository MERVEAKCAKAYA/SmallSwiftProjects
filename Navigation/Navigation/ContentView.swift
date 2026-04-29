//
//  ContentView.swift
//  Navigation
//
//  Created by Merve Akçakaya on 27.04.2026.
//

import SwiftUI

struct Product : Hashable, Identifiable{
    var id :Int
    var name : String
    var cost : Double
}

struct ProductDetailView : View {
    var product : Product
    var body: some View {
        HStack{
            Text(product.cost,format: .currency(code: .init("USD")))
            Image(systemName: "phone.fill")
        }.navigationTitle(product.name)
    }
}

@Observable //bu macro sayesinde bu class'ın propertyleri değişince UI guncellenir.
class PathStore{
    var path: NavigationPath{
        //didset sayesinde path her değiştiğinde kaydedilir.
        didSet {
            save()
        }
    }
    //kayıt yolu olan Documents'e kaydedilir.
    private let savePath = URL.documentsDirectory.appending(path:"SavedPath")
    
    init(){
        //uygulama açıldığında dosya okunur, decode edilir, değer varsa atama yapılır yoksa boş array ataması yapılır.
        if let data = try? Data(contentsOf: savePath){
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data){
                path = NavigationPath(decoded)
                return
            }
        }
        path = NavigationPath()
    }
    /*
     if let kullansaydık save fonksiyonu böyle olurdu.
    func save() {
        if let representation = path.codable {
            do {
                let data = try JSONEncoder().encode(representation)
                try data.write(to: Self.savePath)
            } catch {
                print("Failed to save navigation data")
            }
        }
    }
     */
    func save(){
        //burada guard let kullandık çünkü sonuç nil dönerse çıkış yapar ve representation
        //degişkenini her yerde kullanırsın. if let kullansaydık scope içerisinde kalmak zorundaydık.
        guard let representation = path.codable else {return}
        do{
            //path encode edilir
            let data = try JSONEncoder().encode(representation)
            //dosyaya yazılır.
            try data.write(to: savePath)
        }catch{
            print("Failed to save navigation data")
        }
    }
}

struct DetailView : View {
    var number : Int
    var body: some View {
            NavigationLink("Go to the random page..", value: Int.random(in: 0..<100))
            .navigationTitle("Number: \(number)")
    }
}

struct ContentView: View {
    @State private var pathStore = PathStore()
    let products = [Product(id: 1, name: "iPhone",  cost: 799.99),
                    Product(id: 2, name: "iPad",    cost: 999.99),
                    Product(id: 3, name: "Macbook", cost: 2399.99)
    ]
    var body: some View {
        NavigationStack(path: $pathStore.path){
         DetailView(number: 0)
                .navigationDestination(for: Int.self){i in
                    DetailView(number: i)
                }
        }
    }
}

#Preview {
    ContentView()
}
