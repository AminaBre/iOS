//
//  UserInfo.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 21/10/2021.
//

import Foundation
import UIKit



struct Image {
    let image: UIImage
}

// MARK: - Welcome
struct UserInfo: Decodable {
    let results: [Result]
    let info: Info

}

// MARK: - Info
struct Info: Decodable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
struct Result: Decodable {
    let gender: String
    let name: Name
    let picture: Picture
    let dob: Dob
    let location: Location
    let email: String
    let phone: String
    
    static let database = DatabaseHandler.shared
    func store(){
        guard let user = Result.database.add(User.self) else { return }
        user.gender = gender
        user.first_name = name.first
        user.last_name = name.last
        user.picture_large = picture.large
        user.picture_thumbnail = picture.thumbnail
        user.age = Int16(dob.age)
        user.date = dob.date
        user.city = location.city
        user.state =  location.state
        //user.postcode = type(location.postcode) == String ? user.postcode = location.postcode : String(location.postcode)
        //user.postcode_string = String(location.postcode)
        user.email = email
        user.phone = phone
        Result.database.save()
    }
}

// MARK: - Dob
struct Dob: Decodable {
    let date: String
    let age: Int
}

// MARK: - ID
struct ID: Decodable {
    let name: String
}

enum DecodingError: Error {
  case missingValue
}

enum PostCode: Decodable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
      if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
        self = .int(intValue)
        return
      }
      if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
        self = .string(stringValue)
        return
      }
      throw DecodingError.missingValue
    }
}

// MARK: - Location
struct Location: Decodable {
    let street: Street
    let city, state, country: String
    let coordinates: Coordinates
    let timezone: Timezone
    let postcode: PostCode
    
  
    
}

// MARK: - Coordinates
struct Coordinates: Decodable {
    let latitude, longitude: String
}

// MARK: - Street
struct Street: Decodable {
    let number: Int
    let name: String
}

// MARK: - Timezone
struct Timezone: Decodable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}

// MARK: - Login
struct Login: Decodable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
struct Name: Decodable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Decodable {
    let large, medium, thumbnail: String
}

