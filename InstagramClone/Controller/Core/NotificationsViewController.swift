//
//  NotificationsViewController.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import UIKit
import AVFAudio

class NotificationsViewController: UIViewController {
    
    private let noActivityLsbel : UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "No Notifications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.identifier)
        tableView.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        tableView.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels : [NotificationCellType] = []
    private var models : [IGNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notifications"
        view.addSubview(tableView)
        view.addSubview(noActivityLsbel)
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotifications()
       
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        noActivityLsbel.sizeToFit()
        noActivityLsbel.center = view.center
    }
    
    
    private func fetchNotifications() {

        NotificationManager.shared.getNotifications { [weak self] models in
            DispatchQueue.main.async {
                self?.models = models
                self?.createViewModels()
            }
        }
        
    }
    
    private func createViewModels() {
        models.forEach { models in
            guard let type = NotificationManager.IGType(rawValue: models.notificationType) else {
                return
            }
            let username = models.username
            guard let profilePictureURL = URL(string: models.profilePictureURL) else { return }
            
            switch type {
            case .like:
                guard let postURL = URL(string: models.postURL ?? "") else { return }
                viewModels.append(.like(viewModel: LikeNotificationCellViewModel(username: username, profilePictureURL: profilePictureURL, postURL: postURL, date: models.dateString)))
            case .comment:
                guard let postURL = URL(string: models.postURL ?? "") else { return }
                viewModels.append(.comment(viewModel: CommentNotificationCellViewModel(username: username, profilePictureURL: profilePictureURL, postURL: postURL, date: models.dateString)))
            case .follow:
                guard let isFollowing = models.isFollowing else { return }
                viewModels.append(.follow(viewModel: FollowNotificationCellViewModel(username: username, profilePictureUrl: profilePictureURL, isCurrentUserFollowing: isFollowing, date: models.dateString)))
            }
        }
        
        if viewModels.isEmpty {
            noActivityLsbel.isHidden = false
            tableView.isHidden = true
        } else {
            noActivityLsbel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func mockData() {
        tableView.isHidden = false
        
        guard let postURL = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png") else { return }
        guard let iconURL = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else { return }
        
        viewModels = [
            .like(viewModel: LikeNotificationCellViewModel(username: "person", profilePictureURL: iconURL, postURL: postURL, date: "Mar")),
            .comment(viewModel: CommentNotificationCellViewModel(username: "2ncperson", profilePictureURL: iconURL, postURL: postURL, date: "")),
            .follow(viewModel: FollowNotificationCellViewModel(username: "me", profilePictureUrl: iconURL, isCurrentUserFollowing: true, date: "May"))
        ]
        
        tableView.reloadData()
    }

}

extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        
        switch viewModel {
        case .follow(let viewModel) :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowNotificationTableViewCell.identifier, for: indexPath) as? FollowNotificationTableViewCell else { fatalError() }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        case .comment(let viewModel) :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else { fatalError() }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
            
        case .like(let viewModel) :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else { fatalError() }
            cell.configure(with: viewModel)
            cell.delagate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let cellType = viewModels[indexPath.row]
        let username : String
        
        switch cellType {
        case .follow(let viewModel):
            username = viewModel.username
        case .like(let viewModel):
            username = viewModel.username
        case .comment(let viewModel):
            username = viewModel.username
        }
        
//        DatabaseManager.shared.findUser(usernane: username) { [weak self] user in
//            guard let user = user else { return }
//
//            DispatchQueue.main.async {
//                let vc = ProfileViewController(user: user)
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            guard let user = user else { return }
            
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension NotificationsViewController : LikeNotificationTableViewCellDelegate, CommentNotificationTableViewCellDelegate, FollowNotificationTableViewCellDelegate {
    func followNotificationTableViewCellDidTapButton(_ cell: FollowNotificationTableViewCell, didTapButton isFollowing: Bool, viewModel: FollowNotificationCellViewModel) {
        
        let username = viewModel.username
        
        DatabaseManager.shared.updateRelationship(state: isFollowing ? .follow : .unfollow, for: username) { success in
            //
        }
    }
    
    
    
    
    func openPost(with index : Int, username : String) {
        print(index)
        
        guard index < models.count else { return }
        let model = models[index]
        
        let username = username
        guard let postID = model.postID else { return}
        
        DatabaseManager.shared.getPosts(with: postID, from: username) { [weak self] post in
            DispatchQueue.main.async {
                guard let post = post else {
                    let alert = UIAlertController(title: "Oops", message: "We are unable to open this post.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                
                let vc = PostViewController(post: post)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func LikeNotificationTableViewCellDidTapPost(_ cell: LikeNotificationTableViewCell, didTapPostWith viewModel: LikeNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .comment, .follow:
                return false
            case .like(let current):
                return current == viewModel
            }
        }) else { return }
        
        openPost(with: index, username: viewModel.username)
    }
    
    func commentNotificationTableViewCellDidTapPost(_ cell: CommentNotificationTableViewCell, didTapPostWith viewModel: CommentNotificationCellViewModel) {
        
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .like, .follow:
                return false
            case .comment(let current):
                return current == viewModel
            }
        }) else { return }
        
        openPost(with: index, username: viewModel.username)
    }
    
    
    
}
