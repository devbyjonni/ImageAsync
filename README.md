# PhotoFetch

**PhotoFetch** is a SwiftUI project that asynchronously loads and displays images in a grid format. The app supports fetching images from an API and storing them locally, allowing for offline capabilities and efficient data handling.

## Features

- Asynchronous image loading using a modular architecture.
- Pagination support for incrementally fetching images.
- Data fetching from an API with local persistence (e.g., Core Data).
- Comprehensive error handling for network and persistence issues.
- Uses a repository pattern for better separation of concerns and testability.

## Architecture Overview

The project follows a modular and testable architecture with the use of protocols, dependency injection, and the repository pattern. This makes it easy to add features, maintain, and expand.

### Key Components:

1. **PhotosGridViewModel**
   - Manages state for loading images from the `PhotoRepository`.
   - Handles pagination and error handling.
   - Exposes necessary state for the `PhotosGridView` to display the data.

2. **PhotoRepository**
   - Provides a clean abstraction for fetching photos from either the network or local storage (e.g., Core Data, UserDefaults).
   - Implements the logic to first try loading data from local storage and, if unavailable, falls back to fetching from the API.

3. **DependencyContainer**
   - Centralizes the creation of the services, repository, and ViewModel.
   - Injected into the app and views to ensure proper dependency management.
   - Ensures services are reusable across the app and in SwiftUI previews.

4. **APIService & PersistenceService**
   - `APIService`: Handles network requests for fetching data from the API.
   - `PersistenceService`: Provides an abstraction for saving and fetching data from local storage (e.g., Core Data, UserDefaults).

5. **NetworkManager**
   - Manages all network requests and response validation.
   - Encapsulates `URLSession` handling to allow easy swapping for mock sessions during testing.

6. **CoreDataService (or other persistence options)**
   - Handles saving and fetching photos from local storage (e.g., Core Data).
   - This service can easily be swapped for other storage options like `UserDefaults` or `Keychain`.

## Preview Setup

To make the preview work seamlessly with the app's dependencies, we use a `DependencyContainer` to inject the necessary ViewModel and services.

```swift
#Preview {
    HomeView()
        .environmentObject(DependencyContainer().viewModel)
}
```

## Future Improvements

- Reintroduce and enhance the testing strategy.
- Add more detailed user feedback for error states.
- Expand local data persistence capabilities with advanced features like caching.
- Improve UI for adaptive layouts on iPad.
- Add support for additional image sources.
