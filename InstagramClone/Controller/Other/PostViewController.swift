//
//  PostViewController.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import UIKit

class PostViewController: UIViewController {
    
    private let post : Post
    
    init(post : Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }

}
