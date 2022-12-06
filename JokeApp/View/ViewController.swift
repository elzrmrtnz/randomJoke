//
//  ViewController.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/23/22.
//

import UIKit
import Combine
import CoreData

class ViewController: UIViewController {
    
    private let viewModel = JokeViewModel()
    private let coreData = JokeDataManager()
    private let input : PassthroughSubject<JokeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 25.0
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let setupLbl: UILabel = {
        let setup = UILabel(frame: .zero)
        setup.translatesAutoresizingMaskIntoConstraints = false
        setup.numberOfLines = 0
        setup.text = "Loading joke..."
        setup.sizeToFit()
        
        return setup
    }()
    
    private let punchLbl: UILabel = {
        let punch = UILabel(frame: .zero)
        punch.translatesAutoresizingMaskIntoConstraints = false
        punch.numberOfLines = 0
        punch.text = " "
        punch.sizeToFit()
        
        return punch
    }()
    
    let loader: UIActivityIndicatorView = {
        var loader = UIActivityIndicatorView(frame: .zero)
        loader.style = .medium
        return loader
    }()
    
    private lazy var refreshBtn: UIButton = {
        let button = CustomButton()
        button.configure(with: CustomButtonVM(text: "Refresh",
                                              image: UIImage(systemName: "arrow.clockwise"),
                                              backgroundColor: .systemBlue))
        button.addTarget(self, action: #selector(refreshBtnTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    private lazy var favoriteBtn: UIButton = {
        let button = CustomButton()
        button.configure(with: CustomButtonVM(text: "Favorite",
                                              image: UIImage(systemName: "heart.fill"),
                                              backgroundColor: .systemPink))
        button.addTarget(self, action: #selector(tapFavorite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func navItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapList))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemMint
        title = "J🤣keApp"
        
        navItems()
        setupConstraints()
        setupBinders()
    }
    
    override func loadView() {
        super.loadView()
        [stackView,setupLbl,punchLbl,loader,favoriteBtn,refreshBtn].forEach { item in
            self.view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    @objc func tapList() {
        let listVC = ListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc func tapFavorite() {
        coreData.addJoke(setup: setupLbl.text!, punch: punchLbl.text!)
        debugPrint("Added to Favorite")
    }
    
    @objc func refreshBtnTap() {
        input.send(.refreshButtonTap)
    }
    
    private func setupBinders(){
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            switch event{
            case .fetchJokeDidSucceed(let joke):
                guard let joke = joke.randomElement() else {return}
                self?.setupLbl.text = joke.setup
                self?.punchLbl.text = joke.punchline
            case .fetchJokeDidFail(let error):
                self?.setupLbl.text = error.localizedDescription
                self?.punchLbl.text = error.localizedDescription
            case .toggleButton(let isEnabled):
                self?.refreshBtn.isEnabled = isEnabled
                self?.refreshBtn.backgroundColor = isEnabled ? .systemBlue : .systemGray5
            case .toggleLoading(let loading):
                loading ? self?.loader.startAnimating() : self?.loader.stopAnimating()
                if(loading == false){
                    self?.setupLbl.isHidden = false
                    self?.punchLbl.isHidden = false
                    self?.loader.isHidden = true
                }
                
            }
        }
        .store(in: &cancellables)
    }
    
    func setupConstraints(){
        [setupLbl,punchLbl,loader,favoriteBtn,refreshBtn].forEach { item in
            stackView.addArrangedSubview(item)
        }
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            
            favoriteBtn.heightAnchor.constraint(equalToConstant: 50),
            favoriteBtn.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 30),
            favoriteBtn.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -30),
            
            refreshBtn.heightAnchor.constraint(equalToConstant: 50),
            refreshBtn.leadingAnchor.constraint(equalTo: favoriteBtn.leadingAnchor),
            refreshBtn.trailingAnchor.constraint(equalTo: favoriteBtn.trailingAnchor)
            
        ])
    }
}
