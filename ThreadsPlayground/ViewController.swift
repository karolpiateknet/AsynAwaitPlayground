//
//  ViewController.swift
//  ThreadsPlayground
//
//  Created by Karol P on 16/12/2021.
//

import UIKit

final class ViewController: UIViewController {
    private let cryptoCurrenciesManager = CryptoCurrenciesManager(
        appRepository: MockedAppRepository()
    )

    @IBAction func asyncAwaitButtonTapped(_ sender: Any) {
        Task {
            let result = await cryptoCurrenciesManager.newFetchAll()
            print(result)
        }
    }

    @IBAction func gcdButtonTapped(_ sender: Any) {
        cryptoCurrenciesManager.fetchAll(
            completionHandler: { result in
                print(result)
            }
        )
    }
}


