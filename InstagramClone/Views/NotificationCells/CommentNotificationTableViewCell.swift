//
//  CommentNotificationTableViewCell.swift
//  InstagramClone
//
//  Created by Admin on 4/19/22.
//

import UIKit

protocol CommentNotificationTableViewCellDelegate : AnyObject {
    func commentNotificationTableViewCellDidTapPost(_ cell : CommentNotificationTableViewCell, didTapPostWith viewModel : CommentNotificationCellViewModel)
}

class CommentNotificationTableViewCell: UITableViewCell {

    static let identifier = "CommentNotificationTableViewCell"
    
    var viewModel : CommentNotificationCellViewModel?
    
    weak var delegate : CommentNotificationTableViewCellDelegate?
    
    private let profilePictureImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let postPictureImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight : .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        addSubview(label)
        addSubview(profilePictureImageView)
        addSubview(postPictureImageView)
        addSubview(dateLabel)
        
        postPictureImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postPictureImageView.addGestureRecognizer(tap)
    }
    @objc private func didTapPost() {
        guard let vm = viewModel else { return }
        
        delegate?.commentNotificationTableViewCellDidTapPost(self, didTapPostWith: vm)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = contentView.height / 1.5
        profilePictureImageView.frame = CGRect(x: 10, y: (contentView.height - imageSize) / 2, width: imageSize, height: imageSize)
        profilePictureImageView.layer.cornerRadius = imageSize / 2
        
        let postSize : CGFloat = contentView.height - 6
        postPictureImageView.frame = CGRect(x: contentView.width - postSize - 10, y: 3, width: postSize, height: postSize)
        
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - profilePictureImageView.right - 25 - postSize, height: contentView.height))
        dateLabel.sizeToFit()
        label.frame = CGRect(x: profilePictureImageView.right + 10, y: 0, width: labelSize.width, height: contentView.height - dateLabel.height - 2)
        
        dateLabel.frame = CGRect(x: profilePictureImageView.right + 10, y: contentView.height - dateLabel.height - 2, width: dateLabel.width, height: dateLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilePictureImageView.image = nil
        postPictureImageView.image = nil
        dateLabel.text = nil
    }

    public func configure(with viewModel : CommentNotificationCellViewModel) {
        self.viewModel = viewModel
        profilePictureImageView.sd_setImage(with: viewModel.profilePictureURL, completed: nil)
        postPictureImageView.sd_setImage(with: viewModel.postURL, completed: nil)
        label.text = viewModel.username + " commented on your post."
        dateLabel.text = viewModel.date
    }

}
