//
//  ViewController.swift
//  Grid
//
//  Created by Hessam Mahdiabadi on 6/2/23.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Int>
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, Int>
    
    private var collectionView: UICollectionView!
    private var dataSource: DiffableDataSource!
    
    private lazy var contentInset: NSDirectionalEdgeInsets = {
        let inset: CGFloat = 2
        return NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setupData()
    }

    private func configureCollectionView() {
        let layout = createGridLayout()
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addCollectionIntoView()
        registerCellIntoCollection()
        configureDiffableDataSource()
    }
    
    private func addCollectionIntoView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func registerCellIntoCollection() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    private func configureDiffableDataSource() {
        dataSource = DiffableDataSource(collectionView: collectionView,
                                        cellProvider: { [weak self] _, indexPath, item in
            return self?.createCell(forIndexPath: indexPath, item: item)
        })
    }

    private func createCell(forIndexPath indexPath: IndexPath, item: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let color: UIColor

        switch item % 10 {
        case 1: color = .red
        case 2: color = .blue
        case 3: color = .green
        case 4: color = .yellow
        case 5: color = .orange
        case 6: color = .purple
        case 7: color = .magenta
        case 8: color = .link
        case 9: color = .yellow
        default: color = .orange
        }
        
        cell.backgroundColor = color
        cell.layer.cornerRadius = 8

        return cell
    }

    private func setupData() {
        var initialSnapshot = DiffableSnapshot()
        let items = Array(0 ..< 100)
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(items, toSection: .main)
        self.dataSource.apply(initialSnapshot, animatingDifferences: true)
    }
    
    private func createLargeItemWithVerticalItemsGroup(isReverse: Bool = false) -> NSCollectionLayoutGroup {
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2 / 3),
                                                   heightDimension: .fractionalWidth(2 / 3))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = contentInset
        
        let innerVerticalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .fractionalWidth(1))
        let innerVerticalItem = NSCollectionLayoutItem(layoutSize: innerVerticalItemSize)
        innerVerticalItem.contentInsets = contentInset
        
        let innertVerticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                                    heightDimension: .fractionalWidth(2 / 3))
        let innertVerticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: innertVerticalGroupSize,
                                                            subitems: [innerVerticalItem])
        
        var subitemsInGroup = [largeItem, innertVerticalGroup]
        if isReverse {
            subitemsInGroup.reverse()
        }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalWidth(2 / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: subitemsInGroup)
        
        return group
    }
    
    private func createMiddleGroup() -> NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                                   heightDimension: .fractionalWidth(1 / 3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = contentInset
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalWidth(1 / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                            subitems: [item])
        return group
    }

    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let topGroup = createLargeItemWithVerticalItemsGroup()
        let middleGroup = createMiddleGroup()
        let bottomGroup = createLargeItemWithVerticalItemsGroup(isReverse: true)
        
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(100))
        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: mainGroupSize,
                                                           subitems: [topGroup, middleGroup,
                                                                      middleGroup, bottomGroup,
                                                                      middleGroup, middleGroup])

        let section = NSCollectionLayoutSection(group: mainGroup)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
