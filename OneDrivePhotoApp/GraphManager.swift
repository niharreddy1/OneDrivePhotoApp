//
//  GraphManager.swift
//  OneDrivePhotoApp
//
//  Created by Nihar Reddy on 10/29/21.
//

import Foundation
import MSGraphClientSDK
import MSGraphClientModels

class GraphManager {

    // Implement singleton pattern
    static let instance = GraphManager()

    private let client: MSHTTPClient?

    public var userTimeZone: String

    private init() {
        client = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance)
        userTimeZone = "UTC"
    }

    public func getMe(completion: @escaping(MSGraphUser?, Error?) -> Void) {
        // GET /me
        let select = "$select=displayName,mail,mailboxSettings,userPrincipalName"
        let meRequest = NSMutableURLRequest(url: URL(string: "\(MSGraphBaseURL)/me?\(select)")!)
        let meDataTask = MSURLSessionDataTask(request: meRequest, client: self.client, completion: {
            (data: Data?, response: URLResponse?, graphError: Error?) in
            guard let meData = data, graphError == nil else {
                completion(nil, graphError)
                return
            }

            do {
                // Deserialize response as a user
                let user = try MSGraphUser(data: meData)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        })

        // Execute the request
        meDataTask?.execute()
    }
    
    
    public func searchForPHAssestInOneDrive(fileName: String, completion: @escaping(Data?, Error?) -> Void){
            
        let assetRequest = NSMutableURLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me/drive/root/search(q='\(fileName)')?select=name")!)

            let assetDataTask = MSURLSessionDataTask(request: assetRequest, client: self.client, completion: {
                (data: Data?, response: URLResponse?, graphError: Error?) in
                guard let assetData = data, graphError == nil else {
                    completion(nil, graphError)
                    return
                }
                
                completion(assetData, nil)
            })
            assetDataTask?.execute()
        }
}
