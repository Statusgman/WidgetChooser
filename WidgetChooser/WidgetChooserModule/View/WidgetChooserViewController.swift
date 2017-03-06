//
//  WidgetChooserViewController.swift
//  WidgetChooser
//
//  Created by Dudarenko Ilya on 15.12.16.
//  Copyright © 2016 DIO. All rights reserved.
//

import UIKit

class WidgetChooserViewController: UIViewController, WidgetChooserViewInput {
    
    // MARK: Outlets
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    fileprivate enum Sections: Int {
        case active     = 0
        case inactive   = 1
    }
    let sectionsCount = 2
    
    var eventHandler: WidgetChooserPresenter!
    var activeElements: [AnyWidget] = []
    var inactiveElements: [AnyWidget] = []
    var activeElementsTitle = "Active elements".localized()
    var inactiveElementsTitle = "Inactive elements".localized()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(WidgetChooserCell.self, forCellReuseIdentifier: WidgetChooserCell.defaultReuseIdentifier)
        setEditing(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(true, animated: true)
    }
    
    
    // MARK: - WidgetChooserViewInput
    
    func display(activeElements: [AnyWidget], inactiveElements: [AnyWidget]) {
        self.activeElements = activeElements
        self.inactiveElements = inactiveElements
    }
}

extension WidgetChooserViewController: UITableViewDataSource {
    
    // MARK: data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .active:
            return activeElements.count
        case .inactive:
            return inactiveElements.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Sections(rawValue: section)! {
        case .active:
            return activeElementsTitle
        case .inactive:
            return inactiveElementsTitle
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WidgetChooserCell.defaultReuseIdentifier) as? WidgetChooserCell {
            switch Sections(rawValue: indexPath.section)! {
                case .active:
                    cell.showsReorderControl = true
                    cell.setModel(activeElements[indexPath.row])
                case .inactive:
                    cell.showsReorderControl = false
                    cell.setModel(inactiveElements[indexPath.row])
            }
            return cell
        }
        assert(false)
        return UITableViewCell()
    }
    

    // MARK: editing
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section {
            if sourceIndexPath.section == Sections.active.rawValue {
                let element = activeElements.remove(at: sourceIndexPath.row)
                let indexToInsert = self.index(toInsert: element, in: inactiveElements)
                inactiveElements.insert(element, at: indexToInsert)
                tableView.reloadData()
                return
            }
            assert(false) // ячейки секции inactive не должны перетаскиваться
        } else {
            switch Sections(rawValue: sourceIndexPath.section)! {
            case .active:
                let element = activeElements.remove(at: sourceIndexPath.row)
                activeElements.insert(element, at: destinationIndexPath.row)
            case .inactive:
                let element = inactiveElements.remove(at: sourceIndexPath.row)
                inactiveElements.insert(element, at: destinationIndexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        defer {
            tableView.endUpdates()
        }
        
        switch editingStyle {
        case .insert:
            let element = self.element(forRowAt: indexPath)!

            let indexToDelete = inactiveElements.index(of: element)!
            tableView.deleteRows(at: [indexPath], with: .automatic)

            let index = activeElements.count
            let section = Sections.active.rawValue
            let indexToInsert = IndexPath(row: index, section: section)
            tableView.insertRows(at: [indexToInsert], with: .bottom)
            activeElements.insert(element, at: index)
            
            inactiveElements.remove(at: indexToDelete)
            
        case .delete:
            let element = self.element(forRowAt: indexPath)!
            let indexToDelete = activeElements.index(of: element)!
            tableView.deleteRows(at: [indexPath], with: .left)
            if let index = self.indexPath(toInsert: indexPath) {
                let indexToInsert = self.index(toInsert: element, in: inactiveElements)
                tableView.insertRows(at: [index], with: .top)
                inactiveElements.insert(element, at: indexToInsert)
            }
            activeElements.remove(at: indexToDelete)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch Sections(rawValue: indexPath.section)! {
        case .active:
            return true
        case .inactive:
            return false
        }
    }
}

extension WidgetChooserViewController: UITableViewDelegate {
    
    // MARK: editing
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch Sections(rawValue: indexPath.section)! {
        case .active:
            return .delete
        case .inactive:
            return .insert
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let inactiveSection = Sections.inactive.rawValue
        if proposedDestinationIndexPath.section == inactiveSection {
            if let indexPath = self.indexPath(toInsert: sourceIndexPath) {
                return indexPath
            }
            return IndexPath(row: tableView.numberOfRows(inSection: inactiveSection), section: inactiveSection)
        }
        return proposedDestinationIndexPath
    }
    
    // MARK: appearance
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete".localized()
    }
}

extension WidgetChooserViewController {
    
    func indexPath(toInsert fromIndex:IndexPath) -> IndexPath? {
        var elements = activeElements
        var toSection = Sections.active.rawValue
        if fromIndex.section == Sections.active.rawValue {
            elements = inactiveElements
            toSection = Sections.inactive.rawValue
        }
    
        if let element = self.element(forRowAt: fromIndex) {
            let index = self.index(toInsert: element, in: elements)
            return IndexPath(row: index, section: toSection)
        } else {
            return nil
        }
    }
    
    func element(forRowAt indexPath: IndexPath) -> AnyWidget? {
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! WidgetChooserCell
        return cell.viewModel
    }
    
    func index(toInsert element:AnyWidget, in array:[AnyWidget]) -> Int {
        var elements = array
        elements.append(element)
        elements = elements.sorted { $0.title < $1.title }

        return elements.index(of: element)!
    }
}
