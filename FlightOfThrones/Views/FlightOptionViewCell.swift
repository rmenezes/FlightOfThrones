//
//  FlightOptionViewCell.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

let kFlighOptionViewCellIdentifier: String = "kFlighOptionViewCellIdentifier"

class FlightOptionViewCell: UICollectionViewCell {
    // MARK: UI Elements
    // Header
    fileprivate let departingOnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let returningOnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let viewHeaderDetails: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Apperance.Colors.bordeu
        return view
    }()
    
    fileprivate let imageArrow: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "IconArrowSeparator"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // Price
    fileprivate let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let allTaxes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "All taxes and fee includes"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = Apperance.Colors.middleGray
        return label
    }()
    
    // Departure
    fileprivate let departureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DEPARTURE"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = Apperance.Colors.middleGray
        return label
    }()
    
    fileprivate let departureCompanyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Apperance.Colors.middleGray
        return label
    }()
    
    fileprivate let departureInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let depatureCompanyLogo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "IconCompanyPlaceholder"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate let departureCheck: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "IconCheck"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    fileprivate let depatureSepatator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Apperance.Colors.middleGray
        return view
    }()
    
    // Return
    fileprivate let returnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "RETURN"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = Apperance.Colors.middleGray
        return label
    }()
    
    fileprivate let returnCompanyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Apperance.Colors.middleGray
        return label
    }()
    
    fileprivate let returnInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let returnCompanyLogo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "IconCompanyPlaceholder"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate let returnCheck: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "IconCheck"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    fileprivate let returnSepatator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Apperance.Colors.middleGray
        return view
    }()
    
    // MARK: Properties
    var datasource: Flight! {
        didSet {
            // Departing
            let departAttr = NSMutableAttributedString(string: "DEPARTING ON ", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8),
                NSAttributedString.Key.foregroundColor: Apperance.Colors.middleGray])
            departAttr.append(NSAttributedString(string: datasource.outbound.departureDate , attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.black]))
            
            departingOnLabel.attributedText = departAttr
            
            // Returning
            let returtAttr = NSMutableAttributedString(string: "RETURNING ON ", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8),
                NSAttributedString.Key.foregroundColor: Apperance.Colors.middleGray])
            returtAttr.append(NSAttributedString(string: datasource?.inbound.departureDate ?? "--", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.black]))
            
            returningOnLabel.attributedText = departAttr
            
            // Flight Value
            price.attributedText = datasource!.price.toCurrencyAttributesString(currency: datasource!.currency.currencyToSymbol(), withSize: 14)
            
            // Out Company
            departureCompanyLabel.text = datasource.outbound.airline
            
            // Out Informations
            departureInformationLabel.attributedText = datasource.toFlightDepartureDurationAttributedString()
            
            // In Company
            returnCompanyLabel.text = datasource.inbound.airline
            
            // In Company
            returnInformationLabel.attributedText = datasource.toFlightReturnDurationAttributedString()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(departingOnLabel)
        addSubview(returningOnLabel)
        addSubview(viewHeaderDetails)
        addSubview(imageArrow)
        
        addSubview(price)
        addSubview(allTaxes)
        
        addSubview(departureLabel)
        addSubview(departureCompanyLabel)
        addSubview(departureInformationLabel)
        addSubview(depatureCompanyLogo)
        addSubview(departureCheck)
        addSubview(depatureSepatator)
        
        addSubview(returnLabel)
        addSubview(returnCompanyLabel)
        addSubview(returnInformationLabel)
        addSubview(returnCompanyLogo)
        addSubview(returnCheck)
        addSubview(returnSepatator)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    fileprivate func setupConstraints() {
        // Departure Label
        departingOnLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        departingOnLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // Returning Label
        returningOnLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        returningOnLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        // Arror Image
        imageArrow.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageArrow.centerYAnchor.constraint(equalTo: returningOnLabel
            .centerYAnchor).isActive = true
        
        // Header View
        viewHeaderDetails.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        viewHeaderDetails.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        viewHeaderDetails.heightAnchor.constraint(equalToConstant: 5).isActive = true
        viewHeaderDetails.topAnchor.constraint(equalTo: departingOnLabel.bottomAnchor, constant: 5).isActive = true
        
        // Price Label
        price.topAnchor.constraint(equalTo: viewHeaderDetails.bottomAnchor, constant: 15).isActive = true
        price.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        allTaxes.centerYAnchor.constraint(equalTo: price.centerYAnchor).isActive = true
        allTaxes.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        // Departure - Title
        departureLabel.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 25).isActive = true
        departureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        // Departure - Company Image
        depatureCompanyLogo.bottomAnchor.constraint(equalTo: departureLabel.bottomAnchor).isActive = true
        depatureCompanyLogo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        // Departure - Company Name
        departureCompanyLabel.bottomAnchor.constraint(equalTo: depatureCompanyLogo.bottomAnchor).isActive = true
        departureCompanyLabel.trailingAnchor.constraint(equalTo: depatureCompanyLogo.leadingAnchor, constant: -5).isActive = true
        
        // Departure - Separator
        depatureSepatator.topAnchor.constraint(equalTo: departureLabel.bottomAnchor, constant: 5).isActive = true
        depatureSepatator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        depatureSepatator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        depatureSepatator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Departure - Check
        departureCheck.topAnchor.constraint(equalTo: depatureSepatator.bottomAnchor, constant: 15).isActive = true
        departureCheck.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        // Departure - Information
        departureInformationLabel.topAnchor.constraint(equalTo: departureCheck.topAnchor).isActive = true
        departureInformationLabel.leadingAnchor.constraint(equalTo: departureCheck.trailingAnchor, constant: 10).isActive = true
        
        // Return - Title
        returnLabel.topAnchor.constraint(equalTo: departureInformationLabel.bottomAnchor, constant: 25).isActive = true
        returnLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        // Return - Company Image
        returnCompanyLogo.bottomAnchor.constraint(equalTo: returnLabel.bottomAnchor).isActive = true
        returnCompanyLogo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        // Return - Company Name
        returnCompanyLabel.bottomAnchor.constraint(equalTo: returnCompanyLogo.bottomAnchor).isActive = true
        returnCompanyLabel.trailingAnchor.constraint(equalTo: returnCompanyLogo.leadingAnchor, constant: -5).isActive = true
        
        // Return - Separator
        returnSepatator.topAnchor.constraint(equalTo: returnLabel.bottomAnchor, constant: 5).isActive = true
        returnSepatator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        returnSepatator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        returnSepatator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Return - Check
        returnCheck.topAnchor.constraint(equalTo: returnSepatator.bottomAnchor, constant: 15).isActive = true
        returnCheck.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        // Return - Information
        returnInformationLabel.topAnchor.constraint(equalTo: returnCheck.topAnchor).isActive = true
        returnInformationLabel.leadingAnchor.constraint(equalTo: returnCheck.trailingAnchor, constant: 10).isActive = true
    }
}
