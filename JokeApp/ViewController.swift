//
//  ViewController.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Loading joke..."
        label.sizeToFit()
        return label
    }()
    
    private let refreshBtn: UIButton = {
        let button = UIButton(frame: .zero)
        let image = UIImage(systemName: "arrow.clockwise")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(loadData), for:
        .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var dataTask: URLSessionDataTask?
    
    private var joke: [JokeModel]? {
        didSet {
            guard let joke = joke?.randomElement() else { return }
            label.text = "\(joke.setup)\n\(joke.punchline)"
            label.sizeToFit()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(refreshBtn)
        setConstraints()
        
        loadData()
    }
    
    private func setConstraints() {
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        refreshBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant:  10).isActive = true
        refreshBtn.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
    }
    
    
    @objc private func loadData() {
        
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_ten") else {return}
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let decodedData = try? JSONDecoder().decode([JokeModel].self, from: data) {
                DispatchQueue.main.async {
                    self.joke = decodedData
                }
            }
        }
        dataTask?.resume()
    }
}

struct JokeModel: Decodable {
    let id: Double
    let type: String
    let setup: String
    let punchline: String
}
