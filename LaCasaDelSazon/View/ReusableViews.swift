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

struct ReusableViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RegularButtonView(symbolImage: "applelogo", text: "Continue with apple", textColor: .black, buttonColor: .red) {
                
            }
            RegularButtonView(image: Image("google"), text: "Continue with google", textColor: .white, buttonColor: .blue) {
                
            }
        }
    }
}
