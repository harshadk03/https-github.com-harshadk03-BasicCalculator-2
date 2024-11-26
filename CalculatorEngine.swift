//
//  CalculatorEngine.swift
//  SimpleCalculator
//
//  Created by Harshad Kulkarni on 11/24/24.
//
//  This file contains the logic for evaluating mathematical expressions,
//  handling user input, and formatting results. The `CalculatorEngine`
//  class is designed to centralize all calculation-related functionality.
//

import Foundation

// MARK: - CalculatorEngine
/// The core class responsible for managing and evaluating mathematical expressions.
class CalculatorEngine {
    
    // MARK: - Properties
    /// The current mathematical expression as a string.
    private var expression: String = ""
    
    // MARK: - Public Methods
    
    /// Clears the current expression and resets the calculator state.
    func clear() {
        expression = ""
    }
    
    /// Appends a number or operator to the expression.
    /// - Parameter value: The number or symbol to append.
    func append(_ value: String) {
        if value == "." {
            if !expression.hasSuffix(".") && !expression.components(separatedBy: " ").last!.contains(".") {
                expression += value
            }
        } else {
            expression += value
        }
    }
    
    /// Appends an operator to the expression.
    /// - Parameter op: The operator to append (e.g., "+", "-", "×", "÷").
    func appendOperator(_ op: String) {
        if let last = expression.last, "+-×÷".contains(last) {
            expression.removeLast()
        }
        expression += " \(op) "
    }
    
    /// Evaluates the current expression and returns the result.
    /// - Parameter input: The mathematical expression to evaluate.
    /// - Returns: The result of the evaluation as a string.
    func evaluateExpression(_ expression: String) -> String {
        // Replace mathematical symbols with `NSExpression`-compatible ones
        let formattedExpression = expression
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "-", with: "-")
            .replacingOccurrences(of: "+", with: "+")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Formatted Expression: \(formattedExpression)") // Debugging input
        
        // Split the expression into components for manual evaluation as a fallback
        let components = formattedExpression.split(separator: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        // Check for simple cases with manual division and multiplication
        if components.count == 3 {
            if let first = Double(components[0]),
               let second = Double(components[2]) {
                switch components[1] {
                case "/":
                    guard second != 0 else { return "Error" } // Division by zero
                    let result = first / second
                    return String(format: "%.12g", result)
                case "*":
                    let result = first * second
                    return String(format: "%.12g", result)
                default:
                    break
                }
            }
        }
        
        // Attempt to evaluate using `NSExpression`
        let mathExpression = NSExpression(format: formattedExpression)
        if let result = mathExpression.expressionValue(with: nil, context: nil) as? NSNumber {
            // Format the result to avoid scientific notation for whole numbers
            return String(format: "%.12g", result.doubleValue)
        } else {
            print("Error: Unable to cast result to NSNumber")
            return "Error"
        }
    }
    /*
    func evaluateExpression(_ input: String) -> String {
        let sanitizedInput = input
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        let expression = NSExpression(format: sanitizedInput)
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            return formatResult(result)
        } else {
            return "Error"
        }
    }
    */
    
    // MARK: - Private Helpers
    
    /// Formats the result to avoid unnecessary decimals (e.g., 5.0 -> 5).
    /// - Parameter result: The raw result as a `Double`.
    /// - Returns: A string representation of the formatted result.
    private func formatResult(_ result: Double) -> String {
        if result == floor(result) {
            return String(format: "%.0f", result)
        } else {
            return String(result)
        }
    }
}
