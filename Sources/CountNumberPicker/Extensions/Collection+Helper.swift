//
//  Collection+Helper.swift
//  CountNumberPicker
//
//  Created by Dmitry Anokhin on 23.11.2020.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
