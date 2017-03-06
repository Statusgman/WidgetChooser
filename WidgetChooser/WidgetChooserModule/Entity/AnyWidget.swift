//
//  AnyWidget.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 21.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import Foundation

// proxy
class AnyWidget: WidgetChooserEntity {
    
    private let _title: String
    private let _iconName: String?
    private let _widget: WidgetChooserEntity

    required init(_ widget:WidgetChooserEntity) {
        _title = widget.title
        _iconName = widget.iconName
        _widget = widget
    }
    
    func getWidget() -> WidgetChooserEntity {
        return _widget
    }
    
    // MARK: WidgetChooserEntity
    
    var iconName: String? {
        return _iconName
    }
    
    var title: String {
        return _title
    }
}

extension AnyWidget: Equatable {
    public static func ==(lhs: AnyWidget, rhs: AnyWidget) -> Bool {
        return lhs.title == rhs.title && lhs.iconName == rhs.iconName
    }
}

