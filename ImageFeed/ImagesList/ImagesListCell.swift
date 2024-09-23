//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by big stepper on 10/07/2024.
//

import UIKit
import Kingfisher


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}


final class ImagesListCell: UITableViewCell {
    
    //MARK: - Delegate
    
    weak var delegate: ImagesListCellDelegate?
    
    //MARK: - Properties
    
    static let reuseIdentifier: String = "ImagesListCell"
    let dateFormatter = DateFormatter.dateFormatter
    
    //MARK: - Outlets
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = .SFPro.withSize(13).withWeight(.medium)
            dateLabel.textColor = .ypWhite
        }
    }
    
    @IBOutlet private weak var gradientView: UIView! {
        didSet {
            gradientView.layer.masksToBounds = true
            gradientView.layer.cornerRadius = 16
            gradientView.backgroundColor = .clear
        }
    }
    
    //MARK: - Methods
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpGradientBackground()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    private func setUpGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
                           UIColor.black.withAlphaComponent(0.2).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setIsLiked(isLiked: Bool) {
        let liked = isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        likeButton.setImage(liked, for: .normal)
    }
    
    func configCell(photo: Photo) -> Bool {
        var status = false
        
        setIsLiked(isLiked: photo.isLiked)
        
        guard let url = URL(string: photo.thumbImageURL) else { return status }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "stub"),
                              options: [.processor(processor)]
        ){ [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                status = true
            case .failure(_):
                cellImage.image = UIImage(named: "stub")
            }
        }
        
        guard let date = photo.createdAt else {
            print("there is no date provided")
            return status }
        
        dateLabel.text = dateFormatter.string(from: date)
        
        return status
    }
}

    
    
    
