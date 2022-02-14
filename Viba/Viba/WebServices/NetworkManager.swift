//
//  NetworkManager.swift
//  Viba
//
//  Created by Satyam Sutapalli on 11/11/21.
//

import Foundation

class NetworkManager {
    private let baseUrl = "http://3.144.103.250:3000/api/v1/"
    private let kDomain = "com.viba.viba"
    private let kContentType = "Content-Type"
    private let kContentLength = "Content-Length"
    private let kApplicationJson = "application/json"
    private let kAccept = "Accept"
    private let kToken = "x-auth-token"

    private let session: URLSession!
    private var sessionConfiguration: URLSessionConfiguration!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // Create shared instance
    public static let shared = NetworkManager()

    // Initialize
    private init() {
        sessionConfiguration = .default
        sessionConfiguration.urlCache = nil
        sessionConfiguration.httpMaximumConnectionsPerHost = 1
        sessionConfiguration.timeoutIntervalForRequest = 120
        session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    }

//    func getResponse<T: Encodable, R: Decodable>(urlString: String, params: T?, completion connectionCompletion: @escaping (Result<R, Error>) -> Void) {
//        fetchResponse(urlString: urlString, params: params, methodType: .get, completion: connectionCompletion)
//    }
//
//    func postRequest<T: Encodable, R: Decodable>(urlString: NetworkPath, params: T?, completion connectionCompletion: @escaping (Result<R, Error>) -> Void) {
//        fetchResponse(urlString: urlString.rawValue, params: params, methodType: HTTPMethod.post, completion: connectionCompletion)
//    }

