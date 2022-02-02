//
//  Post.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 25.01.22.
//

import Foundation
import SwiftUI

struct Post: Hashable, Codable {
    var id: Int
    var recordName: String
    var imageName: String?
}
