//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI
import PhotosUI

struct RegistrationView: View {
    @Bindable var viewModel = RegistrationViewModel()

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    RegistrationAvatarView(
                        title: "Avatar",
                        image: $viewModel.state.avatarImage,
                        color: viewModel.state.avatarColor,
                        selectedPhotoItem: $viewModel.state.selectedPhotoItem
                    )
                    
                    RegistrationInputView(title: "First Name", text: $viewModel.state.firstName)
                    RegistrationInputView(title: "Last Name", text: $viewModel.state.lastName)
                    RegistrationInputView(title: "Phone Number", text: $viewModel.state.phoneNumber)
                    RegistrationInputView(title: "Email", text: $viewModel.state.email)
                    
                    RegistrationSelectButton(title: "Custom Avatar Color") {
                        UIColorWellHelper.helper.execute?()
                    }
                    .background(
                        ColorPicker("Set the avatar color", selection: $viewModel.state.avatarColor)
                            .labelsHidden()
                            .opacity(0)
                    )
                    
                    Button(viewModel.state.isSignUping ? "Loading..." : "Sign Up") {
                        viewModel.send(.signUp)
                    }
                    .disabled(!viewModel.state.isSignUpEnable)
                    .foregroundStyle(viewModel.state.isSignUpEnable ? Color.primary : Color.gray)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .border()
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .padding(.horizontal)
        .navigationTitle("Registration")
    }
}

#Preview {
    RegistrationView()
}
