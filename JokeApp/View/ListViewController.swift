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
        view.backgroundColor = .systemMint
        title = "Favorite Joke List"
        
        view.addSubview(tableView)
        getAllJokes()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.setup.text = model.setup
        cell.puncline.text = model.punchline
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func  tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let model = models[indexPath.row]
            self.deleteJoke(item: model)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
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
    
    func addJoke(setup: String, punch: String) {
        let newJoke = JokeListItem(context: context)
        newJoke.setup = setup
        newJoke.punchline = punch
        
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
