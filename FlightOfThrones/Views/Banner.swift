//
//  Banner.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class Banner: UIControl {
    // MARK: UI Elements
    fileprivate let bgBanner: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "BgBanner"))
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    fileprivate let dragonButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.setTitle(NSLocalizedString("UI_HOME_BUTTON_SEARCH", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(onSearchDragonsButton), for: .touchDown)
        return button
    }()
    
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.isHidden = true
        return activity
    }()
    
    // MARK: Fields
    fileprivate var onSearchDragonsSelector: Selector? = nil
    
    // MARK: Properties
    var isBusy: Bool = false {
        didSet {
            onIsBusy()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSearchDragonsButton() {
        sendActions(for: .touchDown)
    }
    
    // MARK: Private
    fileprivate func setup() {
        self.layer.cornerRadius = 5
        
        clipsToBounds = true
        
        addSubview(bgBanner)
        addSubview(dragonButton)
        addSubview(activityIndicator)

        setupContraints()
    }
    
    fileprivate func setupContraints() {
        // Banner
        bgBanner.translatesAutoresizingMaskIntoConstraints = false
        
        bgBanner.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bgBanner.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // Dragon Button
        dragonButton.translatesAutoresizingMaskIntoConstraints = false
        dragonButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        dragonButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        dragonButton.widthAnchor.constraint(equalToConstant: 137).isActive = true
        dragonButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        dragonButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    fileprivate func onIsBusy() {
        if isBusy {
            self.dragonButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.dragonButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}
