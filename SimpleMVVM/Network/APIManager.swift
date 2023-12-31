//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation
import Combine

protocol APIManager {
    func send() async
}

protocol SignUpAPI {
    func signUp(firstName: String, lastName: String, email: String) -> AnyPublisher<Bool, Never>
}
