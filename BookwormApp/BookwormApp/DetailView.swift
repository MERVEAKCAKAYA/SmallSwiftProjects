//
//  DetailView.swift
//  BookwormApp
//
//  Created by Merve Akçakaya on 19.05.2026.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let book: Book
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    var body: some View {
        ScrollView{
            ZStack(alignment: .bottomTrailing){
                Image(book.genre).resizable().scaledToFit()
                Text(book.genre.uppercased()).fontWeight(.black)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Capsule())
                    .offset(x:-5, y: -5)
            }
            Text(book.author).font(.title).foregroundStyle(.secondary)
            Text(book.review).padding()
            RatingView(rating:.constant(book.rating)).font(.largeTitle)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete Book", isPresented: $showingDeleteAlert){
            Button("Delete", role:.destructive, action: deleteBook)
            Button("Cancel", role: .cancel ){}
        }message:{
            Text("Are you sure?")
        }
        .toolbar{
            Button("Delete this book", systemImage:"trash"){
                showingDeleteAlert = true
            }
        }
    }
    func deleteBook(){
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
   //burası bizden Book nesnesi istiyor.
   //gerçek veritabanını kullanmadan sanal bir book verelim
    do{
        // config SwiftData veri deposunun nasıl çalışacağını belirleyen ayardır.
        //isStoredInMemoryOnly şu anlama gelir: Verileri diske kaydetme, sadece RAM’de/geçici bellekte tut.
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        //ModelContainer, SwiftData’nın veri deposunu temsil eder. Bu container Book modelini saklamak için kullanılacak ve biraz önce oluşturduğumuz config ile çalışacak.
        let container = try ModelContainer(for: Book.self, configurations:config)
        let example = Book(
                    title: "Test Book",
                    author: "Test Author",
                    genre: "Fantasy",
                    review: "This was a great book; I really enjoyed it.",
                    rating: 4
                )
        return DetailView(book: example).modelContainer(container)
        
    }catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
