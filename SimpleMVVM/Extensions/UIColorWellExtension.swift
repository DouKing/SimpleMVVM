//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit

// https://stackoverflow.com/questions/73382095/activate-color-picker-overlay-when-button-pressed-swiftui

extension UIColorWell {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // find a button and store handler with it in helper
        if let uiButton = self.subviews.first?.subviews.last as? UIButton {
            UIColorWellHelper.helper.execute = {
                uiButton.sendActions(for: .touchUpInside)
            }
        }
    }
}

class UIColorWellHelper {
    static var helper = UIColorWellHelper()
    
    var execute: (() -> Void)?
}
