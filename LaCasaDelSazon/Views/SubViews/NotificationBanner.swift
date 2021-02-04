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
            .foregroundColor(Color(#colorLiteral(red: 0.09019607843, green: 0.1137254902, blue: 0.1333333333, alpha: 1)))
            .overlay(
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 23, height:23)
                        .foregroundColor(.white)
                    Text(text)
                        .foregroundColor(.white)
                }
                .padding()
            )
            .padding([.leading, .trailing])
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner(text: "This user already exists, please use another user")
    }
}
