//
//  ContentView.swift
//  WordScramble
//
//  Created by Sean Walker on 8/29/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    func getScore() -> Int {
        var runningTotal = 0
        
        for word in usedWords {
            runningTotal += word.count
        }
        
        return runningTotal
    }
    
    var body: some View {
        NavigationView {
                List {
                    Section("Root Word") {
                        Text(rootWord.uppercased())
                            .font(Font.headline)
                    }
                    Section {
                        TextField("Enter your \(usedWords.isEmpty ? "first" : "next") word", text: $newWord)
                            .autocapitalization(.none)
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    }
                    Section("Your Score") {
                        Text("\(getScore())")
                    }
                }
                .navigationTitle("WordScramble")
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Restart", role: .destructive, action: startGame)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Score: \(getScore())")
                    }
                }
            }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else           {return}
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You cannot spell that word from \(rootWord)!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isLongEnough(word: answer) else {
            wordError(title: "Word too short", message: "Your words must be at least 3 letters long!")
            return
        }
        guard isNotTheRoot(word: answer) else {
            wordError(title: "Word is the root", message: "Nice try. Think of something else!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            guard tempWord.contains(letter) else {return false}
            tempWord.remove(at: tempWord.firstIndex(of: letter)!)
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isNotTheRoot(word: String) -> Bool {
        return word != rootWord
    }
    
    func wordError(title: String, message: String) {
        errorMessage = message
        errorTitle = title
        showingError = true
    }
    
    func startGame() {
        usedWords = [String]()
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load txt from the bundle")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
