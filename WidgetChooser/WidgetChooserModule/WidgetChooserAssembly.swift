//
//  WidgetChooserAssembly.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 19.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import Foundation

class WidgetChooserAssembly {
    static func createWidgetChooserModule(with delegete:WidgetChooserModuleDelegate) -> WidgetChooserModuleInterface {
        let presenter = WidgetChooserPresenter()
        let viewController = WidgetChooserViewController()
        let router = WidgetChooserRouter()
        presenter.view = viewController
        presenter.router = router
        presenter.moduleOutput = delegete
        router.presenter = presenter
        router.userInterface = viewController
        viewController.eventHandler = presenter
        
        return presenter
    }
}
