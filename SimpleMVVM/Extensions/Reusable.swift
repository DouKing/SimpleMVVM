//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/25.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit

protocol Reusable {
    static var id: String { get }
}

extension UITableViewCell: Reusable {
    static var id: String {
        String(describing: Self.self)
    }
}
