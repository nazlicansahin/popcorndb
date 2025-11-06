//
//  ViewController.swift
//  popcorndb
//
//  Created by Nazlı on 26.07.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    /*
        
        // Do any additional setup after loading the view.
        testPopularMovies()
        testSearchMovies()
        testMovieDetail()
        testMovieCredits()
        testMovieRecommendations()
        testPersonDetail()
    }

    
    //1
    func testPopularMovies() {
        NetworkManager.shared.request(.popularMovies(page: 1), type: MovieResponse<Movie>.self) { result in
            switch result {
            case .success(let response):
                // print("1.. Popüler Filmler Sayısı: \(response.results.count)")
                // print(" İlk Film: \(response.results.first?.title ?? "Yok")")
            case .failure(let error):
                // print("❌ popularMovies Hatası: \(error.description)")
            }
        }
    }
    
    //2
    func testSearchMovies() {
        let params = SearchParameters(
            query: "ice age",
            page: 1,
            includeAdult: false,
            language: .english
        )

        NetworkManager.shared.request(.searchMovies(params), type: MovieResponse<Movie>.self) { result in
            switch result {
            case .success(let response):
                // print("2.. Arama Sonucu: \(response.results.count) film bulundu")
            case .failure(let error):
                // print("❌ searchMovies Hatası: \(error.description)")
            }
        }
    }
    
    //3
    func testMovieDetail() {
        NetworkManager.shared.request(.movieDetail(id: 12), type: MovieDetail.self) { result in
            switch result {
            case .success(let detail):
                // print("3.. Film Detayı: \(detail.title) (\(detail.releaseDate))")
            case .failure(let error):
                // print("❌ movieDetail Hatası: \(error.description)")
            }
        }
    }
    
    //4
    func testMovieCredits() {
        NetworkManager.shared.request(.movieCredits(id: 12), type: CastResponse.self) { result in
            switch result {
            case .success(let credits):
                // print("4.. Cast Sayısı: \(credits.cast.count)")
                // print(" İlk Oyuncu: \(credits.cast.first?.name ?? "Yok")")
            case .failure(let error):
                // print("❌ movieCredits Hatası: \(error.description)")
            }
        }
    }
    
    //5
    func testMovieRecommendations() {
        NetworkManager.shared.request(.movieRecommendations(id: 12), type: MovieResponse<Movie>.self) { result in
            switch result {
            case .success(let response):
                // print("5.. Önerilen Filmler: \(response.results.count)")
            case .failure(let error):
                // print("❌ movieRecommendations Hatası: \(error.description)")
            }
        }
    }
    
    //6
    func testPersonDetail() {
        NetworkManager.shared.request(.personDetail(id: 13), type: Person.self) { result in
            switch result {
            case .success(let person):
                // print("6.. Oyuncu: \(person.name)")
                // print(" Biyografi (ilk 100): \(person.biography.prefix(100))...")
            case .failure(let error):
                // print("❌ personDetail Hatası: \(error.description)")
            }
        }
    }
  
        
*/
}
}
