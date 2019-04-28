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
        observeOnError()
        
        sync()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Handlers
    @objc func onBannerTapped() {
        navigationController?.pushViewController(viewControllerFactory.makeDetinationsViewController(), animated: true)
    }
    
    @objc func onRefresh() {
        sync()
    }
    
    // MARK: Overrides
    override func setupInterface() {
        view.backgroundColor = Apperance.Colors.gray
        
        view.addSubview(bannerView)
        
        // Setup Title
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        logoImage.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImage
        
        // Setup Image Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefresh))
    }
    
    override func setupConstraints() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            bannerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        }
        
        bannerView.heightAnchor.constraint(equalToConstant: 183).isActive = true
    }
    
    fileprivate func observeIsBusy() {
        viewModel.isBusy.bind { (isBusy) in
            DispatchQueue.main.async {
                self.bannerView.isBusy = isBusy ?? false
                self.navigationItem.leftBarButtonItem?.isEnabled = !(isBusy ?? false)
            }
        }
    }
    
    fileprivate func observeOnError() {
        self.viewModel.onError.bind { (error) in
            self.displayError(error: error)
        }
    }
    
    fileprivate func sync() {
        self.viewModel.sync(completationHandler: { (error) in
            
        })
    }
}

protocol HomeViewControllerFactory {
    func makeDetinationsViewController() -> DestinationViewController
}
