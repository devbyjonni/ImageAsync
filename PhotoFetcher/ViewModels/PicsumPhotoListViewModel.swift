import Foundation

class PicsumPhotoListViewModel: BaseViewModel {
    
    required init(dependency: DependencyContainer) {
        LogMessages.viewModelInit(name: "PicsumPhotoListViewModel", functionName: #function)
        super.init(dependency: dependency)
    }
}


