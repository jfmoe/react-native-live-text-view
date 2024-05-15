import ExpoModulesCore

public class ExpoLiveTextModule: Module {

  public func definition() -> ModuleDefinition {

    Name("ExpoLiveText")

    View(ExpoLiveTextView.self) {
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
