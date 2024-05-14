import ExpoModulesCore
import UIKit
import Vision
import VisionKit

class ExpoLiveTextView: ExpoView {

  @available(iOS 16.0, *)
  static let imageAnalyzer = ImageAnalyzer.isSupported ? ImageAnalyzer() : nil

  private var mySub: Any? = nil
  private var imageView: UIImageView? = nil
  private let attempts: Int = 2

  // MARK: - Events

  let onStart = EventDispatcher()

  let onReady = EventDispatcher()

  let onError = EventDispatcher()

  // MARK: - Props

  var disabled: Bool = false {
    didSet {
      guard #available(iOS 16.0, *), oldValue != self.disabled,
        ImageAnalyzer.isSupported
      else {
        return
      }

      if self.disabled {
        if let interaction = findImageAnalysisInteraction() {
          self.imageView?.removeInteraction(interaction)
          self.clean()
        }
      } else {
        self.analyzeImage(attempts: self.attempts)
      }
    }
  }

  // MARK: - View

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    clipsToBounds = true
  }

  override func didMoveToWindow() {
    if #available(iOS 16.0, *), !self.disabled {
      self.analyzeImage(attempts: self.attempts)
    }
  }

  deinit {
    self.clean()
  }

  // MARK: - Implementation

  private func analyzeImage(attempts: Int) {
    guard #available(iOS 16.0, *),
      ImageAnalyzer.isSupported
    else {
      return
    }

    if attempts == 0 {
      // Handle the case when imageView is still nil after several attempts
      self.handleAnalysisError(errorMsg: "Failed to initialize imageView.")
      return
    }

    if let imageView = self.subviews.first?.subviews.first as? UIImageView {
      self.imageView = imageView

      if let imageView = self.imageView {
        let interaction = ImageAnalysisInteraction()
        imageView.addInteraction(interaction)
      }

      self.attachAnalyzerToImage()

      self.mySub = imageView.observe(\.image, options: [.new]) { _, _ in
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
      self.handleAnalysisError(errorMsg: "Failed to initialize imageView.")
      return
    }

    self.onStart()

    Task {
      guard let imageAnalyzer = Self.imageAnalyzer,
        let imageAnalysisInteraction = self.findImageAnalysisInteraction()
      else {
        self.handleAnalysisError(errorMsg: "Failed to initialize imageAnalysisInteraction.")
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
        self.handleAnalysisError(errorMsg: error.localizedDescription)
      }
    }
  }

  @available(iOS 16.0, *)
  private func findImageAnalysisInteraction() -> ImageAnalysisInteraction? {
    let interaction = self.imageView?.interactions.first {
      $0 is ImageAnalysisInteraction
    }
    return interaction as? ImageAnalysisInteraction
  }

  private func clean() {
    self.imageView = nil
    self.mySub = nil
  }

  private func handleAnalysisError(errorMsg: String) {
    print(errorMsg)
    self.onError([
      "error": errorMsg
    ])
  }

}
