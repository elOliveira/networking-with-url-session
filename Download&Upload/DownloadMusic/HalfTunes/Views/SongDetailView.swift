import SwiftUI

struct SongDetailView: View {
    
    @Binding var musicItem: MusicItem
    @ObservedObject var download = (UIApplication.shared.delegate as? AppDelegate)?.currentDownload ?? SongDownload()
    @State private var playMusic = false
    @State private var musicImage = UIImage(named: "c_urlsession_card_artwork")!
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                VStack {
                    Image(uiImage: self.musicImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: reader.size.height / 2)
                        .cornerRadius(50)
                        .padding()
                        .shadow(radius: 10)
                    Text("\(self.musicItem.trackName) - \(self.musicItem.artistName)")
                    Text(self.musicItem.collectionName)
                    if ( self.download.state ==  .downloading || self.download.state ==  .paused){
                        Text("\(Int(self.download.downloadedAmount * 100)) % downloaded")
                            .padding(.top)
                    }
                    HStack {
                        Button<Text>(action: self.botaoDownloadClick){
                            switch self.download.state{
                            case .waiting:
                                return Text("Baixar")
                            case .finished:
                                return Text("Escutar")
                            case .paused:
                                return Text("Continuar")
                            case .downloading:
                                return Text("Pausar")
                            }
                        }
                        
                        if (self.download.state == .paused || self.download.state == .downloading){
                            Button(action: self.download.cancel) {
                                Text("Cancelar")
                            }
                        }
                    }.sheet(isPresented: self.$playMusic) {
                        AudioPlayer(songUrl: self.download.downloadLocation!)
                    }
                }.onAppear(perform: displayAlbumArt)
            }
        }
    }
    
    func displayAlbumArt(){
        guard let albumImageUrl = URL(string: musicItem.artwork) else { return }
        
        let task = URLSession.shared.downloadTask(with: albumImageUrl) { location, response, error in
            
            guard let location = location,
                  let imageData = try? Data(contentsOf: location),
                  let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                self.musicImage = image
            }
        }
        task.resume()
    }
    
    func botaoDownloadClick(){
        switch self.download.state{
        case .waiting:
            guard let previewUrl = self.musicItem.previewUrl else { return }
            self.download.fetchSongAtUrl(previewUrl)
            break
        case .finished:
            self.playMusic = true
            break
        case .paused:
            self.download.resume()
            break
        case .downloading:
            self.download.pause()
            break
        }
    }
}

struct SongDetailView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var musicItem = MusicItem(id: 192678693, artistName: "Leonard Cohen", trackName: "Hallelujah", collectionName: "The Essential Leonard Cohen", preview: "https://audio-ssl.itunes.apple.com/itunes-assets/Music/16/10/b2/mzm.muynlhgk.aac.p.m4a", artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/77/17/ab/7717ab31-46f9-48ca-7250-9f565306faa7/source/1000x1000bb.jpg")
        
        var body: some View {
            SongDetailView(musicItem: $musicItem)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
