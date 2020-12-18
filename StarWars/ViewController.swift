//
//  ViewController.swift
//  StarWars
//
//  Created by Christian Shirichena on 12/18/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var StarWarsTableView: UITableView!
    @IBOutlet weak var StarWarsImage: UIImageView!    
    @IBOutlet weak var StarWarsLabel: UILabel!
    
    var starwarsArray: [StarWars] = []  // declaring an array for StarWars on tableview
    var limit = 10 // limit of characters per page
    let totalEntries = 82 // upper limit of starwar characters
    var starwarsBatch: [Result] = []
    var nextURL: String = ""
    //        var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.StarWarsTableView.register(UINib(nibName: "StarWarsTableViewCell", bundle: nil), forCellReuseIdentifier: "StarWarsTableViewCell")
        self.StarWarsTableView.dataSource = self
        self.StarWarsTableView.delegate = self
        self.getThirtyStarWars() // Loadview, what displays on view controller
        self.getInitialData()
    }
    
    func getInitialData() {
        starwarsBatch = []
        nextURL = "https://swapi.dev/api/people/"
        getDataFromStarWars()
    }
    func getDataFromStarWars() {
        if isArrayFull() == false {
            guard let urlObj = URL(string: nextURL) else {return}
            URLSession.shared.dataTask(with: urlObj) {[weak self](data, response, error) in
                guard let data = data else {return}
                do {
                    let downloadedStarWars = try JSONDecoder().decode(PaginatedStarwars.self, from: data)
                    self?.starwarsBatch.append(contentsOf: downloadedStarWars.results)
                    self?.nextURL = downloadedStarWars.next
                    
                    DispatchQueue.main.async {
                        self?.StarWarsTableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            }
            .resume()
        }
    }
    
 
    private func getThirtyStarWars(){
        self.StarWarsTableView.register(UINib(nibName: "StarWarsTableViewCell", bundle: nil), forCellReuseIdentifier: "StarWarsTableViewCell")
        self.StarWarsTableView.dataSource = self
        let group = DispatchGroup() // Dispatch Group  - displays 10 Starwars characters at a time
        for _ in 1...82 {
            group.enter()
            NetworkingManager.shared.getDecodableObject(from: self.createStarWarsURL()) {  (starwars: StarWars?, error) in
                guard let starwars = starwars else {return}
                self.starwarsArray.append(starwars)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.StarWarsTableView.reloadData()
        }
    }
    
    func isArrayFull() -> Bool {
        if starwarsBatch.count < totalEntries { return false}
        else {
            return true
        }
    }
    
    private func createStarWarsURL () -> String {
        let randomNumber = Int.random(in: 1...82)
        return "https://swapi.dev/api/people/\(randomNumber)"
    }
    
    private func generateAlert(from error: Error) -> UIAlertController {
        let alert = UIAlertController (
            title: "Error", message: "We ran into an error! Error Description: \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StarWarsDetailsViewController {
            destination.starwars = starwarsArray[StarWarsTableView.indexPathForSelectedRow!.row]
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.starwarsBatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = starwarsBatch.count
        let lastElement = count - 1
        if indexPath.row == lastElement {
            getDataFromStarWars()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarWarsTableViewCell", for: indexPath) as!
            StarWarsTableViewCell
        cell.configure(with: self.starwarsArray[indexPath.row])
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
extension ViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPath: [IndexPath]) {
        let lastIndex = IndexPath(row: self.starwarsArray.count - 1, section: 0)
        guard indexPath.contains(lastIndex) else {return}
        self.getThirtyStarWars() // infinite scrolling
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsScreen", sender: self) // connects pokemon details viewcontroller with main view controller.
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndexPath = indexPath.row
        if indexPath.row == starwarsArray.count - 1 {
            if starwarsArray.count < totalEntries {
                //                //self.getAllPokemon(pageNumber)
            }
        }
    }
}


