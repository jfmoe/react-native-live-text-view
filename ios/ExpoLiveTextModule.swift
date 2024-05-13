import ExpoModulesCore

public class ExpoLiveTextModule: Module {

  public func definition() -> ModuleDefinition {

    Name("ExpoLiveText")

    // Prop("enable") { (view, enable: Bool?) in
    //   view.enable = enable ?? false
    // }

    Events("onChange")

    AsyncFunction("setValueAsync") { (value: String) in
      self.sendEvent(
        "onChange",
        [
          "value": value
        ])
    }

    View(ExpoLiveTextView.self) {

    }
  }
}
