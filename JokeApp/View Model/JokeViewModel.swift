//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Foundation

class JokeViewModel: ObservableObject {
    
    func fetchData() {
        
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_ten") else { return }
        
        
    }
    
    
}
