//
//  ApiClient.swift
//  VBD_Sample_Task
//
//  Created by Rajeswari on 04/04/21.
//  Copyright © 2021 Rajeswari. All rights reserved.
//

import Foundation
import RealmSwift

public struct ApiClient {
    
    static func getDataFromServer(url: URL, completion: @escaping (_ success: Bool, _ data: [ListData]? )->()){
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("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", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([ListData].self, from: data)
                    completion(true, result)
                } catch {
                    print(error)
                }
            }
        }
        mData.resume()
    }
}
