import Foundation
import Networking
import FirebasePerformance

class CatViewModel: ObservableObject {
    @Published var catImages: [CatImageViewModel] = []

    private let networkingService: NetworkingServiceProtocol

    init(networkingService: NetworkingServiceProtocol = NetworkingService()) {
        self.networkingService = networkingService
    }

    func fetchCatImages() {
        let trace = Performance.startTrace(name: "APP_FETCH_TIME")
        let queue = DispatchQueue.main
        let group = DispatchGroup()
        networkingService.fetchCatImages { result in
            queue.async(group: group, execute: {
                switch result {
                case .success(let catImages):
                    self.catImages = catImages.map { CatImageViewModel(id: $0.id, url: $0.url) }
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
        }
        group.notify(queue: queue, execute: trace!.stop)
    }
}

struct CatImageViewModel: Identifiable {
    let id: String
    let url: String
    let name: String
    
    public init(id: String, url: String) {
        self.id = id
        self.url = url
        self.name = "Random cat \(Int.random(in: 1...100))"
    }
}
