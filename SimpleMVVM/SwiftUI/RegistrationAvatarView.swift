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
    let image: Image?
    let data: Data?
    let color: Color?
    @Binding var selectedPhotoItem: PhotosPickerItem?
    
    init(title: String, image: Image? = nil, data: Data? = nil, color: Color? = nil, selectedPhotoItem: Binding<PhotosPickerItem?>) {
        self.title = title
        self.image = image
        self.data = data
        self.color = color
        self._selectedPhotoItem = selectedPhotoItem
    }

    var body: some View {
        let _ = Self._printChanges()

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
                        if let data, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage).resizable()
                        } else if let image {
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
    }
}

#Preview {
    @State var selectedPhotoItem: PhotosPickerItem?
    @State var image: Image? = Image("avatar")
    
    return RegistrationAvatarView(title: "Avatar", image: image, color: .contentBackground, selectedPhotoItem: $selectedPhotoItem)
}
