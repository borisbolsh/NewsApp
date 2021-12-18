//
//  SportNewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 17.12.21.
//

import UIKit

class SportNewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SportNewsCollectionViewCell"
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.height,
            height: contentView.height
        )
        titleLabel.frame = CGRect(
            x: newsImageView.right + 10,
            y: 8,
            width: contentView.width - newsImageView.width - 20,
            height: contentView.height/2
        )
        descriptionLabel.frame = CGRect(
            x: newsImageView.right + 10,
            y: titleLabel.bottom + 10,
            width: contentView.width - newsImageView.width - 20,
            height: contentView.height/3
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        newsImageView.image = nil
        descriptionLabel.text = nil
    }
    
    func configure(with viewModel: SportNewsCellViewModel) {
        titleLabel.text = viewModel.title
        newsImageView.setImage(with: viewModel.imageURL)
        descriptionLabel.text = viewModel.source
    }
    
}
