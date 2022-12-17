//
//  CryptoTableViewCell.swift
//  CryptoTracker
//
//  Created by Вадим on 31.10.22.
//

import UIKit


class CryptoTableViewCell: UITableViewCell {
    
    static let identifier = "CryptoTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
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
    
    private let percentChangeUsdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .light)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(percentChangeUsdLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        percentChangeUsdLabel.text = nil
        iconImageView.image = nil
    }
    
    private func setupConstraints() {
        let iconImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ]
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
        ]
        let symbolLabelConstraints = [
            symbolLabel.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: -5),
            symbolLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
        ]
        let priceLabelConstraints = [
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        let percentChangeUsdLabelConstraints = [
            percentChangeUsdLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            percentChangeUsdLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
        ]
        
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(symbolLabelConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
        NSLayoutConstraint.activate(percentChangeUsdLabelConstraints)
    }

    func configure(with model: CryptoModel) {
        nameLabel.text = model.name
        symbolLabel.text = model.symbol
        priceLabel.text = model.priceUsd.formatToString() + " $"
        percentChangeUsdLabel.text = model.percentChangeUsdLast24Hours.formatToString() + " %"
        percentChangeUsdLabel.textColor = model.percentChangeUsdLast24Hours < 0 ? .systemRed : .systemGreen
    }
}

