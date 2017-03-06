//
//  WidgetChooserRouter.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 19.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import Foundation
import UIKit

class WidgetChooserRouter {
    var presenter: WidgetChooserPresenter!
    weak var userInterface: UIViewController!
    weak var presentingViewController: UIViewController!
    
    var moduleInterface: WidgetChooserModuleInterface {
        get {
            return presenter
        }
    }
    
    func presentModally(in viewController:UIViewController) {
        presentingViewController = viewController
        
        let navigationController = UINavigationController(rootViewController: userInterface)
        navigationController.modalPresentationStyle = .fullScreen
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(doneTouched(sender:)))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(dismiss(sender:)))
        navigationController.topViewController?.navigationItem.leftBarButtonItem = cancelButton
        
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func doneTouched(sender: UIButton) {
        presenter.didTapDoneButton()
        dismiss(sender: sender)
    }
    
    @objc func dismiss(sender: UIButton) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
