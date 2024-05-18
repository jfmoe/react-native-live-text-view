import ExpoModulesCore

public class ReactNativeLiveTextViewModule: Module {

  public func definition() -> ModuleDefinition {

    Name("ReactNativeLiveTextView")

    View(ReactNativeLiveTextView.self) {
      Prop("disabled") { (view, disabled: Bool?) in
        view.disabled = disabled ?? false
      }

      Prop("liveActionButtonHidden") { (view, liveActionButtonHidden: Bool?) in
        view.liveActionButtonHidden = liveActionButtonHidden ?? false
      }

      Events("onStart")

      Events("onReady")

      Events("onError")

      Events("onTextSelectionChange")

      Events("onHighlightChange")

    }
  }
}
