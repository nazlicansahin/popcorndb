//
//  CastDetailViewModel.swift
//  popcorndb
//
//  Created by You on 2025-08-xx
//
import Foundation

final class CastDetailViewModel {

    struct ViewData {
        let name: String
        let role: String        // knownForDepartment
        let biography: String
        let profileURL: URL?
        let birthday: String?
        let placeOfBirth: String?
        let deathday: String?
    }

    private(set) var viewData: ViewData?

    func fetch(personID: Int, completion: @escaping (Result<ViewData, NetworkError>) -> Void) {
        NetworkManager.shared.request(.personDetail(id: personID), type: Person.self) { [weak self] result in
            switch result {
            case .success(let p):
                let vd = ViewData(
                    name: p.name,
                    role: p.knownForDepartment,
                    biography: p.biography,
                    profileURL: p.profileURL,
                    birthday: p.birthday,
                    placeOfBirth: p.placeOfBirth,
                    deathday: p.deathday
                )
                self?.viewData = vd
                completion(.success(vd))
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
}
