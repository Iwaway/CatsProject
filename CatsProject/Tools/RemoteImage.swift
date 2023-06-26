import SwiftUI
import FirebasePerformance

struct RemoteImage: View {
    @StateObject private var imageLoader: ImageLoader

    init(url: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray
            }
        }
        .onAppear {
            imageLoader.loadImage()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: String

    init(url: String) {
        self.url = url
    }

    func loadImage() {
        guard let imageUrl = URL(string: url) else { return }
        
        let trace = Performance.startTrace(name: "APP_IMAGE_LOAD_TIME")
        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
        trace?.stop()
    }
}
