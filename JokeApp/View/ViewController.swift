//
//  ViewController.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/23/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private let vm = JokeVM()
    
    var jokes: JokeModel!
    
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
    
    private let refreshBtn: UIButton = {
        let button = CustomButton()
        button.configure(with: CustomButtonVM(text: "Refresh",
                                              image: UIImage(systemName: "arrow.clockwise"),
                                              backgroundColor: .systemBlue))
        button.addTarget(self, action: #selector(refreshBtnTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    private let favoriteBtn: UIButton = {
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
        
        view.addSubview(setupLbl)
        view.addSubview(punchLbl)
        view.addSubview(refreshBtn)
        view.addSubview(favoriteBtn)
        
        navItems()
        setConstraints()
        
        Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        await vm.getAJoke(url: Constants.Urls.randomJokes)
        guard let joke = vm.jokes.randomElement() else {return}
        setupLbl.text = joke.setup
        punchLbl.text = joke.punchline
        setupLbl.sizeToFit()
        punchLbl.sizeToFit()
    }
    
    @objc func tapList() {
        let listVC = ListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc func tapFavorite() {
        let listVC = ListViewController()
        listVC.addJoke(setup: setupLbl.text!, punch: punchLbl.text!)
    }
    
    @objc func refreshBtnTap() {
        Task {
            await loadData()
        }
    }
    
    private func setConstraints() {
        setupLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        setupLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        setupLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        punchLbl.topAnchor.constraint(equalTo: setupLbl.bottomAnchor, constant: 10).isActive = true
        punchLbl.leadingAnchor.constraint(equalTo: setupLbl.leadingAnchor).isActive = true
        
        refreshBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        refreshBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        refreshBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        refreshBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        favoriteBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        favoriteBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        favoriteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        favoriteBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
