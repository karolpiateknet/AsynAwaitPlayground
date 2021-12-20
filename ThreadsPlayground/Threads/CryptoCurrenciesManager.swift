//
//  CryptoCurrenciesManager.swift
//  ThreadsPlayground
//
//  Created by Karol P on 16/12/2021.
//

import Foundation

final class CryptoCurrenciesManager {

    private let appRepository: AppRepository

    /// Initialize CryptoCurrenciesManager.
    /// - Parameters:
    ///   - appRepository: class responsible for fetching crypto currencies.
    init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    func fetchAll(completionHandler: @escaping ([String: Double]) -> Void) {
        let group = DispatchGroup()

        let result = ThreadSafeDictionary<String, Double>(
            label: "ThreadSafeDictionary",
            dispatchGroup: group
        )

        appRepository.getCryptoCurrencies { [weak self] cryptoCurrencies in
            for crypto in cryptoCurrencies {
                group.enter()
                self?.appRepository.getValue(of: crypto) { value in
                    result[crypto] = value
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                let dictionary = result.dictionary
                completionHandler(dictionary)
            }
        }
    }

    func newFetchAll() async -> [String: Double] {
        var result: [String: Double] = [:]

        let cryptoCurrencies = await appRepository.asyncGetCryptoCurrencies()

        await withTaskGroup(of: Crypto.self) { group in
            for crypto in cryptoCurrencies {
                group.addTask {
                    let value = await self.appRepository.asyncGetValue(of: crypto)
                    return Crypto(name: crypto, value: value)
                }
            }

            for await crypto in group {
                result[crypto.name] = crypto.value
            }
        }

        return result
    }
}

struct Crypto {
    let name: String
    let value: Double?
}
