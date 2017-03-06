//
//  WidgetChooserCell.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 21.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import UIKit

class WidgetChooserCell: UITableViewCell {
    
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
    
    var viewModel: AnyWidget? {
        didSet {
            textLabel?.text = viewModel?.title
            imageView?.image = UIImage(named: viewModel?.iconName ?? "")
        }
    }
    
    func setModel(_ viewModel:AnyWidget) {
        self.viewModel = viewModel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
