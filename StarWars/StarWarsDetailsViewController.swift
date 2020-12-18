//
//  StarWarsDetailsViewController.swift
//  StarWars
//
//  Created by Christian Shirichena on 12/18/20.
//

import UIKit

class StarWarsDetailsViewController: UIViewController {
    @IBOutlet weak var StarWarsDetailsImage: UIImageView!
    @IBOutlet weak var StarWarsDetailLabel: UILabel!
    
    var starwars: StarWars?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StarWarsDetailLabel.text = starwars?.name
        NetworkingManager.shared.getImageData(from: starwars!.frontImageURL) { (data, error) in
            guard let data = data else {return}
            DispatchQueue.main.async { // Dispatch queue asychroniusly loads details view, showing more details regarding sprite images.
                self.StarWarsDetailsImage.image = UIImage(data: data)
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
