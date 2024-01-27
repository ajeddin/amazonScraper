//
//  functions.swift
//  amazonScraper
//
//  Created by Abdulaziz Jamaleddin on 1/26/24.
//

import Foundation
import SwiftSoup

func getProductImage(url: URL, completion: @escaping (Result<(String,String,String), Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data, let html = String(data: data, encoding: .utf8) else {
            completion(.failure(NSError(domain: "InvalidData", code: 0, userInfo: nil)))
            return
        }
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
//            dp-container
            let container: Element = try doc.getElementById("dp-container")!
//            print(img2)
            let titleElement: Element = try container.getElementById("productTitle")!
            guard let title = try? titleElement.text() else { return }
//            print(title)
print(container)
//            let priceElement: Element = try container.getElementsByClass("a-offscreen").first()!
//            guard let price = try? priceElement.text() else { return }
            let container2: Element = try doc.getElementsByClass("a-box a-last").first()!
            let container3: Element = try container2.getElementsByClass("a-price-whole").first()!
            let container4: Element = try container2.getElementsByClass("a-price-fraction").first()!

print(container3)
            guard let priceWhole = try? container3.text() else { return }
            guard let pricefraction = try? container4.text() else { return }
            let price = priceWhole+pricefraction
            
//            if price.isEmpty{
//                let container2: Element = try doc.getElementsByClass("a-box a-last").first()!
//                let container3: Element = try doc.getElementsByClass("a-price-whole").first()!
//print(container3)
//                guard let price = try? container2.text() else { return }


//            }
            let imageElement: Element = try container.select("#imgTagWrapperId img").first()!
//            print(img1)
            print(price)

            let imgLink = try imageElement.attr("src")
//            print("src attribute value: \(srcValue)")
//            let img: Element = try img1.select("img[src$=.png]").first()!
//            print(img)
//            let imgOuterHtml: String = try img.outerHtml()
//            let imgUrl = getImageUrl(imgOuterHtml)
//            print(imgUrl)
            
            completion(.success((imgLink,price,title)))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

func getRealImage(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data, let html = String(data: data, encoding: .utf8) else {
            completion(.failure(NSError(domain: "InvalidData", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let linkOut: Element = try doc.select("link[rel=canonical]").first()!
            let links: String = try linkOut.outerHtml()
//            let link = getImageUrl(links)
            let link = getImageUrl(links)

            print(link)
            
            

            completion(.success(link))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


private func loadImage(from url: URL) {
    
//       let imgUrl = getProductImage(url: url)
    
    getProductImage(url: url) { result in
        switch result {
        case .success(let imgUrl):
            print("Image URL: \(imgUrl)")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
//    print("HERE")
   }
func getImageUrl(_ input: String)->String{
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
    
    guard let range = Range(matches[0].range, in: input) else { fatalError("Can not get range") }
    let url = input[range]
    
    return String(url).components(separatedBy: "&")[0]
}








