//
//  Photo.swift
//  ImageFeed
//
//  Created by big stepper on 02/09/2024.
//

import Foundation


struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: URLSResult
}


struct Photo {
  let id: String
  let size: CGSize
  let createdAt: Date?
  let welcomeDescription: String?
  let thumbImageURL: String
  let largeImageURL: String
  var isLiked: Bool
  let thumbSize: CGSize
}


struct URLSResult: Decodable {
    let full: String
    let small: String
}


struct LikeResult: Decodable {
    let likedByUser: Bool
}


struct Like: Decodable {
    let isLiked: LikeResult
}
