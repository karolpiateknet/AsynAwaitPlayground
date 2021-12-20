//
//  AppRepository.swift
//  ThreadsPlayground
//
//  Created by Karol P on 16/12/2021.
//

import Foundation

protocol AppRepository {
    /// Gets list of crypto currencies.
    /// - Parameters:
    ///   - completion: function called when data has loaded.
    func getCryptoCurrencies(completion: @escaping ([String]) -> Void)

    /// Gets value of crypto currency.
    /// - Parameters:
    ///   - cryptoCurrency: Name of the crypto currency.
    ///   - completion: function called when data has loaded.
    func getValue(of cryptoCurrency: String, completion: @escaping (Double?) -> Void)

    /// Gets list of crypto currencies.
    func asyncGetCryptoCurrencies() async -> [String]

    /// Gets value of crypto currency.
    /// - Parameters:
    ///   - cryptoCurrency: Name of the crypto currency.
    func asyncGetValue(of cryptoCurrency: String) async -> Double?
}

