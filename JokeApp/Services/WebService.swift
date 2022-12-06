//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Foundation
import Combine

enum ErrorType: Error{
    case invalidURL
    case noResponse
}

protocol JokeServiceType {
    func getRandomJoke() -> AnyPublisher<[JokeModel],Error>
}

enum StocksError: Error {
    case invalidServerReponse
}

class JokeService: JokeServiceType {
    func getRandomJoke() -> AnyPublisher<[JokeModel], Error> {
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_ten") else {
             fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
        
            .tryMap { data, _ in
                try JSONDecoder().decode([JokeModel].self, from: data)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
