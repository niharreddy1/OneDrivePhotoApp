//
//  CleanUpViewController.swift
//  OneDrivePhotoApp
//
//  Created by Nihar Reddy on 10/29/21.
//

import UIKit
import Photos

class CleanUpViewController: UIViewController {
    
    private let spinner = SpinnerViewController()
    
    // Deletes local PHAssets if and only if they are present in OneDrive aldready
    func cleanUpSpace(fetchResults : PHFetchResult<PHAsset>) {
        
        let assetCreationDate = creationDateFormatting()
        let assetsToDelete : NSMutableArray = []
        let cameraRoll = fetchResults
        let group = DispatchGroup()
        
        for i in 0..<cameraRoll.count{
            let assetName = assetCreationDate.string(from: (cameraRoll[i].creationDate)!) // if the for loop went up do count would we need to force unwrap
            
            //Search for an asset with the same name in user's OneDrive
            group.enter()
            GraphManager.instance.searchForPHAssestInOneDrive(fileName: assetName) {(data: Data?, error: Error?) in DispatchQueue.main.async {
                self.spinner.start(container: self)
                   guard let assetData = data, error == nil else {
                       return
                   }
                   do{
                       // Decode response
                       let result = try JSONDecoder().decode(Root.self, from: assetData)
                       
                       // if the value is not empty then that means the PHAsset has been uploaded to OneDrive
                       if !(result.value.isEmpty) {
                           if (assetName == result.value[0].name.prefix(18)) {
                               assetsToDelete.add(cameraRoll[i])
                           }
                       }
                   }
                   catch {
                       print("Error in JSON parsing and matching PHAsset file Name")
                   }
               }
                group.leave()
            }
        }
        
        group.notify(queue: .main){
            self.spinner.stop()
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(assetsToDelete)
                // once this change request is finished stop all processes
            })
        }
        
    }
    
    
    
    @IBAction func triggerCleanUpSpace() {
        // Check if there are any assets in the photo library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // Request read-write access to the user's photo library.
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    // The user authorized this app to access Photos data.
                    // Fetch the cameraRoll
                    let fetchResults = getPHAssests()
                    // Clean the cameraRoll
                    self.cleanUpSpace(fetchResults: fetchResults)
    //            case .denied:
                    // The user explicitly denied this app's access.
    //            case .limited:
                    // The user authorized this app for limited Photos access.
    //            case .notDetermined:
    ////                <#code#>
    //            case .restricted:
    ////                <#code#>
                @unknown default:
                    fatalError()
                }
            }
        }
        else{
            print("there are no more photos")
        }
        
    }
    

}
