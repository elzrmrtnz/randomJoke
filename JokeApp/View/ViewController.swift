//
//  ViewController.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let vm = JokeVM()
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Loading joke..."
        label.sizeToFit()
        
        return label
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
    
    private let navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        return navBar
    }()
    
    private let navItem: UINavigationItem = {
        let item = UINavigationItem()
        item.title = "J🤣keApp"
        item.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(tapList))
        
        return item
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(navBar)
        navBar.setItems([navItem], animated: false)
        
        view.addSubview(label)
        view.addSubview(refreshBtn)
        view.addSubview(favoriteBtn)
        
        setConstraints()
        
        Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        await vm.getAJoke(url: Constants.Urls.randomJokes)
        guard let joke = vm.jokes.randomElement() else {return}
        label.text = "\(joke.setup)\n\(joke.punchline)"
        label.sizeToFit()
    }
    
    @objc func tap() {
        print("tapped")
    }
    
    @objc func tapList() {
        let listVC = ListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc func tapFavorite() {
        print(label.text)
    }
    
    @objc func refreshBtnTap() {
        Task {
            await loadData()
        }
    }
    
    private func setConstraints() {
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
