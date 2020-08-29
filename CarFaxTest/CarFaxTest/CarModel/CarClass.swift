//
//  ModelClass.swift
//  CarFaxTest
//
//  Created by Kalpesh Thakare on 2020-08-28.
//  Copyright © 2020 Kalpesh Thakare. All rights reserved.
//

import Foundation

struct CarClass: Decodable {
    var listings: [CarDetails]
}

struct CarDetails: Decodable {
    var images: ImageDetails

    var year: Int
    var make: String
    var model: String
    var trim: String

    var currentPrice: Int
    var mileage: Int
    var dealer: AddressDetails
}

struct ImageDetails: Decodable {
    var firstPhoto: ImageSizes?
    var baseUrl: String
}

struct ImageSizes: Decodable {
    var large: String
    var medium: String
    var small: String
}

struct AddressDetails: Decodable {
    var address: String
    var phone: String
}
