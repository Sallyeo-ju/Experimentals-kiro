# sectors_bob_app

BOB is an AI stock analysis app for Indonesian retail investors on the IDX
exchange. This repository is the mobile frontend only. The backend is not
available here, so the app runs against a mock service layer that can be
swapped for a real API later without touching the UI.

## What is in this app

The hero flow, end to end:

Splash to Onboarding to Auth (Login and Sign Up) to Home to AI Chat to Stock
Detail.

Highlights:

- State management with Riverpod.
- Routing with go_router, including a three-tab bottom shell: Berita, Beranda
  (the hero), and BOB AI.
- Chat responses come back as structured data and are rendered as clean cards
  with progressive disclosure, a thinking indicator, and a mandatory
  disclaimer.
- Design tokens taken from the client palette. Gold is for actions only, green
  and red are for data signals only.
- All primary copy is in Bahasa Indonesia.

## Mock service layer

The service layer is fully mocked and sits behind interfaces:

- `AuthService` (email and password, plus a Google button wired to the mock).
- `StockService` (local stocks, favorites, recently searched, and full detail
  with chart points, technicals, fundamentals, and news).
- `ChatService` (send a message, receive a thinking state, then a structured
  analysis).

Mock data covers four IDX blue chips: BBCA, BBRI, BMRI, and TLKM. The chat mock
emits a thinking message first, waits to simulate progressive analysis, then
emits the final structured result, so the streaming behaviour is real even
against mock data.

To connect a real backend, implement the interfaces under
`lib/services/interfaces` and override the providers in the root `ProviderScope`
inside `lib/main.dart`. Nothing in the UI changes. For example:

```dart
ProviderScope(
  overrides: <Override>[
    chatServiceProvider.overrideWithValue(HttpChatService(apiClient)),
    stockServiceProvider.overrideWithValue(HttpStockService(apiClient)),
    authServiceProvider.overrideWithValue(HttpAuthService(apiClient)),
  ],
  child: const BobApp(),
)
```

Because the chat AI returns structured data (not markdown), a real backend just
needs to produce the same JSON shape defined in
`lib/services/models/analysis_models.dart`. The cards render it as is.

## Tech stack

- Flutter (Material 3, light mode first).
- Riverpod for state management.
- go_router for navigation and the three-tab shell.
- google_fonts for Plus Jakarta Sans.
- intl for Rupiah and percent formatting in the id_ID locale.

## Folder structure

```
lib/
  core/
    theme/      design tokens and the app theme
    router/     go_router route graph
  services/
    interfaces/ service contracts (Auth, Stocks, Chat)
    mock/       mock implementations and Indonesian mock data
    models/     data models with fromJson and toJson
    widgets/    shared UI widgets (buttons, badges, logo)
    format/     number formatters (Rupiah, percent)
  features/
    splash/       splash screen
    onboarding/   three onboarding slides
    auth/         login and sign up
    home/         Beranda hero screen
    chat/         AI chat with structured analysis cards
    stock_detail/ price block, sparkline chart, sections
    news/         Berita tab placeholder
  main.dart     app entry point
```

## Requirements

- Flutter stable SDK.
- Dart SDK 3.3.0 or newer, below 4.0.0.

The Plus Jakarta Sans font is fetched at runtime by the google_fonts package,
so no font files are bundled.

The sparkline chart uses `Color.withOpacity` for its gradient fill to stay
compatible with the 3.3.0 SDK floor, since `Color.withValues(alpha:)` only
exists on newer stable SDKs. On a recent SDK the analyzer may flag this as
deprecated. If you raise the SDK floor, switch those two calls in
`lib/features/stock_detail/widgets/sparkline_chart.dart` to `withValues(alpha:)`.

## How to run

```
flutter pub get
flutter run
```

## Notes

- The service layer is mocked. Prices, indicators, and news are illustrative
  sample data, not live market data.
- Nothing in the app is investment advice. Every analysis carries a disclaimer
  that reminds users to do their own research.
