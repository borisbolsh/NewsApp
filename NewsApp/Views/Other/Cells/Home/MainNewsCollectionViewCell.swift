//
//  MainNewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 11.12.21.
//

import UIKit

final class MainNewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainNewsCollectionViewCell"

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.addSubview(sourceLabel)
        setGradientBackground()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height
       
        dateLabel.sizeToFit()
        sourceLabel.sizeToFit()

        newsImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: contentView.height
        )

        titleLabel.frame = CGRect(
            x: 16,
            y: imageSize - 100,
            width: contentView.width - 32,
            height: 60
        )

        dateLabel.frame = CGRect(
            x: 16,
            y: titleLabel.bottom + 4,
            width: contentView.width - 10,
            height: 30
        )

        sourceLabel.frame = CGRect(
            x: 16,
            y: titleLabel.top - 22,
            width: contentView.width - 10,
            height: 22
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
        sourceLabel.text = nil
        newsImageView.image = nil
    }

    func configure(with viewModel: MainNewsCellViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        sourceLabel.text = viewModel.source 
        newsImageView.setImage(with: viewModel.imageURL)
    }
    
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.95).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = contentView.bounds
                
        newsImageView.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
