//
//  PostCaptionCollectionViewCell.swift
//  InstagramClone
//
//  Created by Admin on 4/7/22.
//

import UIKit

protocol PostCaptionCollectionViewCellDelegate : AnyObject {
    func postCaptionCollectionViewCellDidTapCaption( _ cell : PostCaptionCollectionViewCell)
}

class PostCaptionCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCaptionCollectionViewCell"
    
    weak var delegate : PostCaptionCollectionViewCellDelegate?
    
    private let label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCaption))
        label.addGestureRecognizer(tap)
    }
    
    @objc func didTapCaption() {
        delegate?.postCaptionCollectionViewCellDidTapCaption(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = label.sizeThatFits(CGSize(width: contentView.bounds.size.width, height: contentView.bounds.size.height))
        label.frame = CGRect(x: 12, y: 3, width: size.width, height: size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    func configure(with viewModel : PostCaptionCollectionViewCellModel) {
        label.text = "\(viewModel.username) : \(viewModel.caption ?? "")"
    }

}
