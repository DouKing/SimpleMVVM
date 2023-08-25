//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit

struct SelectColorContentConfiguration {
    let title: String
}

extension SelectColorContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        SelectColorContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> SelectColorContentConfiguration {
        return self
    }
}

class SelectColorContentView: UIView, UIContentView {
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.introLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            self.introLabel.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.introLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.introLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        self.applyConfiguration(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConfiguration(_ config: UIContentConfiguration) {
        guard let config = config as? SelectColorContentConfiguration else { return }
        self.titleLabel.text = config.title
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfiguration(configuration)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.preferredFont(forTextStyle: .headline)
        this.textColor = .black
        return this
    }()
    
    lazy var introLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.text = "Please select"
        this.textAlignment = .right
        this.textColor = .gray.withAlphaComponent(0.5)
        return this
    }()
}
