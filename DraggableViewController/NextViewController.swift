//
//  NextViewController.swift
//  DraggableViewController
//
//  Created by Jiri Ostatnicky on 18/05/16.
//  Copyright © 2016 Jiri Ostatnicky. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    //MARK: - Properties
    var rootViewController: ViewController?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brown
        
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        if #available(iOS 11.0, *) {
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        }

    }
    
    //MARK: - Actions
    @objc func buttonTapped() {
        rootViewController?.disableInteractivePlayerTransitioning = true
        self.dismiss(animated: true) { [unowned self] in
            self.rootViewController?.disableInteractivePlayerTransitioning = false
        }
    }
}
