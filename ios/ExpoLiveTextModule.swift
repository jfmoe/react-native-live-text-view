import ExpoModulesCore

public class ExpoLiveTextModule: Module {

  public func definition() -> ModuleDefinition {

    Name("ExpoLiveText")

    Events("onChange")

    AsyncFunction("setValueAsync") { (value: String) in
      self.sendEvent(
        "onChange",
        [
          "value": value
        ])
    }

    View(ExpoLiveTextView.self) {
      Prop("disabled") { (view, disabled: Bool?) in
        view.disabled = disabled ?? false
      }

      Events("onReady")

    }
  }
}
