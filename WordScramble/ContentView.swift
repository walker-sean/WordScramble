//
//  ContentView.swift
//  WordScramble
//
//  Created by Sean Walker on 8/29/23.
//

import SwiftUI

struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    func loadFile() {
        if let fileUrl = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileUrl) {
                
            }
        }
    }
        
    
    var body: some View {
        List(people, id: \.self) {
            Text($0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
