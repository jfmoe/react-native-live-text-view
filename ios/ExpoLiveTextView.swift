import ExpoModulesCore
import UIKit
import Vision
import VisionKit

class ExpoLiveTextView: ExpoView {

  let onReady = EventDispatcher()

  private var mySub: Any? = nil
  private var imageView: UIImageView? = nil

  @available(iOS 16.0, *)
  static let imageAnalyzer = ImageAnalyzer.isSupported ? ImageAnalyzer() : nil

  var disabled: Bool = false {
    didSet {
      guard #available(iOS 16.0, *), oldValue != disabled,
        ImageAnalyzer.isSupported
      else {
        return
      }

      if disabled {
        if let interaction = findImageAnalysisInteraction() {
          self.imageView?.removeInteraction(interaction)
          self.clean()
        }
      } else {
        self.analyzeImage(attempts: 2)
      }
    }
  }

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    clipsToBounds = true
  }

  override func didMoveToWindow() {
    if #available(iOS 16.0, *), !disabled {
      self.analyzeImage(attempts: 2)
    }

  }

  private func analyzeImage(attempts: Int) {
    guard #available(iOS 16.0, *),
      ImageAnalyzer.isSupported
    else {
      return
    }

    if attempts == 0 {
      // Handle the case when imageView is still nil after several attempts
      print("Failed to initialize imageView")
      return
    }

    if let imageView = self.subviews.first?.subviews.first as? UIImageView {
      self.imageView = imageView

      if let imageView = self.imageView {
        let interaction = ImageAnalysisInteraction()
        imageView.addInteraction(interaction)
      }

      self.attachAnalyzerToImage()

      self.mySub = imageView.observe(\.image, options: [.new]) { object, change in
        self.attachAnalyzerToImage()
      }
    } else {
      print("------------------------------- attempts \(attempts)")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.analyzeImage(attempts: attempts - 1)
      }
    }
  }

  @available(iOS 16.0, *)
  private func attachAnalyzerToImage() {
    guard let image = self.imageView?.image else {
      return
    }

    Task {
      guard let imageAnalyzer = Self.imageAnalyzer,
        let imageAnalysisInteraction = self.findImageAnalysisInteraction()
      else {
        return
      }

      let configuration = ImageAnalyzer.Configuration([.text])

      do {
        let analysis = try await imageAnalyzer.analyze(image, configuration: configuration)

        DispatchQueue.main.async {
          imageAnalysisInteraction.analysis = analysis
          imageAnalysisInteraction.preferredInteractionTypes = .automatic

          self.onReady([
            "hasResults": analysis.hasResults(for: [.text]),
            "transcript": analysis.transcript,
          ])
        }
      } catch {
        print(error.localizedDescription)
      }
    }

  }

  @available(iOS 16.0, *)
  private func findImageAnalysisInteraction() -> ImageAnalysisInteraction? {
    let interaction = self.imageView?.interactions.first {
      return $0 is ImageAnalysisInteraction
    }
    return interaction as? ImageAnalysisInteraction
  }

  private func clean() {
    self.imageView = nil
    self.mySub = nil
  }

  deinit {
    self.clean()
  }

}
