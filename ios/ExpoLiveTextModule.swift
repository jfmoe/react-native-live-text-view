import ExpoModulesCore

public class ExpoLiveTextModule: Module {

  public func definition() -> ModuleDefinition {

    Name("ExpoLiveText")

    View(ExpoLiveTextView.self) {
      Prop("disabled") { (view, disabled: Bool?) in
        view.disabled = disabled ?? false
      }

      Events("onReady")

      Events("onError")

    }
  }
}
