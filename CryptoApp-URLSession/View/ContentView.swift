//
//  ContentView.swift
//  CryptoApp-URLSession
//
//  Created by Ejder Dağ on 28.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var coinViewModel = CoinViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(coinViewModel.coins) { coin in
                    CoinRowView(coin: coin)
                }
            }
            .navigationTitle("Crytpo Live Prices")
        }
    }
}

#Preview {
    ContentView()
}
