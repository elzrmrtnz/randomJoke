//
//  JokeViewModel.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/24/22.
//

import Combine
import UIKit

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
    
    func getRandomJoke(){
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

class CustomBtn: UIButton {
    
    enum ButtonType {
        case refresh
        case favorite
        case list
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: ButtonType) {
        switch style {
        case .refresh:
            super.init(frame: .zero)
            backgroundColor = .systemBlue
            setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
            imageView?.tintColor = UIColor.white
            setTitle(" Refresh", for: .normal)
            configDefaultProperties()
        case .favorite:
            super.init(frame: .zero)
            backgroundColor = .systemPink
            setImage(UIImage(systemName: "heart.fill"), for: .normal)
            imageView?.tintColor = UIColor.white
            setTitle(" Favorite", for: .normal)
            configDefaultProperties()
        case .list:
            super.init(frame: .zero)
            setImage(UIImage(systemName: "list.bullet"), for: .normal)
            imageView?.tintColor = UIColor.systemPink
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configDefaultProperties() {
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.white, for: .normal)
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.masksToBounds = false
        contentMode = .scaleAspectFit
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
}

class CustomLbl: UILabel {
    
    enum LabelType {
        case setup
        case puncline
    }
    
    init(style: LabelType) {
        switch style {
        case .setup:
            super.init(frame: .zero)
            text = "Loading joke..."
        case .puncline:
            super.init(frame: .zero)
            text = " "
        }
        configDefaultProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configDefaultProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        sizeToFit()
    }
}

