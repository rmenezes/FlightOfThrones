//
//  NiblessViewController.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class NiblessViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupConstraints()
    }
    
    // MARK: Open
    func setupConstraints() {
        
    }
    
    func setupInterface() {
        
    }
    
    func displayError(error: Error?) {
        guard let error = error else { return }
        if let flError = error as? FlightOfThronesErrors {
            displayErrorWithMessage(message: flError.getMessage())
        } else {
            displayErrorWithMessage(message: error.localizedDescription)
        }
    }
    
    fileprivate func displayErrorWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sorry", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
