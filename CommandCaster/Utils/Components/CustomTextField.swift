//
//  CustomTextField.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 19/09/2024.
//

import SwiftUICore
import SwiftUI

struct CustomTextField: View {
    @Environment(\.colorScheme) var colorScheme
    
    private let title: String
    private var fontSize: CGFloat
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let offsetFocusedLabel: CGFloat
    private let scaleFocusedLabel: CGFloat
    private let floatingLabel: Bool
    private let secureField: Bool
    private let errorMessage: String
    
    @FocusState private var isFocused: Bool
    @Binding private var text: String
    @State private var isSecured = true
  
    init(_ title: String, text: Binding<String>, errorMessage: String = "", font: Font = .body, floatingLabel: Bool = false, secureField: Bool = false) {
        self.title = title
        self._text = text
        self.errorMessage = errorMessage
        
        switch font {
        case .title:
            fontSize = 22
            scaleFocusedLabel = 0.6
            offsetFocusedLabel = -39.6
        default:
            fontSize = 12.5
            scaleFocusedLabel = 1
            offsetFocusedLabel = -20
        }
        
        height = fontSize + 8
        cornerRadius =  0.3 * height
        self.floatingLabel = floatingLabel
        self.secureField = secureField
    }
    
    var body: some View {
        let focusedOrNotEmpty = isFocused || !text.isEmpty
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .leading) {
                if secureField && isSecured {
                    SecureField(floatingLabel ? "" : title, text: $text)
                        .font(.system(size: fontSize))
                        .focused($isFocused)
                        .frame(height: height)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.leading, 11)
                        .padding(.trailing, 40)
                        .background(Color("TextFieldFill"))
                        .cornerRadius(cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(!isFocused ? errorMessage.isEmpty ? .clear : .red : .accentColor)
                        )
                } else {
                    TextField(floatingLabel ? "" : title, text: $text)
                        .font(.system(size: fontSize))
                        .focused($isFocused)
                        .frame(height: height)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 11)
                        .background(Color("TextFieldFill"))
                        .cornerRadius(cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(!isFocused ? errorMessage.isEmpty ? .clear : .red : .accentColor)
                        )
                }
                
                if floatingLabel {
                    Text(title)
                        .font(.system(size: fontSize))
                        .foregroundColor(!isFocused ? errorMessage.isEmpty ? Color("TextFieldLabel") : .red : .accentColor)
                        .padding(.horizontal, 10)
                        .offset(y: focusedOrNotEmpty ? offsetFocusedLabel : 0)
                        .scaleEffect(focusedOrNotEmpty ? scaleFocusedLabel : 1, anchor: .leading)
                        .allowsHitTesting(false)
                }
                
                if secureField {
                    Image(systemName: isSecured ? "eye" : "eye.slash")
                        .foregroundColor(Color("TextFieldLabel"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 11)
                        .onTapGesture {
                            isSecured.toggle()
                        }
                }
            }
            .padding(.top, floatingLabel ? fontSize : 0)
            .animation(.default, value: focusedOrNotEmpty)
            
            Text(errorMessage.isEmpty ? "" : errorMessage)
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}
