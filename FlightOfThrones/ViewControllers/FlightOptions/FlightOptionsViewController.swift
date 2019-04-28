//
//  FlightOptionsViewController.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class FlightOptionsViewController: NiblessViewController {
    // MARK: Fields
    fileprivate let viewModel: FlightOptionsViewModelProtocol
    fileprivate var destination: FlightByPrice
    fileprivate var datasource = [Flight]() {
        didSet {
            DispatchQueue.main.async {
                self.resultsView.totalOfResults = self.datasource.count
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UI Elements
    fileprivate let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FlightOptionViewCell.self, forCellWithReuseIdentifier: kFlighOptionViewCellIdentifier)
        collectionView.backgroundColor = Apperance.Colors.gray
        return collectionView
    }()
    
    fileprivate let resultsView: TotalOfResultView = TotalOfResultView()
    
    init(viewModel: FlightOptionsViewModelProtocol, destination: FlightByPrice) {
        self.viewModel = viewModel
        self.destination = destination
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.loadData(withFlightOptions: destination)
        observeOnIsBusy()
        observeOnError()
        observeDataSource()
    }
    
    // MARK: Private
    fileprivate func observeOnIsBusy() {
        viewModel.isBusy.bind { (isBusy) in
            
        }
    }
    
    fileprivate func observeOnError() {
        self.viewModel.onError.bind { (error) in
            self.displayError(error: error)
        }
    }
    
    fileprivate func observeDataSource() {
        viewModel.datasource.bind { (flights) in
            guard let flights = flights else { return }
            self.datasource = flights
        }
    }
    
    // MARK: Overrides
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func setupInterface() {
        title = NSLocalizedString("UI_FLIGHT_OPTIONS_TITLE", comment: "")
        
        view.backgroundColor = Apperance.Colors.gray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        resultsView.destination = "\(destination.outOrigin) / \(destination.outDestination)"
        
        view.addSubview(collectionView)
        view.addSubview(resultsView)
    }
    
    override func setupConstraints() {
        if #available(iOS 11.0, *) {
            // Results View
            resultsView.translatesAutoresizingMaskIntoConstraints = false
            resultsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            
            resultsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            resultsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            resultsView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            
            // Collection View
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor.constraint(equalTo: resultsView.bottomAnchor, constant: 20).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Results View
            resultsView.translatesAutoresizingMaskIntoConstraints = false
            resultsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            
            resultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            resultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            resultsView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            
            // Collection View
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor.constraint(equalTo: resultsView.bottomAnchor, constant: 20).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}

extension FlightOptionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Device.isIPad() ? (view.bounds.width / 2) - 10 : view.bounds.width
        
        if #available(iOS 11.0, *) {
            return CGSize(width: width - view.safeAreaInsets.right - view.safeAreaInsets.left, height: 274)
        } else {
            return CGSize(width: width, height: 274)
        }
    }
}

extension FlightOptionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kFlighOptionViewCellIdentifier, for: indexPath) as! FlightOptionViewCell
        viewCell.datasource = datasource[indexPath.row]
        return viewCell
    }
}
