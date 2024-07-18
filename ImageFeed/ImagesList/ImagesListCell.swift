//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by big stepper on 10/07/2024.
//

import UIKit


final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet private weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpGradientBackground()
    }
    
    private func setUpGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
                           UIColor.black.withAlphaComponent(0.2).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}

    
    
    
