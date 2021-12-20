//
//  ThreadSafeDictionary.swift
//  ThreadsPlayground
//
//  Created by Karol P on 16/12/2021.
//

import Foundation

/// TODO Opisz czemu taka jest implementacja:
/// https://stackoverflow.com/questions/46579268/dispatchqueue-barrier-issue
/// https://stackoverflow.com/questions/66449221/dispatchqueue-barrier-not-working-as-expected
/// 

final class ThreadSafeDictionary<Key: Hashable, Value>: Collection {
    typealias DictionaryType = Dictionary<Key, Value>
    typealias Indices = DictionaryType.Indices
    typealias Iterator = DictionaryType.Iterator
    typealias SubSequence = DictionaryType.SubSequence
    typealias Index = DictionaryType.Index

    private(set) var dictionary: [Key: Value] = [:]

    private let queue: DispatchQueue

    private let dispatchGroup: DispatchGroup

    init(label: String, dispatchGroup: DispatchGroup) {
        self.queue = DispatchQueue(
            label: label,
            qos: .background,
            attributes: .concurrent
        )
        self.dispatchGroup = dispatchGroup
    }

    var startIndex: Index {
        queue.sync {
            dictionary.startIndex
        }
    }

    var endIndex: DictionaryType.Index {
        queue.sync {
            dictionary.endIndex
        }
    }

    var indices: Indices {
        queue.sync {
            dictionary.indices
        }
    }

    subscript(position: Index) -> Iterator.Element {
        queue.sync {
            dictionary[position]
        }
    }

    subscript(bounds: Range<Index>) -> SubSequence {
        queue.sync {
            dictionary[bounds]
        }
    }

    subscript(key: Key) -> Value? {
        get {
            queue.sync {
                dictionary[key]
            }
        }
        set {
            queue.async(group: dispatchGroup, flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }

    func index(after i: Index) -> Index {
        queue.sync {
            dictionary.index(after: i)
        }
    }

    func makeIterator() -> DictionaryIterator<Key, Value> {
        queue.sync {
            dictionary.makeIterator()
        }
    }
}
