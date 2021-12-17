//
//  TopNewsViewController.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 10.12.21.
//

import UIKit
import SafariServices

class TopNewsViewController: UIViewController {
    
    private var stories = [Article]()
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TopNewsTableViewCell.self, forCellReuseIdentifier: TopNewsTableViewCell.reuseId)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpTable()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchNews() {
        APICaller.shared.news(for: .topNews, newsCategory: .main) { [weak self] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories.articles
                    self?.tableView.reloadData()
                }
            case .failure: break
            }
            
        }
    }
    
    
    private func open(with url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    private func presentFailedToOpenAlert() {
        let alert = UIAlertController(
            title: "Unable to Open",
            message: "We were unable to open the article.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TopNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopNewsTableViewCell.reuseId, for: indexPath) as! TopNewsTableViewCell
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TopNewsTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let story = stories[indexPath.row]
        guard let url = URL(string: story.url) else {
            presentFailedToOpenAlert()
            return
        }
        open(with: url)
    }

}

