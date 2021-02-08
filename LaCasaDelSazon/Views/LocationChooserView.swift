//
//  LocationChooserView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/2/20.
//

import SwiftUI
import MapKit

struct LocationChooserView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.506900, longitude: -121.763223), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
    @State var selectedRestaurant: String = ""
    @GestureState var dragMenu: CGFloat = .zero
    @State var menuSize: CGFloat = .zero
    @State var menuPosition: CGFloat = .zero
    @State var expandedMenu: Bool = false {
        didSet {
            if expandedMenu == true {
                withAnimation {
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.506900, longitude: -121.763223), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
                    
                    selectedRestaurant = ""
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            RestaurantMapView(region: $region, selectedRestaurant: $selectedRestaurant,  menuPosition: $menuPosition)
                .navigationTitle("")
                .navigationBarHidden(true)
                .ignoresSafeArea()
            
            
            RestaurantChooserView(region: $region, menuPosition: $menuPosition, selectedRestaurant: $selectedRestaurant)
                .background(GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            menuSize = geo.size.height
                        }
                })
                .position(x: UIScreen.screenWidth/2, y: UIScreen.screenHeight+(menuSize/3.2))
                .offset(y: menuPosition+dragMenu)
                .gesture(
                    DragGesture()
                        .updating($dragMenu, body: { (value, state, _) in
                            state = value.translation.height
                            if menuPosition + state < -(menuSize-(menuSize/3.2)) {
                                menuPosition = -(menuSize-(menuSize/3.2))
                                state = value.translation.height*0.05
                            }
                        })
                        .onEnded { value in
                            if value.translation.height+menuPosition < -75 {
                                menuPosition = -(menuSize-(menuSize/3.2))
                                expandedMenu = true
                            }
                            else {
                                menuPosition = .zero
                                expandedMenu = false
                            }
                        }
                )
                .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.25))
            
        }
        .ignoresSafeArea()
    }
}

struct RestaurantMapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedRestaurant: String
    @Binding var menuPosition: CGFloat
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: restaurants) { restaurant in
            MapAnnotation(coordinate: restaurant.coordinate) {
                VStack {
                    NavigationLink(destination: HomeView().environmentObject(Restaurant(id: self.selectedRestaurant))) {
                        Text("Go!")
                            .padding(10)
                            .padding(.horizontal)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    .disabled(!(restaurant.id == selectedRestaurant))
                    .opacity(restaurant.id == selectedRestaurant ? 1 : 0)
                    .transition(.opacity)
                    .animation(.default)
                    
                    Image(restaurant.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 25/10)
                        )
                        .shadow(radius: 10)
                    
                    Text(restaurant.name)
                        .font(.caption)
                }
                .onTapGesture {
                    withAnimation(.linear) {
                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: restaurant.coordinate.latitude, longitude: restaurant.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                        menuPosition = .zero
                        selectedRestaurant = restaurant.id
                    }
                }
            }
        }
    }
}


struct RestaurantChooserView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var menuPosition: CGFloat
    @Binding var selectedRestaurant: String
    
    var body: some View {
        VStack {
            DragIndicatorView()
                .padding()
            Text("Choose your favorite spot")
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
                    withAnimation(.linear) {
                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: restaurant.coordinate.latitude, longitude: restaurant.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                        
                        selectedRestaurant = restaurant.id
                        menuPosition = .zero
                    }
                }
            }
            Spacer()
                .frame(height: 100)
        }
        .padding()
        .frame(width: UIScreen.screenWidth)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct LocationChooserView_Previews: PreviewProvider {
    static var previews: some View {
        LocationChooserView()
    }
}



struct RestaurantModel: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let image: String
    let name: String
    let address: String
    let openingTime: String
    let closingTime: String
}

var restaurants: [RestaurantModel] = [
    RestaurantModel(id: "Sazon438", coordinate: .init(latitude: 36.67086, longitude: -121.65594), image: "SazonLogo", name: "La Casa Del Sazon 2", address: "438 Salinas St, Salinas, CA", openingTime: "11", closingTime: "9pm"),
    RestaurantModel(id: "Sazon22", coordinate: .init(latitude: 36.66314, longitude: -121.65870), image: "SazonLogo", name: "La Casa Del Sazon", address: "22 W Romie Ln, Salinas, CA", openingTime: "11", closingTime: "8pm"),
    RestaurantModel(id: "Sazon431", coordinate: .init(latitude: 36.59892, longitude: -121.89333), image: "SazonExpressLogo", name: "Sazon Express", address: "431 Tyler St, Monterey, CA", openingTime: "4", closingTime: "9pm")
]
