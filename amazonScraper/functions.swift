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
            let container: Element = try doc.getElementById("dp-container")!
            let titleElement: Element = try container.getElementById("productTitle")!
            guard let title = try? titleElement.text() else { return }
            let rating: Element = try doc.getElementById("acrPopover")!
            var ratingText = try rating.text()
            let imageElement: Element = try container.select("#imgTagWrapperId img").first()!
            let imgLink = try imageElement.attr("src")
            completion(.success((imgLink,ratingText,title)))
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
            let link = getImageUrl(links)
            completion(.success(link))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


private func loadImage(from url: URL) {
    
    
    getProductImage(url: url) { result in
        switch result {
        case .success(let imgUrl):
            print("Image URL: \(imgUrl)")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
   }
func getImageUrl(_ input: String)->String{
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
    
    guard let range = Range(matches[0].range, in: input) else { fatalError("Can not get range") }
    let url = input[range]
    
    return String(url).components(separatedBy: "&")[0]
}








