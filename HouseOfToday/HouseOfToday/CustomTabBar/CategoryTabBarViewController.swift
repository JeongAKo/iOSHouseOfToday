//
//  CategoryTabBarViewController.swift
//  HouseOfToday
//
//  Created by chang sic jung on 10/07/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import SnapKit
/// 목표
/// 카테고리의 개수를 설정하고, 그 개수에 따라 유동적으로 카테고리를 만들어야 한다.

class CategoryTabBarViewController: UIViewController {

  // MARK: - CategoryTabBarViewController 를 초기화할때 설정 값들
  /// 카테고리를 설정할 때 얘를 설정한다.
  private var categoryTitles = ["프로필", "나의 쇼핑", "테스트"]

  /// 카테고리가 일정 수 넘어가면 true 로 설정해서 카테고리를 움직일 수 있게 한다.
  private var categoryTabBarScrollIsEnabled: Bool = true

  init(_ categoryTitles: [String], _ tabBarScrollIsEnabled: Bool ) {
    super.init(nibName: nil, bundle: nil)
    self.categoryTitles = categoryTitles
    self.categoryTabBarScrollIsEnabled = tabBarScrollIsEnabled
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  // MARK: - 변수선언
  private lazy var categoryView: CategoryView = {
    let cv = CategoryView()
    view.addSubview(cv)
    return cv
  }()

  private lazy var categoryTabBarView: CategoryTabBarView = {
    let ctv = CategoryTabBarView()
    ctv.categoryTitles = self.categoryTitles
    view.addSubview(ctv)
    return ctv
  }()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    categoryTabBarView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(view.snp.height).multipliedBy(0.05)
    }

    categoryView.snp.makeConstraints {
      $0.top.equalTo(categoryTabBarView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }

}
