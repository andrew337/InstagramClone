//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Admin on 4/4/22.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private let headerView = SignInHeaderView()
    
    private let emailField : IGTextField = {
        let field = IGTextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        
        return field
    }()
    
    private let passwordField : IGTextField = {
        let password = IGTextField()
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.keyboardType = .default
        password.returnKeyType = .continue
        password.autocorrectionType = .no
        
        return password
    }()
    
    private let signInButton : UIButton = {
        
       let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        return button
    }()
    
    private let createAccountBUtton : UIButton = {
       let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let termsButton : UIButton = {
       let button = UIButton()
        button.setTitle("Terms and Conditions", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let privacyButton : UIButton = {
       let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .secondarySystemBackground
        headerView.backgroundColor = .red
        addSubviews()
        emailField.delegate = self
        passwordField.delegate = self
        
        addButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width,
                                  height: (view.height - view.safeAreaInsets.top)/3)
        
        emailField.frame = CGRect(x: 25, y: headerView.bottom+20, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50)
        signInButton.frame = CGRect(x: 35, y: passwordField.bottom+25, width: view.width-70, height: 50)
        createAccountBUtton.frame = CGRect(x: 35, y: signInButton.bottom+20, width: view.width-70, height: 50)
        termsButton.frame = CGRect(x: 35, y: createAccountBUtton.bottom+50, width: view.width-70, height: 40)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom+10, width: view.width-70, height: 40)
    }

    private func addButtonActions() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountBUtton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountBUtton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    // MARK: Button Actions
    @objc func didTapSignIn() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty,
              let password = passwordField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
                  return
              }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let vc = TabbarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                    print("Worked")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func didTapTerms() {
        guard let url = URL(string: "https://www.instagram.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapPrivacy() {
        guard let url = URL(string: "https://www.instagram.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.completion = { [weak self] in
            DispatchQueue.main.async {
                let tabVC = TabbarViewController()
                tabVC.modalPresentationStyle = .fullScreen
                self?.present(tabVC, animated: true)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapSignIn()
        }
        return true
    }
}
