//
//  ContentView.swift
//  ConcurrencyTest
//
//  Created by cit on 15/06/22.
//
// 1 ao apertar  o botao -  a ui vai ficar travada calculando la os numeros


import SwiftUI

struct ContentView: View {
        
    var body: some View {
        VStack{
            Spacer()
            DatePicker(selection: .constant(Date()), label: { Text("Date")})
                .labelsHidden()
            Button(action: calculatePrime, label: { Text("Calculate Primes")})
            Spacer()
        }
    }
    
    func calculatePrime(){
        
        let queue = OperationQueue()
        queue.addOperation{
            for number in 0...1_000_000 {
                let isPrimeNumber = isPrime(number: number)
                print("\(number) is prime: \(isPrimeNumber)")
            }
        }
        
        func isPrime(number: Int)-> Bool{
            if number <= 1 {
                return false
            }
            if number <= 3 {
                return false
            }
            var i = 2
        
            while i * i <= number {
                if number % i == 0{
                    return false
                }
                i = i + 2
            }
            return true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
