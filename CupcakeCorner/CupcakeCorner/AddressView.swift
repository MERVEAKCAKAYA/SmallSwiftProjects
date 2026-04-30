//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Merve Akçakaya on 30.04.2026.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order:Order
    var body: some View {
  NavigationStack{
      Form{
          Section{
              TextField("Name", text: $order.name)
              TextField("Address", text: $order.streetAddress)
              TextField("City", text: $order.city)
              TextField( "Zip Code", text: $order.zip)
          }
          Section{
              NavigationLink("Check out"){
                  CheckoutView(order: order)
              }
          }.disabled(order.hasValidAddress == false)
   
      }
      .navigationTitle("Delivery Details")
      .navigationBarTitleDisplayMode(.inline)
        }
       
    }
}

#Preview {
    AddressView(order: Order())
}
