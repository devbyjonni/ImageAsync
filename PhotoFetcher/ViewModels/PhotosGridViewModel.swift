
import Foundation

class PhotosGridViewModel: BaseViewModel {
    
    required init(dependency: DependencyContainer) {
        LogMessages.viewModelInit(name: "PhotosGridViewModel", functionName: #function)
        super.init(dependency: dependency)
    }
}
