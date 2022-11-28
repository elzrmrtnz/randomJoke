//
//  ListViewController.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/26/22.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var models = [JokeListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Joke List"
        view.addSubview(tableView)
        getAllJokes()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String("\(model.setup)\n\(model.punchline)")
        return cell
    }
    
    func getAllJokes() {
        do {
            models = try context.fetch(JokeListItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func addJoke(_ jokes: JokeModel) {
        let newJoke = JokeListItem(context: context)
        newJoke.setup = jokes.setup
        newJoke.punchline = jokes.punchline
        
        saveData()
    }

    func deleteJoke(item: JokeListItem) {
        context.delete(item)
        
        saveData()
    }
    
    func saveData() {
        do {
            try context.save()
            getAllJokes()
        } catch {
            
        }
    }
}
