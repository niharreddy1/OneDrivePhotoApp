//
//  AssetData.swift
//  OneDrivePhotoApp
//
//  Created by Nihar Reddy on 10/29/21.
//

import Foundation


// Structure used to decode the assets filename
// this name is compared to the creation date of the file in Photos App
struct AssetData : Decodable {
    let name: String
}
