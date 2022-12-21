//
//  ViewController.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/23/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private let viewModel = JokeViewModel()
    private let coreData = JokeDataManager()
    private let refreshBtn, favoriteBtn, listBtn: CustomBtn
    private let setupLbl, punchLbl: CustomLbl
    private let input : PassthroughSubject<JokeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        refreshBtn = CustomBtn(style: viewModel.refreshBtnStyle)
        favoriteBtn = CustomBtn(style: viewModel.favoriteBtnStyle)
        listBtn = CustomBtn(style: viewModel.listBtnStyle)
        setupLbl = CustomLbl(style: viewModel.setupLblStyle)
        punchLbl = CustomLbl(style: viewModel.punchLblStyle)
        super.init(nibName: nil, bundle: nil)
        refreshBtn.addTarget(self, action: #selector(refreshBtnTap), for: .touchUpInside)
        favoriteBtn.addTarget(self, action: #selector(tapFavorite), for: .touchUpInside)
        listBtn.addTarget(self, action: #selector(tapList), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        title = "J🤣keApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupConstraints()
        setupBinders()
    }
    
    override func loadView() {
        super.loadView()
        [stackView,setupLbl,punchLbl,favoriteBtn,refreshBtn].forEach { item in
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
            }
        }
        .store(in: &cancellables)
    }
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 25.0
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    func setupConstraints(){
        [setupLbl,punchLbl].forEach { item in
            stackView.addArrangedSubview(item)
        }
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        
            favoriteBtn.heightAnchor.constraint(equalToConstant: 50),
            favoriteBtn.bottomAnchor.constraint(equalTo: refreshBtn.topAnchor, constant: -5),
            favoriteBtn.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 100),
            favoriteBtn.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -100),
            
            refreshBtn.heightAnchor.constraint(equalToConstant: 50),
            refreshBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            refreshBtn.leadingAnchor.constraint(equalTo: favoriteBtn.leadingAnchor),
            refreshBtn.trailingAnchor.constraint(equalTo: favoriteBtn.trailingAnchor)
        ])
    }
}
