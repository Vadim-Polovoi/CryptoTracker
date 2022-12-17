//
//  LoginViewController.swift
//  CryptoTracker
//
//  Created by Вадим on 6.11.22.
//

import UIKit


final class LoginViewController: UIViewController {
    
    private var loginTextField: UITextField = {
        var loginTextField = UITextField()
        loginTextField.placeholder = "Enter username"
        loginTextField.textColor = .systemGreen
        loginTextField.textAlignment = .center
        loginTextField.layer.cornerRadius = 5
        loginTextField.backgroundColor = .white
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        return loginTextField
    }()
    
    private var passwordTextField: UITextField = {
        var passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter password"
        passwordTextField.textColor = .systemGreen
        passwordTextField.textAlignment = .center
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.backgroundColor = .white
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    private var loginButtonXCenterConstraint: NSLayoutConstraint!
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = false
        button.backgroundColor = .white
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .systemGreen
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configureView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.loginButtonXCenterConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemGreen
        title = "Login Screen"
        view.addSubview(signInButton)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
    }
    
    private func setupConstraints() {
        let loginTextFieldConstraints = [
            loginTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 30),
            loginTextField.widthAnchor.constraint(equalToConstant: 160),
        ]
        let passwordTextFieldConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 25),
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            passwordTextField.widthAnchor.constraint(equalToConstant: 160),
        ]
        let loginButtonConstraints = [
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.widthAnchor.constraint(equalToConstant: 160),
        ]
        
        NSLayoutConstraint.activate(loginTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        
        loginButtonXCenterConstraint = NSLayoutConstraint(
            item: signInButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: -view.bounds.width
        )
        view.addConstraints([loginButtonXCenterConstraint])
    }
    
    @objc
    private func login() {
        let bounds = signInButton.bounds
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 10,
            options: .curveEaseInOut
        ) {
            self.signInButton.bounds = CGRect(
                x: bounds.origin.x - 50,
                y: bounds.origin.y,
                width: bounds.width + 100,
                height: bounds.height)

            self.signInButton.titleLabel?.bounds = CGRect(
                x: bounds.origin.x - 30,
                y: bounds.height / 2,
                width: bounds.width + 60,
                height: 0)
        }
        if loginTextField.text == "Vadim" {
            LoginManager.shared.login()
        }
    }
}
