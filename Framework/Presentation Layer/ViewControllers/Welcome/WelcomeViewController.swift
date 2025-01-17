//
//  WelcomeViewController.swift
//  IdentHubSDK
//

import UIKit

/// Class for managing welcome screen UI components
/// Class based on SolarisViewController, because used company copyrights view
class WelcomeViewController: UIViewController {

    // MARK: - Properties -
    @IBOutlet var pageController: UIPageControl!
    @IBOutlet var pageScroller: UICollectionView!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var logoFrame: UIImageView!
    @IBOutlet var startBtn: UIButton!

    private var viewModel: WelcomeViewModel!
    private lazy var logoAnimator: WelcomeLogoAnimator = {
        return WelcomeLogoAnimator(logoImage, logoFrameImage: logoFrame)
    }()

    // MARK: - Init methods -

    /// Initialized with view model object
    /// - Parameter viewModel: view model object
    init(_ viewModel: WelcomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: "WelcomeViewController", bundle: Bundle(for: WelcomeViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Internal methods -

    private func configureUI() {

        pageController.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }

        viewModel.configurePageScroller(pageScroller)
        viewModel.setPageController(pageController)
        viewModel.setLogoAnimator(logoAnimator)
    }

    // MARK: - Actions methods -

    @IBAction func didClickStartBtn(_ sender: UIButton) {
        viewModel.didTriggerStart()
    }
}
