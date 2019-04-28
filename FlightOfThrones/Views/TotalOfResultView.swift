//
//  TotalOfResultView.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class TotalOfResultView: UIView {
    // MARK: UI Elements
    fileprivate let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Apperance.Colors.middleGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 results"
        return label
    }()
    
    // MARK: Properties
    var destination: String = "" {
        didSet {
            destinationLabel.text = destination
        }
    }
    
    var totalOfResults: Int = 0 {
        didSet {
            totalLabel.text = "\(totalOfResults) results"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(destinationLabel)
        addSubview(totalLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        setupConstraints()
    }
    
    // MARK: Private
    fileprivate func setupConstraints() {
        // Destination
        destinationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        destinationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // Total
        totalLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}
