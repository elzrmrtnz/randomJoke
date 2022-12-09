//
//  JokeListData.swift
//  JokeApp
//
//  Created by eleazar.martinez on 12/2/22.
//

import Foundation
import CoreData

class JokeDataManager {
    
    static let shared = JokeDataManager()
    
    let container: NSPersistentContainer
    private let containerName: String = "JokeData"
    @Published var jokeList: [JokeListItem] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Loading Core Data. \(error)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    func getAllJokes() {
        let request = NSFetchRequest<JokeListItem>(entityName: "JokeListItem")
        do {
            jokeList = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addJoke(setup: String, punch: String) {
        let newJoke = JokeListItem(context: container.viewContext)
        newJoke.setup = setup
        newJoke.punchline = punch
        saveData()
    }
    
    func addJoke(setup: String) {
        let newJoke = JokeListItem(context: container.viewContext)
        newJoke.setup = setup
        saveData()
    }

    func deleteJoke(item: JokeListItem) {
        container.viewContext.delete(item)
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            getAllJokes()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
