//
//  TopNewsTableViewCell.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 10.12.21.
//

import UIKit

class TopNewsTableViewCell: UITableViewCell {

    static let reuseId = "TopNewsTableViewCell"
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source: Source?
        let headline: String?
        let dateString: String
        let imageURL: URL?
        
        init(model: Article) {
            self.source = model.source
            self.headline = model.title
            self.dateString = DateFormatter.changeDateFormat(from: model.publishedAt ?? "no date")
            self.imageURL = URL(string: model.urlToImage ?? "")
        }

    }
    
    // MARK: - Views
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sourceLabel, headlineLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 3
        return stack
    }()
    
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .secondaryLabel
        return imageView
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let imageSize: CGFloat = contentView.height/1.4
        storyImageView.frame = CGRect(
            x: 16,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 10
        dateLabel.frame = CGRect (
            x: storyImageView.right + 16,
            y: contentView.height-46,
            width: availableWidth - 16,
            height: 40
        )
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: storyImageView.right + 16,
            y: 20,
            width: availableWidth - 16,
            height: sourceLabel.height
        )
        
        headlineLabel.frame = CGRect(
            x: storyImageView.right + 16,
            y: sourceLabel.bottom + 5,
            width: availableWidth - 16,
            height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
        
     
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        imageView?.image = nil
    }
    
    
    func configure(with viewModel: ViewModel) {
    
        sourceLabel.text = viewModel.source?.name ?? "unknown"
        headlineLabel.text = viewModel.headline
        dateLabel.text = viewModel.dateString
        storyImageView.setImage(with: viewModel.imageURL)
        
    }

}
