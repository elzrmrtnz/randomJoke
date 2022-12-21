//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Combine

class JokeViewModel {
    private var cancellables = Set<AnyCancellable>()
    var refreshBtnStyle, favoriteBtnStyle,listBtnStyle : CustomBtn.ButtonType
    var setupLblStyle, punchLblStyle: CustomLbl.LabelType

    enum Input {
        case viewDidAppear
        case refreshButtonTap
    }
    
    enum Output {
        case fetchJokeDidFail(error:Error)
        case fetchJokeDidSucceed(joke: [JokeModel])
    }
    
    private let jokeServiceType: JokeServiceType
    private let output : PassthroughSubject<Output, Never> = .init()
    
    init(jokeServiceType: JokeServiceType = JokeService()) {
        self.jokeServiceType = jokeServiceType
        refreshBtnStyle = .refresh
        favoriteBtnStyle = .favorite
        listBtnStyle = .list
        setupLblStyle = .setup
        punchLblStyle = .puncline
    }    
    
    func getRandomJoke() {
        jokeServiceType.getRandomJoke().sink { [weak self] completion in
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





