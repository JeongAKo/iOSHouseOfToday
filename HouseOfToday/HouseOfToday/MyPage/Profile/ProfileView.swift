//
//  ProfileView.swift
//  HouseOfToday
//
//  Created by Daisy on 16/07/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

final class ProfileView: UIView {

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .lightGray
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    return refreshControl
  }()

  @objc func reloadData() {
    tableView.refreshControl?.endRefreshing()  // 계속 안돌아가게 설정
    tableView.reloadData()
  }

  internal lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self.self
    tableView.delegate = self.self
    tableView.register(cell: ProfileUserCell.self)
    tableView.register(cell: MyshoppingThumbCell.self)
    tableView.register(cell: ProfilePicTableViewCell.self)
    tableView.register(cell: ProfileBaseCell.self)
    tableView.showsVerticalScrollIndicator = false
    tableView.allowsSelection = false
    tableView.refreshControl = refreshControl

    addSubview(tableView)
    return tableView
  }()

  internal var profileData: (URL, String)? {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  internal var profileViewDidScroll: ((String) -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)

    tableViewAutoLayout()
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //fetchAccountList()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Networking
  private func fetchAccountList() {
    // MARK: - Networking
    if let tokenInfo = UserDefaults.standard.object(forKey: "tokenInfo") as? [String: String],
      let token = tokenInfo["token"] {
      DataManager.shard.service.fetchAccountList(with: token) {
        result in
        switch result {
        case .success(let socialUser):
          let user = socialUser.first!
          let url = URL(string: user.profileImageUrlStr)
          self.profileData = (url!, user.nickName)

        case .failure(let error):
          logger(error.localizedDescription)
        }
      }
    } else {
      logger("token is nothing")

    }
  }

  private func tableViewAutoLayout() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

extension ProfileView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.row {
    //유저 정보
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUserCell.identifier, for: indexPath) as! ProfileUserCell
      if let profileData = self.profileData {
        DispatchQueue.main.async {
          cell.userImageButton.kf.setImage(with: profileData.0, for: .normal)
          cell.userNameLabel.text = profileData.1
        }
      } else {
        cell.userImageButton.setImage(UIImage(named: "userImage"), for: .normal)
        cell.userNameLabel.text = "사용자"
      }
      cell.separatorInset = UIEdgeInsets.zero
      return cell

    //나의 쇼핑
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: MyshoppingThumbCell.identifier, for: indexPath) as! MyshoppingThumbCell
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    //사진

    case 2: // FIXME: - 높이 유동적으로 상태에 따라 설정
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileBaseCell.identifier, for: indexPath) as! ProfileBaseCell
      cell.setLabelItems(title: .picture)

      if indexPath.row == 2 {
        cell.rightSideCellButton.isEnabled = false
      } else {
        cell.rightSideCellButton.isEnabled = true
      }

      cell.separatorInset = UIEdgeInsets.zero
      return cell

    //집들이
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileBaseCell.identifier, for: indexPath) as! ProfileBaseCell
      cell.setLabelItems(title: .houseWarming, subTitle: "0", orderCount: "0", point: "0")
      cell.separatorInset = UIEdgeInsets.zero
      return cell

    //리뷰쓰기
    case 4:
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileBaseCell.identifier, for: indexPath) as! ProfileBaseCell
      cell.setLabelItems(title: .reviewWriting)
      cell.separatorInset = UIEdgeInsets.zero
      return cell

    //리뷰
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: ProfileBaseCell.identifier, for: indexPath) as! ProfileBaseCell
      cell.setLabelItems(title: .review, subTitle: "0", orderCount: "0", point: "0")
      cell.separatorInset = UIEdgeInsets.zero
      return cell

    }

  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return 230
    case 1:
      return 100

    default:
      return 80

    }

  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let callback = profileViewDidScroll else { return logger("Callback Error") }
    if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
      callback("up")
    } else {
      callback("down")
    }
  }
}
