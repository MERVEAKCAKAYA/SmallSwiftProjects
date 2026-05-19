//
//  ContentView.swift
//  BookwormApp
//
//  Created by Merve Akçakaya on 19.05.2026.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    //birden fazla sıralama kuralı verebiliriz. title'lar aynıysa autho'a gore sırala diyoruz.
    @Query(sort: [
        SortDescriptor(\Book.title, order: .reverse),
        SortDescriptor(\Book.author)
    ]) var books: [Book]
    @State var showingAddScreen = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack{
                            EmojiRatingView(rating: book.rating).font(.largeTitle)
                            VStack(alignment: .leading){
                                Text(book.title).font(.headline)
                                Text(book.author).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self){book in
                DetailView(book: book)
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Book",systemImage: "plus"){
                        showingAddScreen.toggle()
                    }
                    
                }
            }
            .sheet(isPresented: $showingAddScreen){
                AddBookView()
            }
        }
    }
    func deleteBooks(at offSets : IndexSet){
        for offset in offSets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
