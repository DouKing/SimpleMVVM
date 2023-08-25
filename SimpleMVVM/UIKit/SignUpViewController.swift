//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/25.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit
import SwiftUI
import PhotosUI
import Combine

class SignUpViewController: UIViewController {
    private typealias SectionType = Int
    private enum ItemType: Int, CaseIterable {
        case avatar
        case firstName
        case lastName
        case phoneNumber
        case email
        case selectColor
    }
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SignUp"
        self.view.backgroundColor = self.tableView.backgroundColor
        self.view.addSubview(self.tableView)
        self.footerView.addSubview(self.signUpButton)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.signUpButton.centerXAnchor.constraint(equalTo: self.footerView.centerXAnchor),
            self.signUpButton.centerYAnchor.constraint(equalTo: self.footerView.centerYAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 60),
            self.signUpButton.leadingAnchor.constraint(equalTo: self.footerView.leadingAnchor, constant: 20),
        ])
        self.tableView.tableFooterView = self.footerView

        self.configureDataSource()
    }
    
    // MARK: - Property
    
    private var dataSource: DataSource!
    private var selectColorCancel: Cancellable?
    private var bag: Set<AnyCancellable> = []
    private let viewModel: SignUpViewModel
    
    private let updateImage = PassthroughSubject<Data?, Never>()
    private let updateColor = PassthroughSubject<(CGFloat, CGFloat, CGFloat, CGFloat)?, Never>()

    private lazy var tableView: UITableView = {
        let this = UITableView(frame: .zero, style: .insetGrouped)
        this.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.id)
        this.translatesAutoresizingMaskIntoConstraints = false
        this.delegate = self
        this.separatorStyle = .none
        this.sectionHeaderHeight = 5
        this.sectionFooterHeight = 5
        return this
    }()
    
    private lazy var signUpButton: UIButton = {
        let this = UIButton(type: .custom)
        this.translatesAutoresizingMaskIntoConstraints = false
        this.backgroundColor = .white
        this.setTitle("Sign Up", for: .normal)
        this.setTitleColor(.black, for: .normal)
        this.setTitleColor(.gray, for: .disabled)
        this.layer.borderColor = UIColor.black.cgColor
        this.layer.borderWidth = 1
        this.layer.cornerRadius = 15
        return this
    }()
    
    private lazy var footerView: UIView = {
        let this = UIView(frame: CGRect(origin: .zero, size: .init(width: 0, height: 100)))
        return this
    }()
    
    private var avatar = AvatarContentConfiguration(title: "Avatar")
    private var selectColor = SelectColorContentConfiguration(title: "Custom Avatar Color")
    private var firstName = TextFieldContentConfiguration(title: "FirstName", value: "")
    private var lastName = TextFieldContentConfiguration(title: "LastName", value: "")
    private var phoneNumber = TextFieldContentConfiguration(title: "PhoneNumber", value: "")
    private var email = TextFieldContentConfiguration(title: "Email", value: "")
}

extension SignUpViewController {
    private func configureDataSource() {
        self.dataSource = DataSource(tableView: self.tableView) {
            [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard let self else { return nil }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.id, for: indexPath)
            cell.contentConfiguration = self.makeConfig(for: cell, item: item)
            cell.selectionStyle = .none
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        ItemType.allCases.forEach { item in
            snapshot.appendSections([item.rawValue])
            snapshot.appendItems([item])
        }
        self.dataSource.apply(snapshot)
        
        self.bindData()
    }
    
    private func bindData() {
        self.viewModel.isSignUpEnable
            .assign(to: \.isEnabled, on: self.signUpButton)
            .store(in: &self.bag)
        
        self.viewModel.isSignUping
            .sink { [weak self] loading in
                self?.signUpButton.setTitle(loading ? "Loading..." : "SignUp", for: .normal)
            }
            .store(in: &self.bag)
        
        self.viewModel.isSignUpFinish
            .sink {
                print("isSignUpFinish", $0)
            }
            .store(in: &self.bag)
        
        self.viewModel.updateAvatar
            .sink { [weak self] (data, components) in
                guard let self else { return }
                if let (r, g, b, a) = components {
                    self.avatar.color = UIColor(red: r, green: g, blue: b, alpha: a)
                }
                if let data {
                    self.avatar.image = UIImage(data: data)
                }
                var snapshot = self.dataSource.snapshot()
                snapshot.reloadItems([.avatar])
                self.dataSource.apply(snapshot)
            }
            .store(in: &self.bag)
        
        self.viewModel.userInput(
            firstName: self.firstName.onChange.eraseToAnyPublisher(),
            lastName: self.lastName.onChange.eraseToAnyPublisher(),
            phoneNumber: self.phoneNumber.onChange.eraseToAnyPublisher(),
            email: self.email.onChange.eraseToAnyPublisher(),
            image: self.updateImage.eraseToAnyPublisher(),
            color: self.updateColor.eraseToAnyPublisher(),
            tap: self.signUpButton.combine.controlEvent(.touchUpInside).map { _ in () }.eraseToAnyPublisher()
        )
        
        self.updateColor.send(nil)
        self.updateImage.send(nil)
    }
    
    private func makeConfig(for cell: UITableViewCell, item: ItemType) -> UIContentConfiguration {
        switch item {
        case .avatar:
            return self.avatar
        case .selectColor:
            return self.selectColor
        case .firstName:
            return self.firstName
        case .lastName:
            return self.lastName
        case .phoneNumber:
            return self.phoneNumber
        case .email:
            return self.email
        }
    }
}

// MARK: - Action

extension SignUpViewController {
    private func changeAvatarSurroundingColor() {
        let picker = UIColorPickerViewController()
        if let (r, g, b, a) = self.viewModel.avatarColor {
            picker.selectedColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
        } else {
            picker.selectedColor = UIColor(resource: .contentBackground)
        }
        
        self.selectColorCancel = picker.publisher(for: \.selectedColor)
            .map {
                if let components = $0.cgColor.components {
                    return (components[0], components[1], components[2], components[3])
                } else {
                    return nil
                }
            }
            .bind(to: self.updateColor)
        
        self.present(picker, animated: true, completion: nil)
    }
    
    private func changeAvatarImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        let nav = UINavigationController(rootViewController: picker)
        nav.isNavigationBarHidden = true
        self.present(nav, animated: true)
    }
}

extension SignUpViewController {
    private class DataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
    }
}

extension SignUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .avatar:
            self.changeAvatarImage()
        case .selectColor:
            self.changeAvatarSurroundingColor()
        default: break
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension SignUpViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        defer {
            self.dismiss(animated: true, completion: nil)
        }
        
        guard let itemProvider = results.first?.itemProvider else {
            return
        }
        
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        _ = itemProvider.loadDataRepresentation(for: UTType.image) { data, error in
            DispatchQueue.main.async {
                guard let data else { return }
                self.updateImage.send(data)
            }
        }
    }
}
