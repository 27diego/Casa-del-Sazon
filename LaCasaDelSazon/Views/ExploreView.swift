//
//  ExploreView.swift
//  LaCasaDelSazon
//
//  Created by Developer on 2/4/21.
//

import SwiftUI
import CoreData

struct ExploreView: View {
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack {
                ForEach(categories, id: \.self) { category in
                    Text(category.category)
                }
            }
        }
    }
}

//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
