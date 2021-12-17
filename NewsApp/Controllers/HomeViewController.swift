//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 9.12.21.
//

import UIKit

enum BrowseSectionType {
    case mainNews(viewModels: [MainNewsCellViewModel])
    case businessNews(viewModels: [BusinessNewsCellViewModel])
    case sportNews(viewModels: [SportNewsCellViewModel])
    
    var title: String {
        switch self {
        case .mainNews:
            return "Main news"
        case .businessNews:
            return "Business news"
        case .sportNews:
            return "Sport news"
            
        }
    }
}

class HomeViewController: UIViewController {
    
    private var mainNews: [Article] = []
    private var businessNews: [Article] = []
    private var sportNews: [Article] = []

    private var sections = [BrowseSectionType]()
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
        //        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        collectionView.register(MainNewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainNewsCollectionViewCell.identifier)
        
        collectionView.register(BusinessNewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: BusinessNewsCollectionViewCell.identifier)
        
        collectionView.register(SportNewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: SportNewsCollectionViewCell.identifier)
    
        
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var mainNews: SearchResponse?
        var businessNews: SearchResponse?
        var sportNews: SearchResponse?
        
        APICaller.shared.news(for: .topNews, newsCategory: .main) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                mainNews = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APICaller.shared.news(for: .topNews, newsCategory: .business) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                businessNews = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        APICaller.shared.news(for: .topNews, newsCategory: .sports) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                sportNews = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        group.notify(queue: .main) {
            guard let mainNews = mainNews?.articles,
                  let businessNews = businessNews?.articles,
                  let sportNews = sportNews?.articles else {
                fatalError("Models are nil")
            }
            self.configureModels(
                mainNews: mainNews,
                businessNews: businessNews,
                sportNews: sportNews
            )
        }
    }
    
    private func configureModels(
        mainNews: [Article],
        businessNews: [Article],
        sportNews: [Article]
    ) {
        self.mainNews = mainNews
        self.businessNews = businessNews
        self.sportNews = sportNews
        
        sections.append(.mainNews(viewModels: mainNews.compactMap({
            return MainNewsCellViewModel(
                name: URL(string: $0.urlToImage ?? "") ,
                artworkURL: URL(string: $0.url),
                numberOfTracks: $0.source?.name ?? "",
                artistName: $0.author ?? "-"
            )
        })))
        
        sections.append(.businessNews(viewModels: businessNews.compactMap({
            return BusinessNewsCellViewModel(
                name: URL(string: $0.urlToImage ?? "") ,
                artworkURL: URL(string: $0.url),
                numberOfTracks: $0.source?.name ?? "",
                artistName: $0.author ?? "-"
            )
        })))
        
        sections.append(.sportNews(viewModels: sportNews.compactMap({
            return SportNewsCellViewModel(
                name: URL(string: $0.urlToImage ?? "") ,
                artworkURL: URL(string: $0.url),
                numberOfTracks: $0.source?.name ?? "",
                artistName: $0.author ?? "-"
            )
        })))
        
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .mainNews(let viewModels):
            return viewModels.count
        case .businessNews(let viewModels):
            return viewModels.count
        case .sportNews(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        case .mainNews(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainNewsCollectionViewCell.identifier,
                for: indexPath
            ) as? MainNewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .businessNews(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BusinessNewsCollectionViewCell.identifier,
                for: indexPath
            ) as? BusinessNewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .sportNews(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SportNewsCollectionViewCell.identifier,
                for: indexPath
            ) as? SportNewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                )
            )

            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )

            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            )

            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        
        case 2:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )

            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}
