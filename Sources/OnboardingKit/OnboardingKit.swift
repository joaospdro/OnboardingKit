import UIKit

public protocol OnboardingKitDelegate: AnyObject {
    func nextButtonDidTap(atIndex index: Int)
    func getStartedButtonDidTap()
}

public class OnboardingKit {
    
    private let themeFont: UIFont
    private let slides: [Slide]
    private let tintColor: UIColor
    private var rootVC: UIViewController?
    
    public weak var delegate: OnboardingKitDelegate?
    
    private lazy var onboardingViewController: OnboardingViewController = {
        let controller = OnboardingViewController(slides: slides, tintColor: tintColor, themeFont: themeFont)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.nextButtonDidTap = { [weak self] index in
            self?.delegate?.nextButtonDidTap(atIndex: index)
        }
        controller.getStartedButtonDidTap = { [weak self] in
            self?.delegate?.getStartedButtonDidTap()
        }
        return controller
    }()
    
    public init(slides: [Slide],
                tintColor: UIColor,
                themeFont: UIFont = UIFont(name: "ArialRoundedMTBold", size: 28) ?? UIFont.boldSystemFont(ofSize: 16)) {
        self.slides = slides
        self.tintColor = tintColor
        self.themeFont = themeFont
    }
    
    public func launchOnboarding(rootVC: UIViewController) {
        self.rootVC = rootVC
        rootVC.present(onboardingViewController, animated: true, completion: nil)
    }
    
    public func dismissOnboarding() {
        onboardingViewController.stopAnimation()
        if rootVC?.presentedViewController == onboardingViewController {
            onboardingViewController.dismiss(animated: true)
        }
    }
}
