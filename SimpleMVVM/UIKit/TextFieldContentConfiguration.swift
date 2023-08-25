//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit
import Combine

struct TextFieldContentConfiguration {
    let title: String
    var value: String
    var keyboardType: UIKeyboardType = .default
    var onChange = PassthroughSubject<String, Never>()
}

extension TextFieldContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        TextFieldContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> TextFieldContentConfiguration {
        return self
    }
}

class TextFieldContentView: UIView, UIContentView {
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.textField)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            self.textField.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textField.heightAnchor.constraint(equalTo: self.titleLabel.heightAnchor, multiplier: 1),
        ])
        
        if let config = configuration as? TextFieldContentConfiguration {
            self.cancellable = self.textField.combine.text
                .map({ element in
                    return element ?? ""
                })
                .bind(to: config.onChange)
        }
        self.textField.sendActions(for: .valueChanged)
        self.applyConfiguration(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConfiguration(_ config: UIContentConfiguration) {
        guard let config = config as? TextFieldContentConfiguration else { return }
        self.textField.keyboardType = config.keyboardType
        self.textField.text = config.value
        self.titleLabel.text = config.title
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfiguration(configuration)
        }
    }
    
    private var cancellable: Cancellable?
    
    lazy var titleLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.preferredFont(forTextStyle: .headline)
        this.textColor = .black
        return this
    }()
    
    lazy var textField: UITextField = {
        let this = UITextField()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.placeholder = "Please input"
        this.textAlignment = .right
        return this
    }()
}
