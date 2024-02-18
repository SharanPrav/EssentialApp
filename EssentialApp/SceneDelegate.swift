import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)
        
        let localStroreURL = NSPersistentContainer
            .defaultDirectoryURL
            .appendingPathComponent("feed-store.sqlite")
        
        let localDataStore = try! CoreDataFeedStore(storeURL: localStroreURL)
        let localfeedLoader = LocalFeedLoader(store: localDataStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localDataStore)        
        
        let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: FeedLoaderWithFallbackComposite(primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localfeedLoader), fallback: localfeedLoader), imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader)))
        
        window?.rootViewController = feedViewController
    }
}

