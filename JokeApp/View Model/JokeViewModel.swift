//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Foundation
import Combine

class JokeVM: NSObject {
    
    private(set) var jokes: [JokeModel] = []
    
    func getAJoke(url: URL) async {
        do {
            let jokes = try await WebService().getJokes(url: url)
            self.jokes = jokes
        } catch {
            print(error)
        }
    }
    
}
