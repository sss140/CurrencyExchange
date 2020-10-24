//
//  FetchData.swift
//  CurrencyExchange
//
//  Created by 佐藤一成 on 2020/10/24.
//

import SwiftUI

class FetchData:ObservableObject{
    @Published var conversionData:[Currency] = []
    
    init(){
        fetch()
    }
    
    
    func fetch(base:String = "USD"){
        let urlString:String = "https://api.exchangeratesapi.io/latest?base=\(base)"
        
        //let session = URLSession(configuration: .default)
        
        URLSession(configuration: .default).dataTask(with: URL(string: urlString)!){(data,response,error) in
            guard let data = data, error==nil else{
                return
            }
            
            do{
                let conversion = try JSONDecoder().decode(Conversion.self, from: data)
                DispatchQueue.main.async {
                    self.conversionData = conversion.rates.compactMap{ (key,value) -> Currency? in
                        return Currency(currencyName: key, currencyValue: value)
                    }
                }
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
