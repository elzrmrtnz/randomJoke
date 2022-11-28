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

//struct JokeViewModel {
//    private let joke: JokeModel
//
//    init(joke: JokeModel) {
//        self.joke = joke
//    }
//
//    var setup: String {
//        joke.setup
//    }
//
//    var punchline: String {
//        joke.punchline
//    }
//}

//    private var webService: WebService!
//    private(set) var joke : [JokeModel]! {
//            didSet {
//                self.bindJokeVMToController()
//            }
//        }
//
//    var bindJokeVMToController: (() -> ()) = {}
//
//    override init() {
//        super.init()
//        self.webService = WebService()
//        randomJokeData()
//    }
//
//    func randomJokeData() {
//        self.webService.getJokeData { (joke) in
//            self.joke = [joke].randomElement()
//        }
//    }
