//
//  WidgetChooserPresenter.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 15.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import Foundation
import UIKit

class WidgetChooserPresenter: WidgetChooserModuleInterface, WidgetChooserViewOutput {
    var view: WidgetChooserViewInput!
    var router: WidgetChooserRouter!
    weak var moduleOutput: WidgetChooserModuleDelegate!
    
    func display(activeElements: [WidgetChooserEntity], inactiveElements: [WidgetChooserEntity]) {
        var active: [AnyWidget] = []
        for item in activeElements {
            active.append(AnyWidget(item))
        }
        
        var inactive: [AnyWidget] = []
        for item in inactiveElements {
            inactive.append(AnyWidget(item))
        }
        
        view.display(activeElements: active, inactiveElements: inactive)
    }
    
    func didTapDoneButton() {
        let active = getWidgetEntities(view.activeElements)
        let inactive = getWidgetEntities(view.inactiveElements)
        moduleOutput.didChooseWidgets(activeElements: active, inactiveElements: inactive)
    }
    
    func getWidgetEntities(_ entities:[WidgetChooserEntity]) -> [WidgetChooserEntity] {
        var activeEntities: [WidgetChooserEntity] = []
        for item in entities {
            if let widget = item as? AnyWidget {
                activeEntities.append(widget.getWidget())
            }
        }
        return activeEntities
    }
    
    func presentModally(in viewController:UIViewController) {
        router.presentModally(in: viewController)
    }
}
