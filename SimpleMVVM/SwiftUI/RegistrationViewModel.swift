//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/23.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation
import Observation
import Combine

@Observable final class RegistrationViewModel {
    var state = State()
    
    @ObservationIgnored
    private var bag: Set<AnyCancellable> = []
        
    func send(_ action: RegistrationViewModel.Action) {
        let effect = self.reduce(into: &self.state, action: action)
        
        switch effect.operation {
        case .none: break
        case .publisher: break
        case let .run(priority, task):
            Task(priority: priority) {
                let send = await Send { (action: Action) in
                    self.send(action)
                }
                await task(send)
            }
        }
    }
}

extension RegistrationViewModel {
    struct State {
        var firstName: String = ""
        var lastName: String = ""
        var phoneNumber: String = ""
        var email: String = ""
        
        var isSignUping: Bool = false
        
        var isSignUpEnable: Bool {
            !firstName.isEmpty &&
            !lastName.isEmpty  &&
            !phoneNumber.isEmpty &&
            !email.isEmpty
        }
        
        var avatarColor: (Float, Float, Float, Float)?
        var avatarImage: Data?
    }
    
    enum Action {
        case setAvatarColor((Float, Float, Float, Float))
        case setAvatarImage(Data)
        case signUp
        case signUpSuccess
    }
    
    @MainActor
    struct Send<Action>: Sendable {
        let send: @MainActor @Sendable (Action) -> Void
        
        init(send: @escaping @MainActor @Sendable (Action) -> Void) {
            self.send = send
        }
        
        func callAsFunction(_ action: Action) {
            guard !Task.isCancelled else { return }
            self.send(action)
        }
    }
    
    struct Effect<Action> {
        @usableFromInline
        enum Operation {
            case none
            case publisher(AnyPublisher<Action, Never>)
            case run(TaskPriority? = nil, @Sendable (_ send: Send<Action>) async -> Void)
        }
        
        @usableFromInline
        let operation: Operation
        
        @usableFromInline
        init(operation: Operation) {
            self.operation = operation
        }
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setAvatarColor(let color):
            state.avatarColor = color
            return Effect(operation: .none)
        case .setAvatarImage(let data):
            state.avatarImage = data
            return Effect(operation: .none)
        case .signUp:
            // 1. update state
            state.isSignUping = true
            
            // 2. effect
            return Effect(operation: .run { send in
                await Mock(
                    firstName: self.state.firstName,
                    lastName: self.state.lastName,
                    phoneNumber: self.state.phoneNumber,
                    email: self.state.email
                )
                .send()
                
                await send(.signUpSuccess)
            })
        case .signUpSuccess:
            state.isSignUping = false
            return Effect.init(operation: .none)
        }
    }
}
