//
//  GameImageRequest.swift
//  SummInfo
//
//  Created by Alan Huynh on 11/1/16.
//  Copyright © 2016 Alan Huynh. All rights reserved.
//

import Foundation

struct ImageType {
    static let ProfileIcon = "profileicon"
    static let Champion = "champion"
    static let Item = "item"
}

class GameImageRequest: APIRequest {
    
    init(imageType: String, imageId: String) {
        let baseURL = APIServers[DataDragon]! + "/\(APIVersions.DataDragon)/img/" + imageType + "/\(imageId).png"
        
        super.init(baseURL: baseURL, path: nil, parameters: nil)
    }
}
