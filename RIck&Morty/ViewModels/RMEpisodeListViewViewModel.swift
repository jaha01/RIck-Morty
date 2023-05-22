//
//  RMEpisodeListViewViewModel.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 22.05.2023.
//

import Foundation

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
    
    func didSelectEpisode(_ episode: RMEpisode)
}

/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreCharacter = false
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes /*where !cellViewModels.contains(where: { $0.characterName == character.name})*/ {
//                let viewModel = RMEpisodeCollectionViewCellViewModel(characterName: character.name,
//                                                                       characterStatus: character.status,
//                                                                       characterImageUrl: URL(string: character.image))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    /// fetch initial set of character
    public func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
//                print("Example image url: " + String(describing: model.results.first?.image ?? "No image"))
//                print("Page result count: " + String(describing: model.results.count))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional character are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacter else {
            return
        }
        isLoadingMoreCharacter = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacter = false
            print("Failure to create request")
            return
        }
            
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startIndex ..< (startIndex+newCount)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathToAdd)
                    strongSelf.isLoadingMoreCharacter = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacter = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil

    }
}

// MARK: - CollectionView
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeCollectionViewCell else {
                fatalError("Unsuported cell")
            }
        //cell.backgroundColor = .systemGreen
//        let viewModel = RMEpisodeCollectionViewCellViewModel(characterName: "Jaha", characterStatus: .alive, characterImageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
          let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView
                 else {
                    fatalError("Unsupported")
                }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100) // добавили размер футер
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.5)
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - ScrollView
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacter,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= totalContentHeight - totalScrollViewFixedHeight - 120 {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
