//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/23.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    private enum SectionType {
        case main
    }
    private enum ItemType: CustomStringConvertible {
        case uikit
        case swiftui
        
        var description: String {
            switch self {
            case .uikit:
                return "uikit"
            case .swiftui:
                return "swiftui"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.configureDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: - Property
    
    private var dataSource: DataSource!
    
    private lazy var tableView: UITableView = {
        let this = UITableView(frame: .zero, style: .insetGrouped)
        this.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.id)
        this.translatesAutoresizingMaskIntoConstraints = false
        this.delegate = self
        return this
    }()
}

extension ViewController {
    private func configureDataSource() {
        self.dataSource = DataSource(tableView: self.tableView) {
            (tableView, indexPath, mountain) -> UITableViewCell? in            
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.id, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = mountain.description
            cell.contentConfiguration = content
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.uikit, .swiftui])
        self.dataSource.apply(snapshot)
    }
}

extension ViewController {
    private class DataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .swiftui:
            self.navigationController?.pushViewController(UIHostingController(rootView: RegistrationView()), animated: true)
        case .uikit:
            self.navigationController?
                .pushViewController(SignUpViewController(viewModel: DefaultSignUpViewModel()), animated: true)
        }
    }
}
