//
//  Note.swift
//  Notebook
//
//  Created by kirsty darbyshire on 18/04/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation

struct Note: Codable, Equatable {
    var title: String
    var text: String
    var dateCreated: Date
    var uuid: String
}
