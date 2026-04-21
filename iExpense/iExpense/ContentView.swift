//
//  ContentView.swift
//  iExpense
//
//  Created by Merve Akçakaya on 20.04.2026.
//

import Observation
import SwiftUI

struct User : Codable{
    var name : String
    var age : Int
}

struct ExpenseItem : Identifiable, Codable{
    var id  =  UUID()//codable protocol'u bunun let olmasına izin vermiyor. var olması lazım.
    let name : String
    let type : String
    let amount : Double
}

@Observable
class Expenses{
    var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init(){
        //proje açıldığında kullanıcının önceden kaydettiği verileri ekranda göstermek icindir.
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decoded
                return
            }
        }
        items=[]
    }
   
}

struct ContentView: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    @State private var tapCount = UserDefaults.standard.integer(forKey: "tapCount")
    @AppStorage("tutulanSayi") private var tutulanSayi = 0

    @State private var user = User(name: "Merve", age: 27)
    @State private var Message = "Durum"
    @State private var expenses = Expenses()
    @State private var showingAddView = false
    var body: some View {
        /* onDelete ve EditButton örneğini içerir.
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self){
                        Text("Row \($0)")
                    }.onDelete(perform: removeRows)
                       
                }
                Button("Add"){
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }.navigationTitle(Text("iExpense"))
                .toolbar{
                    EditButton()
                }
        }
         */
        
        /* userdefaults ve appStorage kullanımı
        VStack{
            Button("Tap me by userDefaults: \(tapCount)"){
                tapCount += 1
                UserDefaults.standard.set(tapCount, forKey: "tapCount")
            }
            Spacer()
            Button("Tap me by AppStorage: \(tutulanSayi)"){
                tutulanSayi += 1
            }
        }
         */
        
        /*Codable save ve read ornekleri
        VStack{
            Text(Message)
            Button("Veriyi Codable ile kaydet"){
                saveData()
            }
            .padding(40)
            .frame(width: 200)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(.circle)
            
            
            Button("Veriyi Codable ile oku"){
                readData()
            }
            .padding(40)
            .frame(width: 200)
            .background(.green)
            .foregroundStyle(.white)
            .clipShape(.circle)
        }
         */
        
        NavigationStack{
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                                
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeRows)
            }
            .navigationTitle("iExpense")
            .toolbar {
                    Button("Add", systemImage: "plus.circle"){
                       showingAddView = true
                    }
                    EditButton()
                }
            .sheet(isPresented: $showingAddView){
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeRows(at offsets : IndexSet){
        numbers.remove(atOffsets: offsets)
    }
    
    //codable save fonksiyonu
    func saveData(){
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "user")
            Message = "Kaydedildi!"
        }catch{
            print("Kaydetme hatası!")
            Message = "Kaydetme hatası!"
        }
       
    }
    
    //codable read fonksiyonu
    func readData(){
        if let data = UserDefaults.standard.data(forKey: "user"){
            let decoder = JSONDecoder()
            //try kullanmanın en guvenli yolu do-catch icerisinde kullanmak.
            //try? veya try! daha az güvenli veya tehlikeli!
            do{
                user = try decoder.decode(User.self, from: data)
                Message = "Okundu! \(user.name) ve \(user.age)"
            }catch {
                print("Okuma Hatası!")
                Message = "Okuma Hatası!"
            }
            
        }
    }
}

#Preview {
    ContentView()
}
