//
//  WidgetChooserModuleIO.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 19.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import Foundation
import UIKit

protocol WidgetChooserEntity {
    var iconName: String? {get}
    var title: String {get}
}

protocol WidgetChooserModuleInterface: class {
    func presentModally(in viewController:UIViewController)
    func display(activeElements:[WidgetChooserEntity], inactiveElements:[WidgetChooserEntity])
}

protocol WidgetChooserModuleDelegate: class {
    func didChooseWidgets(activeElements:[WidgetChooserEntity], inactiveElements:[WidgetChooserEntity])
}
