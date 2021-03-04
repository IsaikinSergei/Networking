//
//  WebsiteDescription.swift
//  Networking
//
//  Created by Sergei Isaikin on 05.03.2021.
//

import Foundation

struct WebsiteDescription: Decodable {
    
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}

