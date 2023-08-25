//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)

import UIKit
import Combine

extension CombineWrapper where Base: UITextField {
    public var text: AnyPublisher<String?, Never> {
		return controlEvent([.allEditingEvents, .valueChanged]).map({ $0.text }).eraseToAnyPublisher()
	}
}

#endif
