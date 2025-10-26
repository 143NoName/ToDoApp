//
//  NetworkDervice.swift
//  ToDosTZ
//
//  Created by user on 7.10.25.
//

import Combine
import Foundation
import SwiftUI

@Observable
class NetworkService {
    
    static let shared = NetworkService()
    
    let persistenceController = PersistenceController.shared
        
    func getToDos(limit: Int ,complition: @escaping (Result<[ToDoModel], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/todos?_limit=\(limit)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                print(error)
                complition(.failure(error))
            } else {
                guard let httpresponse = response as? HTTPURLResponse,
                        (200...299).contains(httpresponse.statusCode) else {
                    print("Код ошибки: ")
                    return
                }
                if let data {
                    do {
                        let finalData = try JSONDecoder().decode([ToDoModel].self, from: data)
                        complition(.success(finalData))
                    } catch {
                        complition(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func postNewToDo(_ newToDo: ToDos, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/todos/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let firstData = newToDo.toCodableModel()
            let data = try JSONEncoder().encode(firstData)
            request.httpBody = data
        } catch {
            print("Проблема с кодированием данных")
        }
            
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                print("Проблема с загрузкой данных: \(error)")
                completion(.failure(error))
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { return }
                if let _ = data {
                    completion(.success(true))
                }
            }
        }
        task.resume()
    }
    
    
    func putToDo(_ body: ToDos, _ id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//   func putToDo(_ body: ToDoModel, _ id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/todos/\(id)") else { return }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = body.toCodableModel()
            let finalData = try JSONEncoder().encode(data)
//            print(String(data: finalData, encoding: .utf8)!)
            request.httpBody = finalData
            
        } catch {
            print("Проблема с кодированием данных")
        }
            
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                print("Проблема с загрузкой данных: \(error)")
                completion(.failure(error))
            } else {
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print(response.debugDescription)
                    return
                }
                if let _ = data {
                    completion(.success(true))
                }
            }
        }
        task.resume()
    }
    
    func deleteToDo(_ id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/todos/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error {
                    print("Проблема с загрузкой данных: \(error)")
                    completion(.failure(error))
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print(response!)
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                if let _ = data {
                    print("данные удалены")
                    completion(.success(true))
                }
                print("Тут ошибка")
                completion(.failure(URLError(.badServerResponse)))
            }
        }
        task.resume()
    }
}
