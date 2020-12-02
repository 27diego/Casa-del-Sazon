//
//  ReusableViews.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/1/20.
//

import SwiftUI

struct RegularButtonView: View {
    var spacing = AppSpacing()
    
    var image: Image?
    var symbolImage: String?
    var text: String
    var textColor: Color
    var buttonColor: Color
    var action: () -> Void
    
    init(text: String, textColor: Color, buttonColor: Color, action: @escaping () -> Void) {
        self.text = text
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.action = action
    }
    
    init(symbolImage: String, text: String, textColor: Color, buttonColor: Color, action: @escaping () -> Void) {
        self.symbolImage = symbolImage
        self.text = text
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.action = action
    }
    
    init(image: Image, text: String, textColor: Color, buttonColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.text = text
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack(spacing: 15) {
                if let symbol = symbolImage {
                    Image(systemName: symbol)
                }
                if let uiImage = image {
                    uiImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
                Text(text)
            }
            .foregroundColor(textColor)
            .padding()
            .frame(width: spacing.screenWidth * 0.9)
            .background(buttonColor)
            .cornerRadius(7)
        })
    }
}

struct CustomTextFieldView: View {
    var spacing: AppSpacing = AppSpacing()
    @Binding var content: String
    var placeholder: String
    var type: FieldType
    var width: CGFloat = 0
    
    init(content: Binding<String>, placeholder: String, type: FieldType, width: CGFloat) {
        self._content = content
        self.placeholder = placeholder
        self.type = type
        self.width = width
    }
    
    init(content: Binding<String>, placeholder: String, type: FieldType) {
        self._content = content
        self.placeholder = placeholder
        self.type = type
    }
    
    var body: some View {
        if type == .nonSecure{
            TextField(placeholder, text: $content)
                .padding()
                .background(Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)).opacity(0.40))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black.opacity(0.6)))
                .frame(width: width == 0 ? spacing.screenWidth * 0.9 : width)
            
        }
        else if type == .secure {
            SecureField(placeholder, text: $content)
                .padding()
                .background(Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)).opacity(0.40))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black.opacity(0.6)))
                .frame(width: width == 0 ? spacing.screenWidth * 0.9 : width)
        }
        
    }
}

struct ReusableViews_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(content: .constant(""), placeholder: "email", type: .secure)
    }
}
