//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI
import PhotosUI

struct RegistrationView: View {
    @Environment(\.self) var environment
    @Bindable var viewModel = RegistrationViewModel()

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var avatarColor: Color = .contentBackground

    var body: some View {
        let color = { () -> Color in
            if let components = viewModel.state.avatarColor {
                let (r, g, b, a) = components
                return Color(Color.Resolved(colorSpace: .sRGB, red: r, green: g, blue: b, opacity: a))
            }
            return Color.contentBackground
        }()

        VStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    RegistrationAvatarView(
                        title: "Avatar",
                        data: viewModel.state.avatarImage,
                        color: color,
                        selectedPhotoItem: $selectedPhotoItem
                    )
                    
                    RegistrationInputView(title: "First Name", text: $viewModel.state.firstName)
                    RegistrationInputView(title: "Last Name", text: $viewModel.state.lastName)
                    RegistrationInputView(title: "Phone Number", text: $viewModel.state.phoneNumber)
                    RegistrationInputView(title: "Email", text: $viewModel.state.email)
                    
                    RegistrationSelectButton(title: "Custom Avatar Color") {
                        UIColorWellHelper.helper.execute?()
                    }
                    .background(
                        ColorPicker("Set the avatar color", selection: $avatarColor)
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
        .onChange(of: selectedPhotoItem, initial: false) { _, newItem in
            Task {
                if let imageData = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.send(.setAvatarImage(imageData))
                }
            }
        }
        .onChange(of: avatarColor, initial: false) { oldValue, newValue in
            let resolved = newValue.resolve(in: environment)
            viewModel.send(.setAvatarColor((resolved.red, resolved.green, resolved.blue, resolved.opacity)))
        }
    }
}

#Preview {
    RegistrationView()
}
