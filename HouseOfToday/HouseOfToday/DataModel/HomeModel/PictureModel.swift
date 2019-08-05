//
//  File.swift
//  HouseOfToday
//
//  Created by Daisy on 05/08/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation

struct PictureModel: Decodable {

  let id: Int
  let author: String
  let image: String
  let hitCount: Int
  let likeCount: Int
  let scrapCount: Int
  let commentCount: Int
  let text: String
  let comments: [CommentsInfo]

  enum CodingKeys: String, CodingKey {
    case id
    case author
    case image
    case hitCount = "hit_count"
    case likeCount = "like_count"
    case scrapCount = "scrap_count"
    case commentCount = "comment_count"
    case text
    case comments
  }

  struct CommentsInfo: Decodable {
    let authorProfileImage: String
    let author: String
    let text: String

    enum CodingKeys: String, CodingKey {
      case  authorProfileImage = "author_profile_image"
      case  author
      case  text

    }
  }
}
