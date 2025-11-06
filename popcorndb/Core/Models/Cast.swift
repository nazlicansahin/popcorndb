import Foundation

struct Cast: Codable {
    let id: Int
    let name: String
    let originalName: String
    let character: String
    let profilePath: String?
    let gender: Int
    let knownForDepartment: String
    let popularity: Double
    let castID: Int?
    let creditID: String
    let order: Int
    let adult: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case character
        case profilePath = "profile_path"
        case gender
        case knownForDepartment = "known_for_department"
        case popularity
        case castID = "cast_id"
        case creditID = "credit_id"
        case order
        case adult
    }

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var genderDescription: String {
        switch gender {
        case 1: return "gender_female".localized
        case 2: return "gender_male".localized
        default: return "gender_other".localized
        }
    }
}
