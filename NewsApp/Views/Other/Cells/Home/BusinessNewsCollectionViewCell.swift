//
//  MainNewsCollectionViewCell2.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 17.12.21.
//

import UIKit

class BusinessNewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BusinessNewsCollectionViewCell"
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sourceLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height-90
        newsImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: imageSize
        )
        
        titleLabel.frame = CGRect(
            x: 16,
            y: newsImageView.bottom+4,
            width: contentView.width-32,
            height: 50
        )
        
        sourceLabel.frame = CGRect(
            x: 16,
            y: titleLabel.bottom+2,
            width: contentView.width-32,
            height: 30
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        newsImageView.image = nil
        sourceLabel.text = nil
    }
    
    func configure(with viewModel: BusinessNewsCellViewModel) {
        titleLabel.text = viewModel.title
        newsImageView.setImage(with: viewModel.imageURL)
        sourceLabel.text = viewModel.source
    }
    
}
