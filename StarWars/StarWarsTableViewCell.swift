//
//  StarWarsTableViewCell.swift
//  StarWars
//
//  Created by Christian Shirichena on 12/18/20.
//

import UIKit

class StarWarsTableViewCell: UITableViewCell {

    @IBOutlet weak var StarWarsImage: UIImageView!
    
    @IBOutlet weak var StarWarsLabel: UILabel!
    
    func configure(with starwars: StarWars) {
        self.StarWarsLabel.text = starwars.name
        NetworkingManager.shared.getImageData(from: starwars.frontImageURL) { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.StarWarsImage.image = UIImage(data: data)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
