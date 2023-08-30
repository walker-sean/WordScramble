//
//  ContentView.swift
//  WordScramble
//
//  Created by Sean Walker on 8/29/23.
//

import SwiftUI

struct ContentView: View {
    func whatevs() {
        let word = "swift"
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let allGood = misspelledRange.location == NSNotFound
    }
    
    
    var body: some View {
        Text("\(NSNotFound)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
