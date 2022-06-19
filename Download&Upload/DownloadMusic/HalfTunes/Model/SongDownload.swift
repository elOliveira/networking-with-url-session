import SwiftUI

let identificadorTask :String = "task_id_gambiarra"
class SongDownload : NSObject, ObservableObject {
    
    var downloadTask: URLSessionDownloadTask?
    var downloadUrl: URL?
    var resumeData:  Data?
    var urlSession: URLSession?
    var completionHandler: ( () -> Void)?

    @Published var downloadLocation: URL?
    @Published var downloadedAmount: Float = 0
    @Published var state: DownloadState = .waiting
    
    enum DownloadState{
        case waiting
        case downloading
        case paused
        case finished
    }

    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.background(withIdentifier: identificadorTask)
        
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func fetchSongAtUrl(_ item: URL){
        downloadUrl = item
        downloadTask = urlSession?.downloadTask(with: item)
        downloadTask?.resume()
        state = .downloading
    }
    
    func cancel(){
        state = .waiting
        downloadTask?.cancel()
        DispatchQueue.main.async {
            self.downloadedAmount = 0
        }
    }
    
    func resume(){
        
        guard let resumeData = resumeData else { return }
        downloadTask = self.urlSession?.downloadTask(withResumeData: resumeData)
        downloadTask?.resume()
        state = .downloading
    }
    
    func pause(){
        downloadTask?.cancel(byProducingResumeData: { data in
            DispatchQueue.main.async {
                self.resumeData = data
                self.state = .downloading
            }
        })

    }
}

extension SongDownload: URLSessionDownloadDelegate {
    
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        guard let completitionHandler = completionHandler else { return }
        completitionHandler()
        print("Chamou a completition handler")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.downloadedAmount = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            print(self.downloadedAmount)
        }
    }


    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error{
            print(error.localizedDescription)
        }

        print("Finished")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let fileManager = FileManager.default
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { fatalError() }
        
        let lastPathComponent = downloadUrl?.lastPathComponent ?? "song.m4a"
        
            let destinationUrl = documentsPath.appendingPathComponent(lastPathComponent)
        
            do {
                if fileManager.fileExists(atPath: destinationUrl.path){
                    try fileManager.removeItem(at: destinationUrl)
                }
                
                try fileManager.copyItem(at: location, to: destinationUrl)
                DispatchQueue.main.async {
                    self.downloadLocation = destinationUrl
                    self.state = .finished
                }
                
            } catch {
                print(error)
            }
    }
}
 
