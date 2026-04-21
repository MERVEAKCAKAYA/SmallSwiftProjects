//
//  AddView.swift
//  iExpense
//
//  Created by Merve Akçakaya on 21.04.2026.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var amount = 0.0
    @State private var type = ""
    var expenses : Expenses
    let types = ["Personel", "Business"]
    var body: some View {
       NavigationStack {
           List{
               TextField("Name", text: $name)
               Picker("Type", selection: $type) {
                   ForEach(types, id: \.self) {
                       Text($0)
                   }
               }
               TextField("Amount", value: $amount, format: .currency(code: "USD"))
           }
           .navigationTitle("Add New Expense")
           .toolbar{
               Button("Save"){
                   let item = ExpenseItem(name: name, type: type, amount: amount)
                   expenses.items.append(item)
                   dismiss()
               }
           }
       }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
