import Foundation
import EssentialFeed
import EssentialFeediOS
import Combine

final class LoadResourcePresentationAdapter<Resource, view: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, view>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoading(with: error)
                    }
                }, receiveValue: { [weak self] resouce in
                    self?.presenter?.didFinishLoading(with: resouce)
                })
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }

    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}

