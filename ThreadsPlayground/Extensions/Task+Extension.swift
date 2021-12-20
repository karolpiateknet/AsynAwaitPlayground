//
//  Task+Extension.swift
//  ThreadsPlayground
//
//  Created by Karol P on 18/12/2021.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(milliseconds duration: Int) async throws {
        try await Task.sleep(nanoseconds: UInt64(duration) * 1_000_000)
    }
}
