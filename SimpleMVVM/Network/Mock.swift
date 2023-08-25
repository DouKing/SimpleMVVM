//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation
import Combine

struct Mock: APIManager {
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    
    func send() async {
        debugPrint("start ...")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        debugPrint("end ...")
    }
}

struct DefaultSignUpAPI: SignUpAPI {
    func signUp(
        firstName: String,
        lastName: String,
        email: String
    ) -> AnyPublisher<Bool, Never> {
        return Just(Bool.random())
            .delay(for: 2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
