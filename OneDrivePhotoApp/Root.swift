//
//  Root.swift
//  OneDrivePhotoApp
//
//  Created by Nihar Reddy on 10/29/21.
//

import Foundation

// Structure of the inital JSON response from the Graph API
struct Root : Decodable{
    let value : [AssetData]
    
}
