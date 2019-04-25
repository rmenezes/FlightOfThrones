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
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel.sync(completationHandler: { (error) in
                
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Handlers
    
    @objc func onBannerTapped() {
        
    }
    
    override func setupInterface() {
        view.backgroundColor = UIColor.fromHexa("#E4E4E4")
        
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
