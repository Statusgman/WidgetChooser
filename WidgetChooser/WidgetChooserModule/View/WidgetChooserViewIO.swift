//
//  WidgetChooserViewIO.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 15.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import Foundation

protocol WidgetChooserViewInput: class {
    func display(activeElements:[AnyWidget], inactiveElements:[AnyWidget])
    var activeElements: [AnyWidget] {get}
    var inactiveElements: [AnyWidget] {get}
}

protocol WidgetChooserViewOutput: class {
    
}
