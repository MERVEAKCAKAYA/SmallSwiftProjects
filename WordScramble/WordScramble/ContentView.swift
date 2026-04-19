//
//  ContentView.swift
//  WordScramble
//
//  Created by Merve Akçakaya on 17.04.2026.
//

import SwiftUI

struct ContentView: View {
    //kullanıcının bulduğu kelimelerin listesi
    @State private var usedWords = [String]()
    
    //ekranda görünen start.txt'ten çekilen rastgele kelime.
    @State private var rootWord = ""
    
    //TextField'daki anlık yazı
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    var body: some View {
        NavigationStack{
            List{
                Section(){
                    TextField("Enter your word : ", text: $newWord).textInputAutocapitalization(.never)
                }
                Section(){
                    ForEach(usedWords, id:\.self){ word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                    
                }
            }
            .navigationTitle(rootWord)
            //kullanıcı enter'a bastığında çalışan fonksiyon
            .onSubmit(addNewWord)
            //uygulama açıldığında otomatik çalışan fonksiyon
            .onAppear(perform: startGame)
            .alert(errorTitle,isPresented: $showingError) { }message: {
                Text(errorMessage)
            }
        }
    }
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        //kullanıcının girdiği kelime var ise devam et.
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer)else{
            wordError(title: "Word is already used", message: "Be more orijinal")
            return
        }
        
        guard isPossible(word: answer)else{
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer)else{
            wordError(title: "Word is not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
     
        newWord = ""
    }
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Couldn't load start.txt from bundle")
    }
    func isOriginal(word : String)->Bool{
        //yazılan kelime daha önce yazılmış mı diye kontrol eder
        !usedWords.contains(word)
    }
    func isPossible(word: String)-> Bool{
        //yazılan kelimedeki harfler ana kelimedeki harflerden farklı mı diye kontrol eder
        var tempWord = rootWord
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    //kelimenin sallama bir kelime olup olmadigini kontrol eder.
    func isReal(word: String)-> Bool{
        //girilen kelime gerçekte var olan bir kelime mi yoksa uydurulmuş bir kelime mi kotrol eder.
        //bu kütüphane objective-c kütüphanesidir. offline çalışır.
        let checker = UITextChecker()
        //kelimenin hangi aralığını kontrol etmek istediğimizi veriyoruz. utf16 kullanmasının sebebi bunun bir objective-c kütüphanesi olmasıdır.
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func wordError(title : String, message : String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
