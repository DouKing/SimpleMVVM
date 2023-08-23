//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI
import PhotosUI

struct RegistrationView: View {
    // TODO: Move to view model
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    
    @State private var avatarColor: Color = .contentBackground
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    RegistrationAvatarView(
                        title: "Avatar",
                        image: $selectedImage,
                        color: avatarColor,
                        selectedPhotoItem: $selectedPhotoItem
                    )
                    
                    RegistrationInputView(title: "First Name", text: $firstName)
                    RegistrationInputView(title: "Last Name", text: $lastName)
                    RegistrationInputView(title: "Phone Number", text: $phoneNumber)
                    RegistrationInputView(title: "Email", text: $email)
                    
                    RegistrationSelectButton(title: "Custom Avatar Color") {
                        UIColorWellHelper.helper.execute?()
                    }
                    .background(
                        ColorPicker("Set the avatar color", selection: $avatarColor)
                            .labelsHidden()
                            .opacity(0)
                    )
                    
                    Button("Sign Up") {
                        Task {
                            await Mock(
                                firstName: firstName,
                                lastName: lastName,
                                phoneNumber: phoneNumber,
                                email: email
                            )
                            .send()
                        }
                    }
                    .foregroundStyle(Color.primary)
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
