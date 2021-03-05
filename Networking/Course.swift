//
//  Course.swift
//  Networking
//
//  Created by Sergei Isaikin on 05.03.2021.
//

import Foundation

struct Course: Decodable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
