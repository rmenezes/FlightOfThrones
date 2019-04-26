//
//  HomeViewController.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright (c) 2019 Raul Menezes. All rights reserved.
//

import UIKit

class HomeViewController: NiblessViewController {
    // MARK: UI Elements
    fileprivate var bannerView: Banner = {
        let banner = Banner()
        banner.addTarget(self, action: #selector(onBannerTapped), for: .touchDown)
        return banner
    }()
    
    // MARK: Fields
    fileprivate let viewModel: HomeViewModelProtocol
    fileprivate let viewControllerFactory: HomeViewControllerFactory
    
    init(viewModel: HomeViewModelProtocol, viewControllerFactory: HomeViewControllerFactory) {
        self.viewModel = viewModel
        self.viewControllerFactory = viewControllerFactory
        
        super.init()
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeIsBusy()
        
        self.viewModel.sync(completationHandler: { (error) in
            
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Handlers
    @objc func onBannerTapped() {
        navigationController?.pushViewController(viewControllerFactory.makeDetinationsViewController(), animated: true)
    }
    
    func observeIsBusy() {
        viewModel.isBusy.bind { (isBusy) in
            DispatchQueue.main.async {
                self.bannerView.isBusy = isBusy ?? false
            }
        }
    }
    
    // MARK: Overrides
    override func setupInterface() {
        view.backgroundColor = Apperance.Colors.gray
        
        view.addSubview(bannerView)
        
        // Setup Title
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        logoImage.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImage
    }
    
    override func setupConstraints() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 183).isActive = true
    }
}

protocol HomeViewControllerFactory {
    func makeDetinationsViewController() -> DestinationViewController
}
