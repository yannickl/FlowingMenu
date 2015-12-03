//
//  User.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 02/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import Foundation
import UIKit

struct User {
  let id: Int
  let firstname: String
  let lastname: String
  let newMessage: Bool

  func displayName() -> String {
    return "\(firstname) \(lastname)"
  }

  func avatarImage() -> UIImage? {
    return UIImage(named: "\(id)")
  }
}

extension User {
  // Data taken from https://randomuser.me/
  static func dummyUsers() -> [User] {
    return [
      User(id: 79, firstname: "Noelia", lastname: "Marin", newMessage: true),
      User(id: 1, firstname: "Enrique", lastname: "Santos", newMessage: true),
      User(id: 63, firstname: "Roberto", lastname: "Crespo", newMessage: true),
      User(id: 52, firstname: "Veronica", lastname: "Cortes", newMessage: true),
      User(id: 47, firstname: "Nerea", lastname: "Alonso", newMessage: false),
      User(id: 27, firstname: "Silvia", lastname: "Herrero", newMessage: false),
      User(id: 4, firstname: "Susana", lastname: "Aguilar", newMessage: false),
      User(id: 89, firstname: "Alejandro", lastname: "Moya", newMessage: false),
      User(id: 5, firstname: "Inmaculada", lastname: "Cortes", newMessage: false),
      User(id: 15, firstname: "Teresa", lastname: "Saez", newMessage: false),
      User(id: 37, firstname: "Lorenzo", lastname: "Vicente", newMessage: false),
      User(id: 92, firstname: "Joel", lastname: "Mattila", newMessage: false)
    ]
  }
}