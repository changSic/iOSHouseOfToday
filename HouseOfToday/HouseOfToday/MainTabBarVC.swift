//
//  MainTabBarVC.swift
//  HouseOfToday
//
//  Created by CHANGGUEN YU on 10/07/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

/*
 Custom Tab bar 
*/
final class MainTabBarVC: UITabBarController {

  static var tabBarHeight: CGFloat = 0

  private var isShowUserActivityView = false
  private var didSelectedTabBarItemIndex = 0

  private let homeVC = UINavigationController(rootViewController: HomeVC())
  private let storeVC = UINavigationController(rootViewController: StoreVC())
  private let expertVC = UINavigationController(rootViewController: ExpertVC())
  private let myPageVC = UINavigationController(rootViewController: MyPageVC())
  private let addUserActivityVC = AddUserActivityVC()

  private lazy var addUserActivityButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "addPostsSeleted"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    button.showsTouchWhenHighlighted = true
    button.addTarget(self, action: #selector(clickedUserActivityButton(_:)), for: .touchUpInside)
    button.isHighlighted = false
    if let lastSubView = tabBar.subviews.last { // tabbar subviews 중 last subview에 버튼을 add한다
      lastSubView.addSubview(button)
    }
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    tabBar.backgroundColor = .white
    setupTabBarItems()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    // get safetabbar height
    MainTabBarVC.tabBarHeight = view.safeAreaInsets.bottom
    print("MainTabBarVC.tabBarHeight", MainTabBarVC.tabBarHeight)
  }

  deinit {
    print("MainTabBarVC is Deinit")

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("MainTabBarVC will disappear")
    self.selectedIndex = 0
  }

  // setupTabBarItems: tabbarItem Image 연결
  private func setupTabBarItems() {

    homeVC.tabBarItem.image = UIImage(named: "home")
    storeVC.tabBarItem.image = UIImage(named: "store")
    expertVC.tabBarItem.image = UIImage(named: "expert")
    myPageVC.tabBarItem.image = UIImage(named: "myPage")
    addUserActivityVC.tabBarItem.image = UIImage(named: "1addPostsSeleted")

    viewControllers = [homeVC, storeVC, expertVC, myPageVC, addUserActivityVC]

    if let items = tabBar.items {
      for tabBarItem in items {
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
      }
    }
    self.tabBar.unselectedItemTintColor = UIColor.lightGray
  }

  // viewDidLayoutSubviews: Layout이 다 잡힌후에 호출되는 function
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if tabBar.subviews.count == 5, addUserActivityButton.translatesAutoresizingMaskIntoConstraints {
      addUserActivityButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }

  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    didSelectedTabBarItemIndex = tabBar.items?.firstIndex(of: item) ?? selectedIndex
  }

  // clickedUserActivityButton: tabbar button 클릭시 호출
  @objc private func clickedUserActivityButton(_ sender: UIButton) {
    if getAnimationButtonStatus() == false {
      showActivityVC()
    } else {
      hideActivityVC()
    }

    isShowUserActivityView.toggle()
  }

  // showActivityVC: 현재 tabbar가 띄운 뷰 컨트롤러에서 present showAnimateVC 진행
  private func showActivityVC() {
    UIView.animate(withDuration: 0.5) {
      self.addUserActivityButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4.0))
    }
    // show
    viewControllers?[selectedIndex].showAnimateVC()

    // selected tabbar color setting
    self.tabBar.tintColor = .darkGray
  }

  // hideActivityVC: 현재 tabbar가 띄운 뷰 컨트롤러에서 dismiss
  private func hideActivityVC(completion: (() -> Void)? = nil ) {

    UIView.animate(withDuration: 0.3, animations: {
      self.addUserActivityButton.transform = .identity
    }) { _ in
      completion?()
    }

    // hide
    if let viewController = viewControllers?[selectedIndex].presentedViewController as? AddUserActivityVC {
      viewController.customDismiss()
    }
    // selected tabbar color setting
    self.tabBar.tintColor = #colorLiteral(red: 0, green: 0.4795769453, blue: 1, alpha: 1)
  }

  // getAnimationButtonStatus: adduserActivityButton 상태 반환
  // return: true -> button 이 선택되어 있는 상태
  private func getAnimationButtonStatus() -> Bool {
    return addUserActivityButton.transform != .identity
  }

  private lazy var cartImageView: UIImageView = {
    let iv = UIImageView(image: UIImage(named: "whiteCart"))
    iv.backgroundColor = .black
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.layer.cornerRadius = UIScreen.main.bounds.width / 4
    view.addSubview(iv)
    view.sendSubviewToBack(iv)
    return iv
  }()
  // MARK: -
  public func showCartView() {

    print("showCartView")
    view.bringSubviewToFront(cartImageView)
    //    cartView.isHidden
    UIView.animateKeyframes(withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: { [weak self] in
                              UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: { [weak self] in
                                if let cartView = self?.cartImageView {
                                  cartView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                }
                                self?.view.layoutIfNeeded()
                              })

                              UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: { [weak self] in

                                if let cartView = self?.cartImageView {
                                  cartView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                                }

                                self?.view.layoutIfNeeded()
                              })
    }) { [weak self] _ in
      guard let cartView = self?.cartImageView else { return }

      self?.view.bringSubviewToFront(cartView)
    }

  }
}

extension MainTabBarVC: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

    if getAnimationButtonStatus() {

      hideActivityVC { // dissmiss activityVC
        tabBarController.selectedIndex = self.didSelectedTabBarItemIndex
      }
      return false      // false: 자동으로 반응을 하지 않도록 한다.
    }
    return true
  }
}

extension UIViewController {
  func showAnimateVC() {
    let vc = AddUserActivityVC()
    self.definesPresentationContext = true
    vc.modalPresentationStyle = .overCurrentContext
    self.present(vc, animated: false)
  }
}
