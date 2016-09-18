//
// Section.swift
//
// Copyright © 2016 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

// Adopted: https://medium.com/swift-programming/ce22d76f120c

import Foundation

public struct ArrayIterator<Element>: IteratorProtocol {
    fileprivate let array: [Element]
    fileprivate var currentIndex = 0

    public init(_ array: [Element]) {
        self.array = array
    }

    public mutating func next() -> Element? {
        let element = array.at(currentIndex)
        currentIndex += 1
        return element
    }
}

public struct Section<Element>: RangeReplaceableCollection, MutableCollection, ExpressibleByArrayLiteral {
    public var title: String?
    public var detail: String?
    public var items: [Element]

    public init() {
        self.title  = nil
        self.detail = nil
        self.items  = []
    }

    public init(arrayLiteral elements: Element...) {
        self.items = elements
    }

    public init(title: String? = nil, detail: String? = nil, items: [Element]) {
        self.title  = title
        self.detail = detail
        self.items  = items
    }

    public let startIndex = 0
    public var endIndex: Int {
        return items.count
    }

    public subscript(index: Int) -> Element {
        get { return items[index] }
        set { items[index] = newValue }
    }

    /// Returns the position immediately after the given index.
    ///
    /// - parameter i: A valid index of the collection. `i` must be less than `endIndex`.
    /// - returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return i + 1
    }

    public func makeIterator() -> ArrayIterator<Element> {
        return ArrayIterator(items)
    }

    public mutating func replaceSubrange<C: Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Element {
        items.replaceSubrange(subRange, with: newElements)
    }
}

extension Array where Element: MutableCollection, Element.Index == Int {
    /// A convenience subscript to return the element at the specified index path.
    ///
    /// - parameter indexPath: The index path for the element.
    ///
    /// - returns: The element at the specified index path iff it is within bounds, otherwise fatalError.
    public subscript(indexPath: IndexPath) -> Element.Iterator.Element {
        get { return self[indexPath.section][indexPath.item] }
        set { self[indexPath.section][indexPath.item] = newValue }
    }
}

extension Array where Element: RangeReplaceableCollection, Element.Index == Int {
    /// Remove the element at the specified index path.
    ///
    /// - parameter indexPath: The index path for the element to remove.
    ///
    /// - returns: The removed element.
    @discardableResult
    public mutating func remove(at indexPath: IndexPath) -> Element.Iterator.Element {
        return self[indexPath.section].remove(at: indexPath.item)
    }

    /// Insert newElement at the specified index path.
    ///
    /// - parameter newElement: The new element to insert.
    /// - parameter indexPath:  The index path to insert the element at.
    public mutating func insert(_ newElement: Element.Iterator.Element, atIndexPath: IndexPath) {
        self[atIndexPath.section].insert(newElement, at: atIndexPath.item)
    }

    /// Move an element at a specific location in the `self` to another location.
    ///
    /// - parameter fromIndexPath: An index path locating the element to be moved in `self`.
    /// - parameter toIndexPath:   An index path locating the element in `self` that is the destination of the move.
    ///
    /// - returns: The moved element.
    @discardableResult
    public mutating func moveElement(fromIndexPath: IndexPath, toIndexPath: IndexPath) -> Element.Iterator.Element {
        let elementToMove = remove(at: fromIndexPath)
        insert(elementToMove, atIndexPath: toIndexPath)
        return elementToMove
    }
}
