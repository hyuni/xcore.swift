//
// Numbers+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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

import Foundation

// MARK: Int

extension Int {
    private static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.paddingPosition = .beforePrefix
        numberFormatter.paddingCharacter = "0"
        return numberFormatter
    }()

    public func pad(by amount: Int) -> String {
        Int.numberFormatter.minimumIntegerDigits = amount
        return Int.numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension Int {
    /// Returns an `Array` containing the results of mapping `transform`
    /// over `self`.
    ///
    /// - complexity: O(N).
    ///
    /// ```swift
    /// let values = 10.map { $0 * 2 }
    /// print(values)
    ///
    /// // prints
    /// [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
    /// ```
    public func map<T>(transform: (Int) throws -> T) rethrows -> [T] {
        var results = [T]()
        for i in 0..<self {
            try results.append(transform(i + 1))
        }
        return results
    }
}

extension SignedInteger {
    public var digitsCount: Self {
        return numberOfDigits(in: self)
    }

    private func numberOfDigits(in number: Self) -> Self {
        if abs(number) < 10 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number / 10)
        }
    }
}

extension FloatingPoint {
    public static var pi2: Self {
        return .pi / 2
    }

    public static var pi4: Self {
        return .pi / 4
    }
}

extension Double {
    // Adopted from: http://stackoverflow.com/a/35504720
    private static let abbrevationNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()

    private typealias Abbrevation = (suffix: String, threshold: Double, divisor: Double)

    // swiftlint:disable comma comma_space double_space
    private static let abbreviations: [Abbrevation] = [
       ("",                0,              1),
       ("K",           1_000,          1_000),
       ("K",         100_000,          1_000),
       ("M",         499_000,      1_000_000),
       ("M",     999_999_999,     10_000_000),
       ("B",   1_000_000_000,  1_000_000_000),
       ("B", 999_999_999_999, 10_000_000_000)
    ]
    // swiftlint:enable comma comma_space double_space

    /// Abbreviate `self` to smaller format.
    ///
    /// ```swift
    /// 987     // -> 987
    /// 1200    // -> 1.2K
    /// 12000   // -> 12K
    /// 120000  // -> 120K
    /// 1200000 // -> 1.2M
    /// 1340    // -> 1.3K
    /// 132456  // -> 132.5K
    /// ```
    ///
    /// - Parameter threshold: An optional property to only apply abbreviation
    ///                        if `self` is greater then given threshold.
    ///                        The default value is `nil`.
    /// - Returns: Abbreviated version of `self`.
    public func abbreviate(threshold: Double? = nil) -> String {
        if let threshold = threshold, self <= threshold {
            return "\(self)"
        }

        let startValue = abs(self)

        let abbreviation: Abbrevation = {
            var prevAbbreviation = Double.abbreviations[0]

            for tmpAbbreviation in Double.abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = self / abbreviation.divisor
        Double.abbrevationNumberFormatter.positiveSuffix = abbreviation.suffix
        Double.abbrevationNumberFormatter.negativeSuffix = abbreviation.suffix
        return Double.abbrevationNumberFormatter.string(from: NSNumber(value: value)) ?? "\(self)"
    }

    private static let testValues: [Double] = [598, -999, 1000, -1284, 9940, 9980, 39900, 99880, 399880, 999898, 999999, 1456384, 12383474, 987, 1200, 12000, 120000, 1200000, 1340, 132456, 9_000_000_000, 16_000_000, 160_000_000, 999_000_000]
}

extension Sequence where Iterator.Element == Double {
    /// ```swift
    /// [1, 1, 1, 1, 1, 1].runningSum() // -> [1, 2, 3, 4, 5, 6]
    /// ```
    public func runningSum() -> [Iterator.Element] {
        return self.reduce([]) { sums, element in
            return sums + [element + (sums.last ?? 0)]
        }
    }
}

extension Double {
    public init?(_ value: Any?) {
        guard let value = value else {
            return nil
        }

        if let string = value as? String {
            self.init(string)
            return
        }

        if let integer = value as? Int {
            self.init(integer)
            return
        }

        if let double = value as? Double {
            self.init(double)
            return
        }

        if let cgfloat = value as? CGFloat {
            self.init(cgfloat)
            return
        }

        if let float = value as? Float {
            self.init(float)
            return
        }

        if let int64 = value as? Int64 {
            self.init(int64)
            return
        }

        if let int32 = value as? Int32 {
            self.init(int32)
            return
        }

        if let int16 = value as? Int16 {
            self.init(int16)
            return
        }

        if let int8 = value as? Int8 {
            self.init(int8)
            return
        }

        if let uInt = value as? UInt {
            self.init(uInt)
            return
        }

        if let uInt64 = value as? UInt64 {
            self.init(uInt64)
            return
        }

        if let uInt32 = value as? UInt32 {
            self.init(uInt32)
            return
        }

        if let uInt16 = value as? UInt16 {
            self.init(uInt16)
            return
        }

        if let uInt8 = value as? UInt8 {
            self.init(uInt8)
            return
        }

        return nil
    }
}
