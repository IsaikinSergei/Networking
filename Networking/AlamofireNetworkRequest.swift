//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Sergei Isaikin on 10.03.2021.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseJSON { (response) in
            
            switch response.result {
            
            case.success(let value):
                print(value)
            case.failure(let error):
                print(error)
            }
        }
    }
}
