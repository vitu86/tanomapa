//
//  NetworkHelper.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 05/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    enum Answer {
        case Success
        case NoInternet
        case Fail
    }
    
    // MARK: STATIC OBJECT REFERENCE
    static let sharedInstance:NetworkHelper = NetworkHelper()
    
    // MARK: Private properties
    private var session:PostSession?
    
    // private init for override purpose
    private init() {
    }
    
    func login(email:String, password:String, onCompletion: @escaping (Answer) -> Void ) {
        let request = NSMutableURLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onCompletion(Answer.NoInternet)
                }
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let sessionData = try decoder.decode(PostSession.self, from: newData!)
                if sessionData.account == nil || sessionData.session == nil {
                    DispatchQueue.main.async {
                        onCompletion(Answer.Fail)
                    }
                } else {
                    self.session = sessionData
                    DispatchQueue.main.async {
                        onCompletion(Answer.Success)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    onCompletion(Answer.Fail)
                }
            }
        }
        task.resume()

    }
}
