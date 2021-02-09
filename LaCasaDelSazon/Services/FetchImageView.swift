//
//  RemoteImage.swift
//  LaCasaDelSazon
//
//  Created by Developer on 11/25/20.
//

import SwiftUI

struct FetchImageView: View {
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    
    var body: some View{
        selectImage()
            .resizable()
    }
    
    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName:"multiply.circle")){
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }
    
    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
            
        default:
            if let image = UIImage(data: loader.data){
                return Image(uiImage: image)
            }
            else {
                return failure
            }
        }
    }
}


private class Loader: ObservableObject {
    @Published var data = Data()
    @Published var state = LoadState.loading

    init(url: String){
        guard let parsedURL = URL(string: url) else {
            fatalError("Invalid URL: \(url)")
        }
        
        URLSession.shared.dataTask(with: parsedURL) { data, response, error in
            if let data = data, data.count > 0 {
                DispatchQueue.main.async {
                    self.data = data
                    self.state = .success
                }
            }
            else {
                DispatchQueue.main.async {
                self.state = .failure
                }
            }
        }.resume()
    }
}


private enum LoadState {
    case loading, success, failure
}
