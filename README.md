# PhotoFetcher

**PhotoFetcher** is a SwiftUI project that asynchronously loads and displays images in both grid and list formats, fetching data from the Picsum API. The app focuses on demonstrating pagination and efficient data fetching with basic local storage features.

## Features

- **Asynchronous Image Loading**: Fetches images from an API using a modular architecture.
- **Pagination Support**: Handles loading more images as the user scrolls.
- **Favorites**: Users can mark photos as favorites using `UserDefaults`.
- **Error Handling**: Comprehensive error handling for network issues.
- **Grid and List Views**: Compare grid and list views for image presentation.

## Architecture Overview

The project follows a modular and testable architecture with the use of protocols, dependency injection, and the repository pattern. This ensures clean separation of concerns, maintainability, and testability.

### Key Components:

1. **View Models**:
   - **PhotosGridViewModel** and **PhotosListViewModel**: Manage the state for loading images from the repository. Handle pagination and error states.
   - **BaseViewModel**: Shared functionality for handling photos and favorites across different views.
   - **FavoritesManager**: Manages the user's favorite photos stored in `UserDefaults`.

2. **PhotoRepository**:
   - Provides a clean abstraction for fetching photos from either the API or local storage (if available).
   - Decouples the data source (network or local) from the view models, improving testability.

3. **DependencyContainer**:
   - Centralizes the creation of services, repositories, and view models.
   - Ensures services are reusable across the app and in SwiftUI previews.

4. **APIService**:
   - Handles network requests for fetching photos from the Picsum API.
   - Uses the **NetworkManager** to manage API requests and response validation.

5. **NetworkManager**:
   - Manages all network-related operations using `URLSession`.
   - Handles response validation, error logging, and supports mock sessions for testing.

6. **Fetching and Persistence**:
   - **PaginatedFetcher**: Supports paginated fetching of images from the Picsum API.
   - **FavoritesManager**: Manages the user's favorite photos using `UserDefaults`.

7. **Views**:
   - **MainView**: Houses the TabView for switching between grid and list views.
   - **PhotosGridView** and **PhotosListView**: Display photos using either a grid or list layout.
   - **Shared Views**: Includes shared UI components like `PhotoCardView`, `PhotoLoaderView`, and `FavoriteToggleButton`.

## Future Improvements

- Enhance testing coverage for view models and services.
- Expand local data persistence capabilities.
- Improve UI for adaptive layouts on iPad.
- Add support for additional image sources.
