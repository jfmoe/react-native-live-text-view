import ExpoModulesCore
import UIKit
import Vision
import VisionKit

class ExpoLiveTextView: ExpoView {

  private var mySub: Any? = nil
  private var imageView: UIImageView? = nil

  @available(iOS 16.0, *)
  static let imageAnalyzer = ImageAnalyzer.isSupported ? ImageAnalyzer() : nil

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    clipsToBounds = true
  }

  override func didMoveToWindow() {
    if #available(iOS 16.0, *) {
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
      }
    }

  }

  @available(iOS 16.0, *)
  func attachAnalyzerToImage() {
    guard let image = self.imageView?.image else {
      return
    }

    Task {
      guard let imageAnalyzer = Self.imageAnalyzer,
        let imageAnalysisInteraction = findImageAnalysisInteraction()
      else {
        return
      }

      let configuration = ImageAnalyzer.Configuration([.text])

      do {
        let analysis = try await imageAnalyzer.analyze(image, configuration: configuration)

        DispatchQueue.main.async {
          imageAnalysisInteraction.analysis = analysis
          imageAnalysisInteraction.preferredInteractionTypes = .automatic
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

  deinit {
    self.imageView = nil
    self.mySub = nil
  }

}
