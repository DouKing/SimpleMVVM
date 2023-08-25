//===----------------------------------------------------------*- swift -*-===//
//
// Created by Yikai Wu on 2023/8/18.
// Copyright © 2023 Yikai Wu. All rights reserved.
//
//===----------------------------------------------------------------------===//

import SwiftUI

struct BorderRadiusModifier: ViewModifier {
    let borderCornerRadius: CGFloat
    let borderCorlor: Color
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: borderCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: borderCornerRadius)
                    .stroke(borderCorlor)
            )
    }
}

extension View {
    func border(cornerRadius: CGFloat = 10.0, color: Color = .black) -> some View {
        modifier(BorderRadiusModifier(borderCornerRadius: cornerRadius, borderCorlor: color))
    }
}
