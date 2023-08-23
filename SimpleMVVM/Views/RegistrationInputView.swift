//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI

struct RegistrationInputView: View {
    var title: String
    @Binding var text: String
    @FocusState private var focused: Bool
    
    var body: some View {
        let _ = Self._printChanges()

        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            TextField("Please input", text: $text)
                .multilineTextAlignment(.trailing)
                .focused($focused)
        }
        .padding()
        .border()
    }
}

#Preview {
    @State var content: String = ""
    return RegistrationInputView(title: "FirstName", text: $content)
}
