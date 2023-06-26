import SwiftUI
import FirebasePerformance
import FirebaseCrashlytics


struct ContentView: View {
    @StateObject private var viewModel = CatViewModel()
    @State private var selectedCat: CatImageViewModel?

    var body: some View {
        NavigationView {
            List(viewModel.catImages, id: \.id) { catImage in
                VStack(alignment: .leading) {
                    RemoteImage(url: catImage.url)
                        .aspectRatio(contentMode: .fit)
                    Text(catImage.name)
                }
                .onTapGesture {
                    selectedCat = catImage
                    Crashlytics.crashlytics().setCustomValue(catImage.id, forKey: "selected_cat")
                    Crashlytics.crashlytics().log("selected cat: "+selectedCat!.name)
                }
            }
            .navigationBarTitle("Cats")
        }
        .onAppear {
            viewModel.fetchCatImages()
        }
        .fullScreenCover(item: $selectedCat) { cat in
            CatDetailView(cat: cat, isPresented: $selectedCat)
        }
        HStack{
            Button("Crash!") {
                crash1()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func crash1(){
    fatalError()
}

func crash2(){
    _ = [0][1]
}

func crash3(){
    _ = 0/1
}
