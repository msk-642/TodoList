//
//  Todo.swift
//  TodoList
//
//  Created by MSK on 2026/01/29.
//

import Foundation

struct Todo: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var text: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}
