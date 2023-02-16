//
//  NetworkManager.swift
//  MusicApp
//
//  Created by Dara Adekore on 2023-02-15.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let session:URLSession
    
    private init(session:URLSession = .shared){
        self.session = session
    }
    
    func request(url:URL, completion: @escaping (Result<Data,Error>) -> Void){
        session.dataTask(with: url){data, response, error in
            if let error = error{
                if let response = response{
                    print(response)
                }
                completion(.failure(error))
            } else if let data = data{
                if let response = response{
                    //print(response)
                }
                completion(.success(data))
            } else{
                if let response = response{
                    print(response)
                }
                completion(.failure(NSError(domain: "com.examples.network", code: 0,userInfo: nil)))
            }
        }.resume()
    }
    
    func multipleRequests(urls:[URL]) -> [Data]{
        let dispatchGroup = DispatchGroup()
        var dataList = [Data]()
        for url in urls {
            dispatchGroup.enter()
            request(url: url, completion: { result in
                switch result {
                case .success(let data):
                    // handle data
                    dataList.append(data)
                case .failure(let error):
                    // handle error
                    print(error)
                }
            })
            dispatchGroup.leave()
        }
        return dataList
    }
    
    func makeUrl(_ searchString:String) -> String{
        var defaultString = "https://itunes.apple.com/search?term="
        defaultString.append(searchString.replacingOccurrences(of: " ", with: "+"))
        return defaultString
    }
}
