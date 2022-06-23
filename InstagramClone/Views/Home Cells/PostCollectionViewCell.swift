//
//  PostCollectionViewCell.swift
//  InstagramClone
//
//  Created by Admin on 4/7/22.
//
import SDWebImage
import UIKit

protocol PostCollectionViewCellDelegate : AnyObject {
    func postCollectionViewCellDidLike(_ cell : PostCollectionViewCell)
}

final class PostCollectionViewCell: UICollectionViewCell {
   
        static let identifier = "PostCollectionViewCell"
    
    weak var delegate : PostCollectionViewCellDelegate?
    
    private let imageView : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let heartImageView : UIImageView = {
        let image = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 56))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.isHidden = true
        imageView.alpha = 0
        return imageView
    }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.clipsToBounds = true
            contentView.backgroundColor = .secondarySystemBackground
            contentView.addSubview(imageView)
            contentView.addSubview(heartImageView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapToLike))
            tap.numberOfTapsRequired = 2
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
    
    @objc func didDoubleTapToLike() {
        heartImageView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.heartImageView.alpha = 1
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.4) {
                    self.heartImageView.alpha = 0
                } completion: { done in
                    self.heartImageView.isHidden = true
                }

            }
        }

        
        delegate?.postCollectionViewCellDidLike(self)
    }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            imageView.frame = contentView.bounds
            
            let size  : CGFloat = contentView.width / 5
            heartImageView.frame = CGRect(x: contentView.width - size / 2, y: contentView.height - size / 2, width: size, height: size)
            
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = nil
        }
        func configure(with viewModel : PostCollectionViewCellViewModel) {
            imageView.sd_setImage(with: viewModel.postURL, completed: nil)
        }
    

}
