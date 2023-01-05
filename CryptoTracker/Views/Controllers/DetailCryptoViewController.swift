//
//  DetailCryptoViewController.swift
//  CryptoTracker
//
//  Created by Вадим on 6.11.22.
//

import UIKit


class DetailCryptoViewController: UIViewController {
    
    init(model: CryptoModel) {
        nameLabel.text = model.name
        symbolLabel.text = model.symbol
        priceLabel.text = model.priceUsd.formatToString() + " $"
        super.init(nibName: nil, bundle: nil)
        ApiManager.shared.getCryptoIcon(cryptoSymbol: model.symbol.lowercased()) { [weak self] dataIcon in
            DispatchQueue.main.async {
                guard let image = UIImage(data: dataIcon) else {
                    self?.iconImageView.image = UIImage(named: "genericIcon")
                    return
                }
                self?.iconImageView.image = image
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView: UIImageView = {
        let containerView = UIImageView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        view.addSubview(iconImageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(symbolLabel)
        containerView.addSubview(priceLabel)
        setupConstraints()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.backward.square"),
            style: .done,
            target: self,
            action: #selector(logout)
        )
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupConstraints() {
        let iconImageViewConstraints = [
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            iconImageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 5),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ]
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 70),
        ]
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        ]
        let symbolLabelConstraints = [
            symbolLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
        ]
        let priceLabelConstraints = [
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(symbolLabelConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
    }
    
    @objc func logout() {
        LoginManager.shared.logout()
    }
}
