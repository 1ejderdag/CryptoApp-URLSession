//
//  CoinViewModel.swift
//  CryptoApp-URLSession
//
//  Created by Ejder Dağ on 28.04.2025.
//

import Foundation

class CoinViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    var timer: Timer?
    
    let BASE_URL = "https://api.coingecko.com/api/v3/coins/"
    
    var urlString: String {
        return "\(BASE_URL)markets?vs_currency=try&order=market_cap_desc&per_page=50&page=1&price_change_percentage=24h"
    }
    
    init() {
        fetchCoinsWithURLSession()
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
}

// MARK: - URLSession

extension CoinViewModel {
    
    func fetchCoinsWithURLSession() {
        guard let url = URL(string: urlString) else {
            print("DEBUG: Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return } // uygulama kapanmışsa işlemlerin devam etmesini engeller.
            
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Error \(error)")
                    return
                }
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    print("DEBUG: Server error")
                    return
                }
                
                guard let data = data else {
                    print("DEBUG: Invalid data")
                    return
                }
                
                guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                    print("DEBUG: Invalid data")
                    return
                }
                
                self.coins = coins
            }
        }.resume()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            self.fetchCoinsWithURLSession()
        }
    }
}