    func fetchResponse<Req: Encodable, Resp: Decodable>(urlString: String, params: Req?, methodType method: RequestMethod, completion connectionCompletion: @escaping (Result<Resp, Error>) -> Void) {
        if Reach().isNetworkReachable() == true {
            var apiRequest = URLRequest(url: URL(string: API.baseUrl.rawValue + urlString)!)
            apiRequest.setValue(kApplicationJson, forHTTPHeaderField: kAccept)

            if let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.token.value) {
                apiRequest.setValue(token, forHTTPHeaderField: kToken)
            }

            apiRequest.httpMethod = method.rawValue
            print("### Headers: ", apiRequest.allHTTPHeaderFields as Any)
            if method == .post || method == .put {
                apiRequest.setValue(kApplicationJson, forHTTPHeaderField: kContentType)
                if let requestInfo = params {
                    do {
                        let postData = try encoder.encode(requestInfo)
                        apiRequest.setValue("\(UInt(postData.count))", forHTTPHeaderField: kContentLength)
                        apiRequest.httpBody = postData
                        print("### Placing request with data: \(String(decoding: postData, as: UTF8.self))")
                    } catch {
                        let userInfo = self.createUserInfo("No Network availale", failureReason: "No Network")
                        let err = NSError(domain: self.kDomain, code: ErrorCode.noNetwork.rawValue, userInfo: userInfo)
                        connectionCompletion(.failure(err))
                    }
                }
            }

            print("### Placing request with url: \(String(describing: apiRequest.url?.absoluteString))")

            session.dataTask(with: apiRequest as URLRequest, completionHandler: { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, let rcvdData = data else {
                    let userInfo: [String: Any] = self.createUserInfo("Connectivity issue", failureReason: "No Network")
                    let err = NSError(domain: self.kDomain, code: ErrorCode.noNetwork.rawValue, userInfo: userInfo)
                    connectionCompletion(.failure(err))
                    return
                }

                print("### Received Response: \(String(decoding: rcvdData, as: UTF8.self))")
                if httpResponse.statusCode == 200 {
                    do {
                        let obj = try self.decoder.decode(Resp.self, from: rcvdData)
                        connectionCompletion(.success(obj))
                    } catch {
                        print(error.localizedDescription)
                        let userInfo: [String: Any] = self.createUserInfo("Failed to parse response", failureReason: "Parsing Failed")
                        let error = NSError(domain: self.kDomain, code: ErrorCode.parsingIssue.rawValue, userInfo: userInfo)
                        connectionCompletion(.failure(error))
                    }
                } else {
                    connectionCompletion(.failure(self.handleError(statusCode: httpResponse.statusCode, errorData: rcvdData)))
                }
            }).resume()
        } else {
            let userInfo: [String: Any] = self.createUserInfo("No Network availale", failureReason: "No Network")
            let error = NSError(domain: self.kDomain, code: ErrorCode.noNetwork.rawValue, userInfo: userInfo)
            connectionCompletion(.failure(error))
        }
    }

    private func handleError(statusCode: Int, errorData: Data) -> Error {
        print("### Status Code Received: \(statusCode)")
        var returnErr: Error?

        do {
            let obj = try self.decoder.decode(ErrorResponse.self, from: errorData)
            switch statusCode {
            case 401:
                let userInfo: [String: Any] = self.createUserInfo(obj.error, failureReason: "User Authentication failed")
                returnErr = NSError(domain: self.kDomain, code: ErrorCode.userAuthFailed.rawValue, userInfo: userInfo)

            case 412:
                let userInfo = self.createUserInfo(obj.error, failureReason: "Token expired")
                returnErr = NSError(domain: self.kDomain, code: ErrorCode.tokenInvalid.rawValue, userInfo: userInfo)

            case 500:
                let userInfo: [String: Any] = self.createUserInfo(obj.error, failureReason: "Server failed")
                returnErr = NSError(domain: self.kDomain, code: ErrorCode.searverFailuer.rawValue, userInfo: userInfo)

            case 400:
                let userInfo: [String: Any] = self.createUserInfo(obj.error, failureReason: "Bad Request")
                returnErr = NSError(domain: self.kDomain, code: ErrorCode.searverFailuer.rawValue, userInfo: userInfo)

            default:
                let userInfo: [String: Any] = self.createUserInfo(obj.error, failureReason: "Invalid Request")
                returnErr = NSError(domain: self.kDomain, code: ErrorCode.badRequest.rawValue, userInfo: userInfo)
            }
        } catch {
            let userInfo: [String: Any] = self.createUserInfo("Bad Request", failureReason: "Bad Request")
            returnErr = NSError(domain: self.kDomain, code: ErrorCode.badRequest.rawValue, userInfo: userInfo)
        }

        return returnErr!
    }

    private func createUserInfo(_ descriptionKey: String!, failureReason: String!) -> [String: Any] {
        return  [
            NSLocalizedDescriptionKey: NSLocalizedString(descriptionKey, comment: failureReason) ,
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(descriptionKey, comment: failureReason)
        ]
    }

    public func downloadAsset(urlString: String, completion connectionCompletion: @escaping (_ url: String, _ location: URL?) -> Void) -> URLSessionDownloadTask? {
        if Reach().isNetworkReachable() == true {
            var apiRequest = URLRequest(url: URL(string: urlString)!)

            if let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.token.value) {
                apiRequest.setValue(token, forHTTPHeaderField: kToken)
            }

            let downloadTask = session.downloadTask(with: apiRequest, completionHandler: {[urlString] location, response, err in
                if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200 {
                        connectionCompletion(urlString, location)
                    } else {
                        connectionCompletion(urlString, nil)
                    }
                } else {
                    connectionCompletion(urlString, nil)
                }

                if err != nil {
                    connectionCompletion(urlString, nil)
                } else {
                    connectionCompletion(urlString, location)
                }
            })

            downloadTask.resume()
            return downloadTask
        } else {
            connectionCompletion(urlString, nil)
        }

        return nil
    }

    func uploadImage(_ urlString: String, imageData: Data, messageBody uniquesTagKey: String, methodType HTTPMethod: String, completion connectionCompletion: @escaping (_ responseData: AnyObject?, _ error: NSError?) -> Void) {
        if Reach().isNetworkReachable() == true {
            let url = URL(string: urlString)
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = HTTPMethod
            let boundary = generateBoundaryString()

            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let imgData = imageData
            let body = NSMutableData()
            let fname = "file.png"
            let mimetype = "image/png"

            let tagKey = uniquesTagKey
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"tag_key\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append((tagKey + "\r\n").data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imgData)

            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

            request.httpBody = body as Data

            let session = URLSession.shared

            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 201:
                        connectionCompletion(data! as AnyObject?, error as NSError?)
                    case 401:
                        let userInfo: [String: Any] = self.createUserInfo("User Authentication failed", failureReason: "User Authentication failed")
                        let error = NSError(domain: self.kDomain, code: ErrorCode.userAuthFailed.rawValue, userInfo: userInfo)
                        connectionCompletion(nil, error as NSError)

                    case 500:
                        let userInfo: [String: Any] = self.createUserInfo("Server failed", failureReason: "Server failed")
                        let error = NSError(domain: self.kDomain, code: ErrorCode.searverFailuer.rawValue, userInfo: userInfo)
                        connectionCompletion(nil, error as NSError)

                    default:
                        break
                    }
                } else {
                    let userInfo: [String: Any] = self.createUserInfo("No Network availale", failureReason: "No Network")
                    let error = NSError(domain: self.kDomain, code: ErrorCode.noNetwork.rawValue, userInfo: userInfo)
                    connectionCompletion(nil, error as NSError)
                }
            })

            task.resume()
        } else {
            let userInfo: [String: Any] = self.createUserInfo("No Network availale", failureReason: "No Network")
            let error = NSError(domain: self.kDomain, code: ErrorCode.noNetwork.rawValue, userInfo: userInfo)
            connectionCompletion(nil, error as NSError)
        }
    }

    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
