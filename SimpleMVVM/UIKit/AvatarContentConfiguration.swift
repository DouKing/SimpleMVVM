//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit
import Combine

final class AvatarContentConfiguration {
    let title: String
    var color: UIColor
    var image: UIImage?
    
    init(title: String, color: UIColor = UIColor(resource: .contentBackground), image: UIImage? = nil) {
        self.title = title
        self.color = color
        self.image = image
    }
}

extension AvatarContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        AvatarContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> AvatarContentConfiguration {
        return self
    }
}

class AvatarContentView: UIView, UIContentView {
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.surroundingView)
        self.surroundingView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.surroundingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.surroundingView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.surroundingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.surroundingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.surroundingView.widthAnchor.constraint(equalToConstant: 100),
            self.surroundingView.heightAnchor.constraint(equalToConstant: 100),
            
            self.imageView.widthAnchor.constraint(equalToConstant: 80),
            self.imageView.heightAnchor.constraint(equalToConstant: 80),
            self.imageView.centerXAnchor.constraint(equalTo: self.surroundingView.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.surroundingView.centerYAnchor),
        ])
        
        self.applyConfiguration(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConfiguration(_ config: UIContentConfiguration) {
        guard let config = config as? AvatarContentConfiguration else { return }
        self.titleLabel.text = config.title
        self.imageView.image = config.image
        self.surroundingView.backgroundColor = config.color
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfiguration(configuration)
        }
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    lazy var titleLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.preferredFont(forTextStyle: .headline)
        this.textColor = .black
        return this
    }()
    
    lazy var surroundingView: UIView = {
        let this = UIView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.backgroundColor = UIColor(resource: .contentBackground)
        return this
    }()
    
    lazy var imageView: UIImageView = {
        let this = UIImageView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.backgroundColor = UIColor(resource: .placeholder)
        this.layer.cornerRadius = 40
        this.clipsToBounds = true
        return this
    }()
}
