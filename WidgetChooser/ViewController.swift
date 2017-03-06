//
//  ViewController.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 15.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import UIKit

extension Widget: WidgetChooserEntity {}

class Entity: WidgetChooserEntity {
    var title: String = ""
    var iconName: String?
}

class ViewController: UIViewController, WidgetChooserModuleDelegate {
    
    var widgetChooserModule: WidgetChooserModuleInterface?
    var activeElements: [Widget] = []
    var inactiveElements: [Widget] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        generateWidgets()
    }
    
    func generateWidgets() {
        for i in 0..<5 {
            let widget = Widget(title: "\(i)", iconName: nil)
            activeElements.append(widget)
        }
        
        for i in 5..<10 {
            let widget = Widget(title: "\(i)", iconName: nil)
            inactiveElements.append(widget)
        }
    }
    
    
    // MARK: - IB
    
    @IBAction func addWidget(_ sender: AnyObject) {
        widgetChooserModule = WidgetChooserAssembly.createWidgetChooserModule(with: self)
        widgetChooserModule?.display(activeElements: activeElements, inactiveElements: inactiveElements)
        widgetChooserModule?.presentModally(in: self)
    }
    
    
    // MARK: - WidgetChooserModuleDelegate
    
    func didChooseWidgets(activeElements:[WidgetChooserEntity], inactiveElements:[WidgetChooserEntity]) {
        print(activeElements as! [Widget])
        print(inactiveElements as! [Widget])
        widgetChooserModule = nil
    }
}

