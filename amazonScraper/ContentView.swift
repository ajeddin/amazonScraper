//
//  ContentView.swift
//  amazonScraper
//
//  Created by Abdulaziz Jamaleddin on 1/26/24.
//
import SwiftUI
import UIKit
import SwiftSoup


struct ContentView: View {
    
    
    
    

    @State private var urlText: String = ""
    @State var isValidLink : Bool = false
    @State var imgUrl : String = ""
    @State var price : String = ""
    @State var title : String = ""
    var body: some View {
        
        VStack {
            TextField("Enter URL", text: $urlText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                if var urlLink = URL(string: urlText), UIApplication.shared.canOpenURL(urlLink) {
//                     imgUrl = getProductImage(url: urlLink)
                    getRealImage(url: URL(string:urlText)!) { result in
                        switch result {
                        case .success(let imgURL):
//                            print("Image URL:  \(imgURL)")
                            getProductImage(url: URL(string:imgURL)!) { result in
                                switch result {
                                case .success(let imgURL):
        //                            print("Image URL:  \(imgURL)")
                                    
                                    imgUrl = imgURL.0
                                    price = imgURL.1
                                    title = imgURL.2
                                    
                                case .failure(let error):
                                    print("Error: \(error)")
                                }
                            }
                            imgUrl = imgURL
                            
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                    

//                    urlLink = URL(string: "Empty") ?? URL(string: "Empty")!
                    isValidLink = true
                     
                } else {
                    Text("Invalid URL")
                        .foregroundColor(.red)
                }
    
    
            }) {
                   Text("Render Image")
                     .font(.caption)
                 }
            if (isValidLink){
                Text("\(price) \n \(title)")
                AsyncImage(url: URL(string: imgUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } else if phase.error != nil {
                                    Text("There was an error loading the image.")
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 200, height: 200)
                        }
            
            
                    }
            
        }
//        var imgUrl = getProductImage(url: urlLink!)
//        if (isValidLink){
//            AsyncImage(url: URL(string: imgURL)) { phase in
//                if let image = phase.image {
//                    image
//                        .resizable()
//                        .scaledToFit()
//                } else if phase.error != nil {
//                    Text("There was an error loading the image.")
//                } else {
//                    ProgressView()
//                }
//            }
//            .frame(width: 200, height: 200)
//        }
        
        
      
    }








#Preview {
    ContentView()
}


