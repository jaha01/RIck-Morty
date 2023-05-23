//
//  RMEpisodeListView.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 22.05.2023.
//

import UIKit


protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(
        _ characterListView: RMEpisodeListView,
        didSelectEpisode episode: RMEpisode
    )
}

/// View that handles showing list of episodes, loader, etc
final class RMEpisodeListView: UIView {
    
    public weak var delegate: RMEpisodeListViewDelegate?
    
    private let viewModel = RMEpisodeListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier) // добавили футер для загрузки
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        //backgroundColor = .systemBlue
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
        setupCollectionView()
    }
    required init?(coder: NSCoder) {
        fatalError("Unsopported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
 
        //  эта часть была захардкожена
//        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//            self.spinner.stopAnimating()
//
//            self.collectionView.isHidden = false
//
//            UIView.animate(withDuration: 0.4) {
//                self.collectionView.alpha = 1
//            }
//        })
    }
}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
    
    func didLoadInitialEpisodes() {
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Initial fetch
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
        
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
            }
        }
}
