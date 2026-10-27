# WishOn

**WishOn** is an iOS client for personal and event wishlists.

## Status

Early MVP / prototype. Google Sign-In and viewing wishlists from Firestore work; saving wishlist/wish, Apple Sign-In, profile, calendar, and To Give are partial or stubs. Task backlog: [Issues](https://github.com/maribudko/WishOn.iOS/issues).

## Tech stack

| | |
|---|---|
| UI | SwiftUI |
| Language | Swift |
| Modules | Local SPM packages |
| Backend | Firebase Auth + Cloud Firestore |
| Sign-in | Google Sign-In (Apple Sign-In button exists; logic is TODO) |
| DI | Swinject (`DependencyInjection`) |
| Other | SwiftGen (`WOResources`), SwiftLint |

Feature pattern: **StateMachine → StateFactory → ViewModel → View** (plus UseCase / Repository for wishlists).

## Module layout

```
WishOn (app) / PreviewHost
├── Modules/Core
│   ├── DependencyInjection   — AppAssembler, Swinject
│   ├── WOCore                — models, Auth, WishListRepository
│   ├── WODesign              — design tokens and reusable views
│   └── WOResources           — L10n, Assets (SwiftGen)
├── Modules/Features
│   ├── WOLoginFeature
│   ├── WOWishListsRootFeature
│   ├── WONewWishListFeature
│   ├── WOAddNewItemFeature
│   └── WOToGiveFeature
└── Modules/WONetwork         — stub (unused)
```

App entry: `WishOn/Sources/App/WishOnApp.swift`.  
UI-test host: `PreviewHost`.

## Open and build

1. Clone the repo and open `WishOn.xcodeproj` in **Xcode** (current Xcode targeting ~iOS 18.x for the app).
2. Wait for SPM to resolve (Firebase, GoogleSignIn, Swinject, and local packages).
3. Select the **WishOn** scheme and a simulator or device, then Run.

### Firebase

`WishOn/GoogleService-Info.plist` is already in the repository (normal for Firebase iOS clients). It is client config for the Firebase project `wishonapp`, not a server secret. Safe use still requires correct **Firestore Security Rules** and Auth in the Firebase Console. Do not commit service accounts, CI tokens, or other credentials.

## What works / what does not

**Present in code:** Google Login, root wishlists screen (Firestore), New Wishlist / Add Wish forms, To Give UI, design system, unit tests in SPM packages, PreviewHost UI tests.

**Not ready yet:** end-to-end save of wishlist/wish from the UI, Apple Sign-In, profile and calendar, real To Give data, CI.

## Repository

[maribudko/WishOn.iOS](https://github.com/maribudko/WishOn.iOS)
