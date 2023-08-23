//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI

struct RegistrationSelectButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                
                Spacer()
                
                Text("Please select")
                    .foregroundStyle(Color.secondary.opacity(0.5))
            }
            .padding()
            .border()
        }
    }
}

#Preview {
    RegistrationSelectButton(title: "Custom Avatar Color") {}
}
