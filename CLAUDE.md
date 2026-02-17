# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

`react-native-live-text-view` is an Expo Modules-based React Native library that enables iOS Live Text interactions on images.

- Library package at repo root (`src/`, `ios/`, `expo-module.config.json`)
- Demo app in `example/` (used to manually verify behavior on iOS)
- iOS-only native implementation (no Android module)

## Common commands

Run commands from repository root unless noted.

### Library development

- Install deps: `npm install`
- Build JS/types: `npm run build`
- Lint: `npm run lint`
- Run tests: `npm test`
- Run a single test file/pattern: `npm test -- <testPathPattern>`
- Clean generated artifacts: `npm run clean`
- Prepare package artifacts: `npm run prepare`
- Run prepublish checks: `npm run prepublishOnly`

### Example app (manual iOS verification)

Run from `example/`:

- Install deps: `npm install`
- Start Expo dev server: `npm run start`
- Build/run iOS app: `npm run ios`

From repo root, open native iOS workspace for example:

- `npm run open:ios`

## Architecture

### JavaScript/TypeScript layer

- `src/index.ts` exports the public API (`LiveTextView`, `LiveTextViewProps`).
- `src/LiveText.types.ts` defines typed event payloads and props passed between JS and native.
- `src/LiveTextView.tsx` is the main JS wrapper around the native view manager (`requireNativeViewManager('ReactNativeLiveTextView')`).
  - It adapts native events and preserves backward compatibility for consumers accessing payloads via `event.nativeEvent`.

### Native iOS layer

- `ios/ReactNativeLiveTextViewModule.swift` registers the Expo module and view:
  - module name: `ReactNativeLiveTextView`
  - props: `disabled`, `liveActionButtonHidden`
  - events: `onStart`, `onReady`, `onError`, `onTextSelectionChange`, `onHighlightChange`
- `ios/ReactNativeLiveTextView.swift` implements the `ExpoView` and `ImageAnalysisInteractionDelegate` behavior:
  - Locates the underlying `UIImageView` from React subviews
  - Attaches `ImageAnalysisInteraction`
  - Runs async `ImageAnalyzer` analysis for text
  - Emits lifecycle/results/errors back to JS
  - Re-runs analysis when image changes via KVO on `imageView.image`

### Module wiring

- `expo-module.config.json` declares iOS module autolinking and points to `ReactNativeLiveTextViewModule`.
- `ios/ReactNativeLiveTextView.podspec` defines CocoaPods packaging for the module and depends on `ExpoModulesCore`.

## Platform and behavior constraints

- The module is iOS-only.
- Live Text analysis is gated in native code with `@available(iOS 16.0, *)` and `ImageAnalyzer.isSupported` checks.
- `onTextSelectionChange.selectedText` depends on iOS 17+ (`selectedText` is empty on earlier iOS versions).

## Validation workflow for changes

For most code changes, validate with:

1. `npm run lint`
2. `npm run build`
3. `npm test`
4. Manual verification in `example/` on iOS (`npm run ios` from `example/`) for native behavior/event changes
