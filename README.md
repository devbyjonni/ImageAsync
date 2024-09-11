# ImageAsync

**ImageAsync** is a SwiftUI project that asynchronously loads and displays images in a grid format. It supports fetching images both from an API and from a local JSON bundle, making it versatile for real-world use cases and offline capabilities.

## Features

- Asynchronous image loading using `Kingfisher`.
- Pagination support for fetching images incrementally.
- Supports loading data from an API or local JSON bundles.
- Comprehensive error handling for network issues, decoding failures, and more.
- Modular and testable architecture with the use of protocols and dependency injection.

## Architecture Overview

The project follows a modular architecture where key components are separated into distinct layers for better maintainability and testing.

### Key Components:

1. **PhotosGridViewModel**
   - Handles the logic of loading images from either an API or a local bundle.
   - Manages pagination and error handling.
   - Exposes the necessary state for the `PhotosGridView`.

2. **APIService & BaseAPIService**
   - Abstracted service layer for handling data fetching.
   - Supports fetching from an API or local JSON bundle.

3. **NetworkManager**
   - Manages all networking requests, ensuring modularity and testability.
   - Validates network responses and throws appropriate errors.

4. **BundleManager**
   - Handles loading local JSON data from the app bundle.

## Testing Strategy

The code is designed with testability in mind, using dependency injection to allow easy mocking of services and network requests.

### 1. **PhotosGridViewModel Testing**
   - **Test Success with API Data:**
     Mock the `APIService` to simulate successful image loading from the API. Assert that the `images` array is populated and `isLoading` is set to `false` after the fetch.
   - **Test Success with Bundle Data:**
     Mock the `APIService` to load data from the local bundle (`TestPicsumPhotos.json`). Verify that the bundle data is loaded properly into the `images` array.
   - **Test Failure Cases:**
     Simulate failure scenarios (e.g., network errors, decoding issues) and ensure `viewModelError` is set correctly, and `isLoading` is `false` after the failure.

### 2. **APIService Testing**
   - **Test API Fetching:**
     Mock the network response to simulate successful and failed API requests. Validate that the `performFetch` method returns the correct data or throws the expected errors.
   - **Test Bundle Fetching:**
     Ensure that the `performFetch` method correctly loads data from a JSON file in the app bundle. Test both success and failure cases (e.g., missing file, corrupted data).

### 3. **NetworkManager Testing**
   - **Test Network Request Execution:**
     Mock `URLSession` to simulate successful and failed network requests. Validate that the `performRequest` method handles responses appropriately and returns correct data or throws errors.
   - **Test Response Validation:**
     Ensure the `validateResponse` method handles various HTTP status codes correctly (e.g., 200-299 as success, others as errors).

### 4. **BundleManager Testing**
   - **Test JSON Loading:**
     Simulate loading JSON data from the app bundle. Ensure that the data is correctly parsed and returned as expected. Test failure scenarios like missing or corrupted files, and validate that appropriate errors are thrown.

## Future Improvements

- Enhance the testing strategy.
- Provide more detailed user feedback in error handling.
- Improve the UI for iPad with adaptive layouts.
- Add support for more image sources (e.g., remote databases).

