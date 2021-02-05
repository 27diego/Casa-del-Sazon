//
//  NavigationView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI

struct NotificationBanner: View {
    var text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 60)
            .foregroundColor(Color(#colorLiteral(red: 0.09019607843, green: 0.1137254902, blue: 0.1333333333, alpha: 1)).opacity(0.9))
            .overlay(
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 23, height:23)
                        .foregroundColor(.white)
                    Spacer()
                        .frame(width: 13)
                    Text(text)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            )
            .padding([.leading, .trailing])
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner(text: "To many requests, please try again later")
    }
}
