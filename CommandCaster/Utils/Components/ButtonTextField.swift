//
//  ButtonTextField.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 19/09/2024.
//

import SwiftUICore
import SwiftUI

struct ButtonTextField: View {
    private let title: String
    private var fontSize: CGFloat
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let offsetFocusedLabel: CGFloat
    private let scaleFocusedLabel: CGFloat
    private let floatingLabel: Bool
    private let systemName: String
    
    @FocusState private var isFocused: Bool
    @Binding private var text: String
  
    private let action: (() -> Void)
    
    init(_ title: String, text: Binding<String>, font: Font = .body, floatingLabel: Bool = false, systemName: String, _ action: @escaping () -> Void) {
        self.title = title
        self._text = text
        self.action = action
        self.systemName = systemName
        
        switch font {
        case .title:
            fontSize = 22
            scaleFocusedLabel = 0.6
            offsetFocusedLabel = -39.6
        default:
            fontSize = 12.5
            scaleFocusedLabel = 0.8
            offsetFocusedLabel = -20
        }
        
        height = fontSize + 8
        cornerRadius =  0.3 * height
        self.floatingLabel = floatingLabel
    }
    
    var body: some View {
        let focusedOrNotEmpty = isFocused || !text.isEmpty
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                if floatingLabel {
                    Text(title)
                        .font(.system(size: fontSize))
                        .foregroundColor(isFocused ? .accentColor :  Color(.placeholderTextColor))
                        .padding(.horizontal, 10)
                        .offset(y: focusedOrNotEmpty ? offsetFocusedLabel : 0)
                        .scaleEffect(focusedOrNotEmpty ? scaleFocusedLabel : 1, anchor: .leading)
                }
                
                TextField(floatingLabel ? "" : title, text: $text)
                    .font(.system(size: fontSize))
                    .focused($isFocused)
                    .frame(height: height)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 11)
                    .background(Color(.tertiarySystemFill))
                    .clipShape(
                        RoundedCornersShape(cornerRadius: cornerRadius, corners: [.topLeft, .bottomLeft])
                    )
                    .overlay(
                        RoundedCornersShape(cornerRadius: cornerRadius, corners: [.topLeft, .bottomLeft])
                            .stroke(isFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                    )
                    .onSubmit {
                        action()
                    }
            }
            .animation(.default, value: focusedOrNotEmpty)
            
            Image(systemName: systemName)
                .padding()
                .frame(width: height, height: height)
                .background()
                .onTapGesture {
                    action()
                }
                .clipShape(
                    RoundedCornersShape(cornerRadius: cornerRadius, corners: [.topRight, .bottomRight])
                )
        }
        .padding(.top, floatingLabel ? height * scaleFocusedLabel : 0)
    }
}
