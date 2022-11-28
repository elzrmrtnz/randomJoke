//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Foundation
import Combine

enum StocksError: Error {
    case invalidServerReponse
}

class WebService:  NSObject {
    
    func getJokes(url: URL) async throws -> [JokeModel] {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw StocksError.invalidServerReponse
        }
        
        return try JSONDecoder().decode([JokeModel].self, from: data)
    }
    
}
    

