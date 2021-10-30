//
//  ProcessMedia.swift
//  OneDrivePhotoApp
//
//  Created by Nihar Reddy on 10/29/21.
//

import Foundation
import Photos

// Function to get user's camera roll assets in order newest to oldest
func getPHAssests() -> PHFetchResult<PHAsset>{
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [
      NSSortDescriptor(
        key: "creationDate",
        ascending: false)
    ]
    
    return PHAsset.fetchAssets(with: allPhotosOptions)
}

// Get the creation date for the asset down to the millisecond
// Used to compare with the file name on OneDrive
func creationDateFormatting() -> DateFormatter{
    let df = DateFormatter()
    df.dateFormat = "yMMdd_HHmmssSSS"
    df.timeZone = TimeZone(abbreviation: "UTC")
    return df
}
