//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI
import PhotosUI

struct RegistrationAvatarView: View {
    let title: String
    @Binding var image: Image?
    let color: Color?
    @Binding var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(
            selection: $selectedPhotoItem,
            matching: .any(of: [.images])
        ) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                
                Spacer()
                
                ZStack {
                    Rectangle()
                        .fill(color ?? .contentBackground)
                        .frame(width: 100, height: 100)
                    
                    VStack {
                        if let image {
                            image.resizable()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.placeholder)
                    .clipShape(Circle())
                }
            }
            .padding()
            .border()
        }
        .controlSize(.large)
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let image = try? await newItem?.loadTransferable(type: Image.self) {
                    self.image = image
                }
            }
        }
    }
}

#Preview {
    @State var selectedPhotoItem: PhotosPickerItem?
    @State var image: Image? = Image("avatar")
    
    return RegistrationAvatarView(title: "Avatar", image: $image, color: .contentBackground, selectedPhotoItem: $selectedPhotoItem)
}
