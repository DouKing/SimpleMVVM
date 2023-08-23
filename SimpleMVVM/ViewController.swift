//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/23.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let registrationVC = UIHostingController(rootView: RegistrationView())
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
}

