//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Foundation
import Combine

class JokeViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    enum Input {
        case viewDidAppear
        case refreshButtonTap
    }
    
    enum Output {
        case fetchJokeDidFail(error:Error)
        case fetchJokeDidSucceed(joke: [JokeModel])
        case toggleButton(isEnabled:Bool)
        case toggleLoading(loading: Bool)
    }
    
    private let jokeServiceType: JokeServiceType
    private let output : PassthroughSubject<Output, Never> = .init()
    
    init(jokeServiceType: JokeServiceType = JokeService()) {
        self.jokeServiceType = jokeServiceType
    }
    
    func getRandomJoke(){
        output.send(.toggleLoading(loading: true))
        output.send(.toggleButton(isEnabled: false))
        jokeServiceType.getRandomJoke().sink { [weak self] completion in
            self?.output.send(.toggleLoading(loading: false))
            self?.output.send(.toggleButton(isEnabled: true))
            switch completion {
            case .failure(let error):

                self?.output.send(.fetchJokeDidFail(error: error))
            case .finished:
                debugPrint("Random joke received")
            }
        } receiveValue: { [weak self] joke in
            self?.output.send(.fetchJokeDidSucceed(joke: joke))
        }.store(in: &cancellables)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>{

        input.sink { [weak self] event in
            switch event{
            case .refreshButtonTap, .viewDidAppear:
                self?.getRandomJoke()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

