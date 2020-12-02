//
//  LocationChooserView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/2/20.
//

import SwiftUI
import MapKit

struct LocationChooserView: View {
    var spacing: AppSpacing = AppSpacing()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.506900, longitude: -121.763223), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
    @GestureState var menuOffsetDrag: CGFloat = .zero
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region)
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                
                RestaurantChooserView(region: $region)
            }
        }
        .ignoresSafeArea()
    }
}

struct RestaurantChooserView: View {
    var spacing: AppSpacing = AppSpacing()
    @Binding var region: MKCoordinateRegion
    var body: some View {
        VStack {
            DragIndicatorView()
                .padding()
            ForEach(restaurants) { restaurant in
                HStack(alignment: .center) {
                    Image(restaurant.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 60)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(restaurant.name)
                        Text(restaurant.address)
                    }
                    .font(.system(size: 14))
                    
                    VStack(spacing: 20){
                        Text("\(restaurant.openingTime) - \(restaurant.closingTime)")
                            .font(.caption)
                            .foregroundColor(.green)
                        Spacer()
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width-UIScreen.main.bounds.width*0.10, height: 90)
                .background(Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)))
                .cornerRadius(7)
                .onTapGesture{
                    withAnimation(.spring()) {
                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: restaurant.coordinate.latitude, longitude: restaurant.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                    }
                }
            }
        }
        .padding()
        .frame(width: spacing.screenWidth)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct LocationChooserView_Previews: PreviewProvider {
    static var previews: some View {
        LocationChooserView()
    }
}



struct Restaurant: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let image: String
    let name: String
    let address: String
    let openingTime: String
    let closingTime: String
}

var restaurants: [Restaurant] = [
    Restaurant(coordinate: .init(latitude: 36.67086, longitude: -121.65594), image: "SazonLogo", name: "La Casa Del Sazon 2", address: "438 Salinas St, Salinas, CA", openingTime: "11", closingTime: "9pm"),
    Restaurant(coordinate: .init(latitude: 36.66314, longitude: -121.65870), image: "SazonLogo", name: "La Casa Del Sazon", address: "22 W Romie Ln, Salinas, CA", openingTime: "11", closingTime: "8pm"),
    Restaurant(coordinate: .init(latitude: 36.59892, longitude: -121.89333), image: "SazonExpressLogo", name: "Sazon Express", address: "431 Tyler St, Monterey, CA", openingTime: "4", closingTime: "9pm")
]
