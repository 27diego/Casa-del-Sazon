//
//  LocationChooserView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 12/2/20.
//

import SwiftUI
import MapKit

struct LocationChooserView: View {
    @ObservedObject var LocationChooser: LocationChooserViewModel
    @GestureState var dragMenu: CGFloat = .zero
    @FetchRequest(entity: Restaurant.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Restaurant.name, ascending: true) ]) var restaurants: FetchedResults<Restaurant>
    
    init(LocationChooser: LocationChooserViewModel) {
        self.LocationChooser = LocationChooser
    }
    
    var body: some View {
        ZStack {
            // TODO: Change this hard coded value to the actual user choosen value
            NavigationLink("", destination: NavigationLazyView(HomeView(restaurant: RestaurantViewModel(id: "Sazon431")).environmentObject(LocationChooser)), isActive: $LocationChooser.restaurantIsSelected)
            
            
            RestaurantMapView(restaurants: restaurants)
                .navigationTitle("")
                .navigationBarHidden(true)
                .ignoresSafeArea()
            
            RestaurantChooserView(restaurants: restaurants)
                .background(GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                if LocationChooser.restaurantIsSelected == false && restaurants.count > 0 {
                                    LocationChooser.menuSize = geo.size.height
                                }
                            }
                        }
                })
                .position(x: UIScreen.screenWidth/2, y: UIScreen.screenHeight+(LocationChooser.menuSize/3.2))
                .offset(y: LocationChooser.menuPosition + dragMenu)
                .gesture(
                    DragGesture()
                        .updating($dragMenu, body: { (value, state, _) in
                            state = value.translation.height
                            if LocationChooser.menuPosition + state < -(LocationChooser.menuSize-(LocationChooser.menuSize/3.2)) {
                                LocationChooser.menuPosition = -(LocationChooser.menuSize-(LocationChooser.menuSize/3.2))
                                state = value.translation.height*0.05
                            }
                        })
                        .onEnded { value in
                            if value.translation.height+LocationChooser.menuPosition < -75 {
                                LocationChooser.menuPosition = -(LocationChooser.menuSize-(LocationChooser.menuSize/3.2))
                                LocationChooser.expandedMenu = true
                            }
                            else {
                                LocationChooser.menuPosition = .zero
                                LocationChooser.expandedMenu = false
                            }
                        }
                )
                .animation(.spring())
        }
        .environmentObject(LocationChooser)
        .ignoresSafeArea()
    }
}

struct Dummy: View {
    var body: some View {
        Text("Some dummy text")
    }
}

struct RestaurantMapView: View {
    @EnvironmentObject var LocationChooser: LocationChooserViewModel
    var restaurants: FetchedResults<Restaurant>
    
    var body: some View {
        Map(coordinateRegion: $LocationChooser.region, interactionModes: .all, showsUserLocation: true, annotationItems: restaurants) { restaurant in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.address.latitude), longitude: CLLocationDegrees(restaurant.address.longitude))) {
                VStack {
                    Button("Go!"){
                        LocationChooser.confirmRestaurant()
                    }
                    .padding(10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .disabled(!(restaurant.identifier ?? "No Identifier" == LocationChooser.selectedRestaurant))
                    .opacity(restaurant.identifier ?? "No Identifier" == LocationChooser.selectedRestaurant ? 1 : 0)
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
                        LocationChooser.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.address.latitude), longitude: CLLocationDegrees(restaurant.address.longitude)), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                        LocationChooser.menuPosition = .zero
                        LocationChooser.selectedRestaurant = restaurant.identifier ?? ""
                    }
                }
            }
        }
    }
}


struct RestaurantChooserView: View {
    @EnvironmentObject var LocationChooser: LocationChooserViewModel
    var restaurants: FetchedResults<Restaurant>
    
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
                        Text(restaurant.address.formattedAddress)
                    }
                    .font(.system(size: 14))
                    
                    VStack(spacing: 20){
                        Text("\(restaurant.schedule.openingTime) - \(restaurant.schedule.closingTime)")
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
                        LocationChooser.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.address.latitude), longitude: CLLocationDegrees(restaurant.address.longitude)), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                        
                        LocationChooser.selectedRestaurant = restaurant.identifier ?? "No ID"
                        LocationChooser.menuPosition = .zero
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



