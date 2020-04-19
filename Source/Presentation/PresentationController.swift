import UIKit

class PresentationController: UIPresentationController {

    private let dimmingView = UIView()

    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?)
    {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        if #available(iOS 13.0, *) {
            self.dimmingView.backgroundColor = UIColor { traitCollection in
                return UIColor(white: 0, alpha: traitCollection.userInterfaceStyle == .dark ? 0.48 : 0.2)
            }
        } else {
            self.dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        self.presentingViewController.view.tintAdjustmentMode = .dimmed
        self.dimmingView.alpha = 0

        self.containerView?.addSubview(self.dimmingView)

        let coordinator = self.presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { _ in self.dimmingView.alpha = 1 }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        self.presentingViewController.view.tintAdjustmentMode = .automatic

        let coordinator = self.presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { _ in self.dimmingView.alpha = 0 }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerView = self.containerView {
            self.dimmingView.frame = containerView.frame
        }
    }
}
