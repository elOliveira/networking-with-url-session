//
//  CalculatePrimeOperation.swift
//  ConcurrencyTest
//
//  Created by cit on 15/06/22.
//

//import Foundation


//     AGORA NAO USAMOS


//class CalculatePrimeOperation: Operation {
//    override func main(){
//        for number in 0...1_000_000 {
//            let isPrimeNumber = isPrime(number: number)
//            print("\(number) is prime: \(isPrimeNumber)")
//        }
//
//        func isPrime(number: Int)-> Bool{
//            if number <= 1 {
//                return false
//            }
//            if number <= 3 {
//                return false
//            }
//            var i = 2
//
//            while i * i <= number {
//                if number % i == 0{
//                    return false
//                }
//                i = i + 2
//            }
//            return true
//        }
//    }
//}
