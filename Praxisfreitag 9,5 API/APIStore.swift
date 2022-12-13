//
//  APIStore.swift
//  Praxisfreitag 9,5 API
//
//  Created by Michael Hornung on 13.12.22.
//

import Foundation
import UIKit


// MARK: Response
struct Response : Codable {
    let products: [Product]
}

// MARK: Product
struct Product : Codable {
    let product: String
    let description: String
    let price: String
    let imageURL: String
}

// MARK: API Client
struct APIClient {
    
    // MARK: Download Product Info
    func downloadProductInfo(completion: @escaping(Response) -> Void) {
        
        let urlData = "https://public.syntax-institut.de/apps/batch1/AppleStore/data.json"
        
        
        let url = URL(string: urlData)
        guard url != nil else {return}
        
       
        let session = URLSession.shared
 
      
        let dataTask = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder()
                        
            do {
               
                let response = try decoder.decode(Response.self, from: data)
                
               
                completion(response)
                
            } catch{
                
                print("An error occured \(error)")
            }
        })
        
        dataTask.resume()
    }
    
    // MARK: Download Image
    func downloadImage(imageUrl: URL, completion: @escaping(UIImage) -> Void) {
        
        
        let session = URLSession.shared
        
        
        let downloadTask = session.downloadTask(with: imageUrl) { localURL, urlResponse, error in
            
            let image = UIImage(data: try! Data(contentsOf: localURL!))!
            completion(image)
        }
        
        downloadTask.resume()
    }
}
