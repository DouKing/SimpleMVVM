//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/25.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation
import Combine

protocol SignUpViewModelInput {
    func userInput(
        firstName: AnyPublisher<String, Never>,
        lastName: AnyPublisher<String, Never>,
        phoneNumber: AnyPublisher<String, Never>,
        email: AnyPublisher<String, Never>,
        image: AnyPublisher<Data?, Never>,
        color: AnyPublisher<(CGFloat, CGFloat, CGFloat, CGFloat)?, Never>,
        tap: AnyPublisher<(), Never>
    )
}

protocol SignUpViewModelOutput {
    var isSignUpEnable: AnyPublisher<Bool, Never> { get }
    var isSignUping: AnyPublisher<Bool, Never> { get }
    var isSignUpFinish: AnyPublisher<Bool, Never> { get }
    var updateAvatar: PassthroughSubject<(Data?, (CGFloat, CGFloat, CGFloat, CGFloat)?), Never> { get }
    
    var avatarColor: (CGFloat, CGFloat, CGFloat, CGFloat)? { get }
}

typealias SignUpViewModel = SignUpViewModelInput & SignUpViewModelOutput

final class DefaultSignUpViewModel: SignUpViewModel {
    private let isSignUpEnableSubject = PassthroughSubject<Bool, Never>()
    private let isSignUpingSubject = PassthroughSubject<Bool, Never>()
    private let isSignUpFinishSubject = PassthroughSubject<Bool, Never>()
    private var signUpEnableCancel: Cancellable?
    private var bag: Set<AnyCancellable> = []
    
    var updateAvatar = PassthroughSubject<(Data?, (CGFloat, CGFloat, CGFloat, CGFloat)?), Never>()
    var avatarColor: (CGFloat, CGFloat, CGFloat, CGFloat)?
    
    var isSignUpEnable: AnyPublisher<Bool, Never> {
        self.isSignUpEnableSubject.eraseToAnyPublisher()
    }
    
    var isSignUping: AnyPublisher<Bool, Never> {
        self.isSignUpingSubject.eraseToAnyPublisher()
    }
    
    var isSignUpFinish: AnyPublisher<Bool, Never> {
        self.isSignUpFinishSubject.eraseToAnyPublisher()
    }
}

extension DefaultSignUpViewModel {
    func userInput(
        firstName: AnyPublisher<String, Never>,
        lastName: AnyPublisher<String, Never>,
        phoneNumber: AnyPublisher<String, Never>,
        email: AnyPublisher<String, Never>,
        image: AnyPublisher<Data?, Never>,
        color: AnyPublisher<(CGFloat, CGFloat, CGFloat, CGFloat)?, Never>,
        tap: AnyPublisher<(), Never>
    ) {
        Publishers.CombineLatest4(firstName, lastName, phoneNumber, email)
            .map { value in
                let (firstName, lastName, phoneNumber, email) = value
                let isEnable = !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty && !email.isEmpty
                return isEnable
            }
            .bind(to: self.isSignUpEnableSubject)
            .store(in: &self.bag)
        
        let signUpInfo = Publishers.CombineLatest3(firstName, lastName, email)
        tap.combineLatest(signUpInfo)
            .flatMap { [weak self] (_, info) in
                self?.isSignUpingSubject.send(true)
                return DefaultSignUpAPI().signUp(firstName: info.0, lastName: info.1, email: info.2)
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isSignUpingSubject.send(false)
            })
            .bind(to: self.isSignUpFinishSubject)
            .store(in: &self.bag)
        
        image.combineLatest(color)
            .map { [weak self] value in
                self?.avatarColor = value.1
                return value
            }
            .bind(to: self.updateAvatar)
            .store(in: &self.bag)
    }
}
