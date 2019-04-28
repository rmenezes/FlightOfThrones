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
        observeOnError()
        
        viewModel.loadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func setupInterface() {
        view.backgroundColor = Apperance.Colors.gray
        title = NSLocalizedString("UI_DESTINATIONS_TITLE", comment: "")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
    
    fileprivate func observeDatasource() {
        viewModel.datasource.bind { (flights) in
            guard let flights = flights else { return }
            self.datasource = flights
        }
    }
    
    fileprivate func observeOnError() {
        self.viewModel.onError.bind { (error) in
            self.displayError(error: error)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        
        navigationController?.pushViewController(viewControllerFactory.makeFlightOptionsViewController(withDestination: item), animated: true)
    }
}

extension DestinationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Device.isIPad() ? (view.frame.width / 2) - 10 : view.frame.width
        
        if #available(iOS 11.0, *) {
            return CGSize(width: width - view.safeAreaInsets.right - view.safeAreaInsets.left, height: 120)
        } else {
            return CGSize(width: width, height: 120)
        }
    }
}

protocol DestinationViewControllerFactory {
    func makeFlightOptionsViewController(withDestination: FlightByPrice) -> FlightOptionsViewController
}
