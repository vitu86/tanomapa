//
//  NetworkHelper.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 05/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//
// All requests are based on Udacity's online examples.

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
    private var locations:[StudentInformation] = []
    
    // MARK: Private constants
    private let sessionBaseUrl: String = "https://onthemap-api.udacity.com/v1/session"
    
    // MARK: Public properties
    var studentsInformation:[StudentInformation] {
        get {
            return locations
        }
    }
    
    // private init for override purpose
    private init() {
    }
    
    func login(email:String, password:String, onCompletion: @escaping (Answer) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: sessionBaseUrl)!)
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
    
    func logout(onCompletion: @escaping (Answer) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: sessionBaseUrl)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
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
                guard let sessionInside = sessionData.session,
                    nil != sessionInside.id,
                    nil != sessionInside.expiration
                    else {
                        DispatchQueue.main.async {
                            onCompletion(Answer.Fail)
                        }
                        return
                }
                DispatchQueue.main.async {
                    onCompletion(Answer.Success)
                }
            } catch {
                DispatchQueue.main.async {
                    onCompletion(Answer.Fail)
                }
            }
        }
        task.resume()
    }
    
    func loadLocations(onCompletion: @escaping (Answer) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-createdAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onCompletion(Answer.NoInternet)
                }
                return
            }
            
            do {
                guard let decodedJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any],
                    let infoArray = decodedJson["results"] as? [[String:Any]] else {
                        DispatchQueue.main.async {
                            onCompletion(Answer.Fail)
                        }
                        return
                }
                self.locations = []
                for item in infoArray {
                    if let newLocation = StudentInformation(json: item) {
                        self.locations.append(newLocation)
                    }
                }
                DispatchQueue.main.async {
                    onCompletion(Answer.Success)
                }
            } catch {
                DispatchQueue.main.async {
                    onCompletion(Answer.Fail)
                }
            }
        }
        task.resume()
    }
    
    func postLocation(_ location:DataToServer, onCompletion: @escaping (Answer) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(self.session!.account!.key!)\", \"firstName\": \"\(location.firstName!)\", \"lastName\": \"\(location.lastName!)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onCompletion(Answer.NoInternet)
                }
                return
            }
            DispatchQueue.main.async {
                onCompletion(Answer.Success)
            }
        }
        task.resume()
    }
    
//    func getUserData() {
//        let request = NSMutableURLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(self.session!.account!.key!)")!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print("User data: ", NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//        }
//        task.resume()
//    }
}
