//
//  ApiService.swift
//  RestApi_Movies
//
//  Created by Fazil P on 25/10/20.
//

import Foundation


class ApiService {
    
    private var dataTask: URLSessionTask?
    
    func gerPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=f11c73e69dee8030e83b60d1fa4e189e&language=en-US&page=1"
        
        guard let url = URL(string: popularMoviesURL) else { return }
        
//         Create URL Session work on the background
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
//             Handle Error
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
//                 Handle empty response
                print("Empty Response")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
//                 Handle empty Data
                
                print("Empty Data")
                return
            }
            
            do {
//                Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
