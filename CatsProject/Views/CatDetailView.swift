import SwiftUI

struct CatDetailView: View {
    let cat: CatImageViewModel
    @Binding var isPresented: CatImageViewModel?
    
    var body: some View {
        VStack {
            RemoteImage(url: cat.url)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button("Close") {
                isPresented = nil
            }
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(8)
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
    }
}
