//
//  MockedAppRepository.swift
//  ThreadsPlayground
//
//  Created by Karol P on 18/12/2021.
//

import Foundation

final class MockedAppRepository {
    private var randomDelay: Int {
        Int.random(in: (100...300))
    }

    private let cryptoCurrencies: [String: Double] = [
        "IOTA": 1.17,
        "BTC": 48_578.74,
        "DOGE": 0.4,
        "ETH": 4100,
        "SHIB": 0.0003
    ]
}

// MARK: - AppRepository

extension MockedAppRepository: AppRepository {
    func getCryptoCurrencies(completion: @escaping ([String]) -> Void) {
        let result: [String] = Array(cryptoCurrencies.keys)
        DispatchQueue.global(qos: .background)
            .asyncAfter(deadline: .now() + .milliseconds(randomDelay)) {
                completion(result)
            }
    }

    func getValue(of cryptoCurrency: String, completion: @escaping (Double?) -> Void) {
        DispatchQueue.global(qos: .background)
            .asyncAfter(deadline: .now() + .milliseconds(randomDelay)) {
                completion(self.cryptoCurrencies[cryptoCurrency])
            }
    }

    func asyncGetCryptoCurrencies() async -> [String] {
        try? await Task.sleep(milliseconds: randomDelay)
        return Array(cryptoCurrencies.keys)
    }

    func asyncGetValue(of cryptoCurrency: String) async -> Double? {
        try? await Task.sleep(milliseconds: randomDelay)
        return cryptoCurrencies[cryptoCurrency]
    }
}
