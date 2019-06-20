//
//  ChatService.swift
//  ChatApp
//
//  Created by Gabriel Betancourt on 20.06.19.
//  Copyright © 2019 Gabriel Betancourt. All rights reserved.
//

import Foundation
import Moya

enum ChatService {
    case test
    case getMessages(sender: Int, nickname: Int)
    case getMoreMessages(sender: Int, nickname: Int, lastMessage: Int)
}

extension ChatService: TargetType {
    
    var method: Moya.Method {
        switch self {
        case .test:
            return .get
        case .getMessages, .getMoreMessages:
            return .post
        }
    }
    
    var baseURL: URL {
        return URL(string: "http://api.chat.com")!
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .test:
            return "Este es el request de prueba".utf8Encoded
        case .getMessages(let sender, let nickname):
            return "\(sender) \(nickname))".utf8Encoded
        case .getMoreMessages(let sender, let nickname, let LastMessage):
            return "\(sender) \(nickname) \(LastMessage)".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .test:
            return .requestPlain
        case let .getMessages(sender,nickname):
            return .requestParameters(parameters: ["sender" : sender, "nickname" : nickname] , encoding: JSONEncoding.default)
        case .getMoreMessages(let sender, let nickname, let lastMessage):
            return .requestParameters(parameters: ["sender" : sender, "nickname" : nickname, "lastMessage" : lastMessage] , encoding: JSONEncoding.default)
        }
    }
    
    var path: String {
        switch self {
        case .test:
            return "/test"
        case .getMessages(let sender, let nickname):
            return "\(sender) \(nickname)"
        case .getMoreMessages(let sender, let nickname, let lastMessage):
            return "\(sender) \(nickname) \(lastMessage)"
        }
    }
    
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

