//
//  DestinationViewController.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class DestinationViewController: NiblessViewController {
    // MARK: Fields
    fileprivate let viewModel: DestinationViewModelProtocol
    fileprivate let viewControllerFactory: DestinationViewControllerFactory
    fileprivate var datasource = [FlightByPrice]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UI Elements
    fileprivate var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DestinationsViewCell.self, forCellWithReuseIdentifier: kDestinationViewCellIdentifier)
        collectionView.backgroundColor = Apperance.Colors.gray
        return collectionView
    }()
    
    init(viewModel: DestinationViewModelProtocol, viewControllerFactory: DestinationViewControllerFactory) {
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeDatasource()
        viewModel.loadData()
    }
    
    override func setupInterface() {
        view.backgroundColor = Apperance.Colors.gray
        title = "Dragons"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func observeDatasource() {
        viewModel.datasource.bind { (flights) in
            guard let flights = flights else { return }
            self.datasource = flights
        }
    }
}

extension DestinationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kDestinationViewCellIdentifier, for: indexPath) as! DestinationsViewCell
        viewCell.datasource = datasource[indexPath.row]
        
        return viewCell
    }
}

extension DestinationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 120)
    }
}

protocol DestinationViewControllerFactory {
    func makeFlightOptionsViewController() -> UIViewController
}
