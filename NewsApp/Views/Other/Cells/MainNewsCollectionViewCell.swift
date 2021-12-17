//
//  MainNewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 11.12.21.
//

import UIKit

class MainNewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainNewsCollectionViewCell"

    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
    
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(numberOfTracksLabel)
        contentView.layer.cornerRadius = 16
        setGradientBackground()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width-imageSize-10,
                height: contentView.height-10
            )
        )
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()

        // Image
        albumCoverImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)

        // Album name label
        let albumLabelHeight = min(60, albumLabelSize.height)
        albumNameLabel.frame = CGRect(
            x: 16,
            y: imageSize - 100,
            width: albumLabelSize.width,
            height: albumLabelHeight
        )

        artistNameLabel.frame = CGRect(
            x: 16,
            y: albumNameLabel.bottom + 4,
            width: contentView.width - 10,
            height: 30
        )

        numberOfTracksLabel.frame = CGRect(
            x: 16,
            y: artistNameLabel.bottom + 4,
            width: contentView.width-10,
            height: 30
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }

    func configure(with viewModel: MainNewsCellViewModel) {
        albumNameLabel.text = viewModel.numberOfTracks
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.setImage(with: viewModel.name)
    }
    
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.95).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = contentView.bounds
                
        albumCoverImageView.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
