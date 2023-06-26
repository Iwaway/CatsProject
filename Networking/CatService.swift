import Foundation

public protocol NetworkingServiceProtocol {
    func fetchCatImages(completion: @escaping (Result<[CatImage], Error>) -> Void)
}

public class NetworkingService: NetworkingServiceProtocol {
    let type = Bundle.main.object(forInfoDictionaryKey: "type") as? String

    public init() {}

    public func fetchCatImages(completion: @escaping (Result<[CatImage], Error>) -> Void) {
        var baseUrl = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10")!
        
        if type == "DOGS" {
            baseUrl = URL(string: "https://api.thedogapi.com/v1/images/search?limit=10")!
        }
        
        var request = URLRequest(url: baseUrl)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkingError", code: 0, userInfo: nil)))
                return
            }

            do {
                let catImages = try JSONDecoder().decode([CatImage].self, from: data)
                completion(.success(catImages))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
