//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Merve Akçakaya on 30.04.2026.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    @State private var confirmationMessage  = ""
    @State private var isPresentingConfirmationAlert = false
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?w=500&fit=crop"),
                          scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                Text("Your total cost is : \(order.cost, format:.currency(code: "USD"))")
                Button("Place order"){
                    Task{
                        await PlaceOrder()
                    }
                }.padding()
            }
         
        }
        .navigationTitle("Place Order")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank You", isPresented: $isPresentingConfirmationAlert){
            Button("OK"){}
        }message: {
            Text(confirmationMessage)
        }
    }
    func PlaceOrder() async {
        //burada oluşturulan sipariş şifreleniyor ve encoded degişkenine atılıyor.
        guard let encoded = try? JSONEncoder().encode(order)else{
            print("Failed to encode order")
            return
        }
        //url oluşturuyoruz.
        let url = URL(string:"https://reqres.in/api/cupcakes")!
        //network istekleri için request objesi oluşturuyoruz.
        var request = URLRequest(url: url)
        //HTTP metodunu ayarlıyoruz. burada POST ayarladık yani sunucuya veri gönderme.
        request.httpMethod = "POST"
        //gönderilecek verinin JSON formatında olduğunu bildiriyoruz.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            //requesti gönderiyoruz server'a.
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            isPresentingConfirmationAlert = true
        } catch {
            print("Check out failed: \(error)")
        }
    }
}

#Preview {
    CheckoutView(order:Order())
}
