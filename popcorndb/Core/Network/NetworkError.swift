
import UIKit
import Foundation
import Moya

enum NetworkError: Error {
    case decoding(Error)
    case request(MoyaError)

     var description: String {
        switch self {
        case .decoding(let error): return "Decode error: \(error.localizedDescription)"
        case .request(let error): return "Request error: \(error.localizedDescription)"
        }
    }
}
