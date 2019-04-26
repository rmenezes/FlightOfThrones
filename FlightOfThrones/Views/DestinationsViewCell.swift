//
//  DestinationsViewCell.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

let kDestinationViewCellIdentifier: String = "kDestinationViewCellIdenfifier"

class DestinationsViewCell: UICollectionViewCell {
    // Fields
    fileprivate let numberFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    // MARK: UI Elements
    fileprivate let originLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let destinationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Apperance.Colors.gray
        return view
    }()
    
    // MARK: Properties
    var datasource: FlightByPrice! {
        didSet {
            originLabel.attributedText = datasource.toOriginToNSAttributedString()
            destinationLabel.attributedText = datasource.toDestinationoNSAttributedString()
            
            // Price Label
            let price = numberFormat.string(from: NSNumber(value: datasource!.minPrice))?.split(separator: ".")
            // Symbol
            let attr = NSMutableAttributedString(string: datasource.currency.currencyToSymbol(), attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.black])
            // Decimal
            attr.append(NSAttributedString(string: String(price![0]), attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28),
                NSAttributedString.Key.foregroundColor: UIColor.black]))
            // Decinal Places
            attr.append(NSAttributedString(string:  ".\(price![1])", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.black]))
            
            priceLabel.attributedText = attr
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(originLabel)
        addSubview(separatorView)
        addSubview(destinationLabel)
        addSubview(priceLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        // Origin
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        originLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        originLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // Separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: frame.width * 0.7).isActive = true
        separatorView.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 10).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // Destination
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10).isActive = true
        destinationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // Price
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}

fileprivate extension FlightByPrice {
    func toOriginToNSAttributedString() -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "Origin", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: Apperance.Colors.middleGray])
        
        attrString.append(NSAttributedString(string: "\r\(outOrigin) - \(outDestination)", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black]))
        return attrString
    }
    
    func toDestinationoNSAttributedString() -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: "Destination", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: Apperance.Colors.middleGray])
        
        attrString.append(NSAttributedString(string: "\r\(inOrigin) - \(inDestination)", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black]))
        return attrString
    }
}
