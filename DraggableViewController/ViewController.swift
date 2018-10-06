//
//  ViewController.swift
//  DraggableViewController
//
//  Created by Jiri Ostatnicky on 18/05/16.
//  Copyright © 2016 Jiri Ostatnicky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    var disableInteractivePlayerTransitioning = false
    
    var bottomBar: BottomBar!
    var nextViewController: NextViewController!
    var presentInteractor: MiniToLargeViewInteractive!
    var dismissInteractor: MiniToLargeViewInteractive!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    func prepareView() {
        bottomBar = BottomBar()
        bottomBar.button.addTarget(self, action: #selector(self.bottomButtonTapped), for: .touchUpInside)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBar)
        
        [bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
         bottomBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
         bottomBar.heightAnchor.constraint(equalToConstant: 50)].forEach({ $0.isActive = true })
        if #available(iOS 11.0, *) {
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }
        
        nextViewController = NextViewController()
        nextViewController.rootViewController = self
        nextViewController.transitioningDelegate = self
        nextViewController.modalPresentationStyle = .fullScreen
        
        presentInteractor = MiniToLargeViewInteractive()
        presentInteractor.attachToViewController(viewController: self, withView: bottomBar, presentViewController: nextViewController)
        dismissInteractor = MiniToLargeViewInteractive()
        dismissInteractor.attachToViewController(viewController: nextViewController, withView: nextViewController.view, presentViewController: nil)
    }
    
    //MARK: - Actions
    @objc func bottomButtonTapped() {
        disableInteractivePlayerTransitioning = true
        self.present(nextViewController, animated: true) { [unowned self] in
            self.disableInteractivePlayerTransitioning = false
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        if #available(iOS 11.0, *) {
            animator.initialY = BottomBar.bottomBarHeight + self.view.safeAreaInsets.bottom
        } else {
            animator.initialY = BottomBar.bottomBarHeight
        }
        animator.transitionType = .Present
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        if #available(iOS 11.0, *) {
            animator.initialY = BottomBar.bottomBarHeight + self.view.safeAreaInsets.bottom
        } else {
            animator.initialY = BottomBar.bottomBarHeight
        }
        animator.transitionType = .Dismiss
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return dismissInteractor
    }
}
