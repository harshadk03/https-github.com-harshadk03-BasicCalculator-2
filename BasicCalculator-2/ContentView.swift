//
//  ContentView.swift
//  BasicCalculator-2
//
//  Created by Harshad Kulkarni on 11/25/24.
//

import SwiftUI

// MARK: - Enum for Calculator Button Types
enum CalculatorButton: String {
    case zero = "0"
    case one  = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case decimal = "."
    case add = "+"
    case subtract = "-"
    case multiply = "×"
    case divide = "÷"
    case equals = "="
    case clear = "AC"
    case percent = "%"
    case toggleSign = "+/-"
    
    // MARK: - Dynamic Button Colors for Light/Dark Mode
    func ButtonColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return .orange // Bright orange for operators
        case .clear, .percent, .toggleSign:
            return .gray // Neutral tones for actions
        default:
            return colorScheme == .light ? .black : Color(.darkGray) // Numbers adapt to the mode
        }
    }
}

// MARK: - Main View for the Calculator
struct MainCalculator: View {
    
    // MARK: - State Variables
    @State private var input: String = "0"      // Current input displayed in the calculator
    @State private var result: String = ""      // Current result displayed below the input
    @State private var isNewCalculation: Bool = true // Tracks if the last operation was completed
    
    // MARK: - Dependencies
    private let engine = CalculatorEngine()     // CalculatorEngine instance for logic
    
    // MARK: - Button Layout
    let buttons: [[CalculatorButton]] = [
        [.clear, .toggleSign, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals],
    ]
    
    // Access the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Computed Properties
    /// Determines the label for the clear button ("AC" or "C").
    private var buttonLabel: String {
        return isNewCalculation || input == "0" ? "AC" : "C"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Spacer() // Push everything to the bottom
                
                // MARK: - Display Section
                VStack(alignment: .trailing, spacing: 4) {
                    // History (result display)
                    if !result.isEmpty {
                        Text(result)
                            .font(.system(size: 24))
                            .dynamicTypeSize(.medium ... .xxLarge)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .truncationMode(.head)
                    }
                    // Current Input
                    Text(input)
                        .font(.system(size: 64))
                        .dynamicTypeSize(.medium ... .xxLarge)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .truncationMode(.head)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // MARK: - Keypad Section
                GeometryReader { geometry in
                    VStack(spacing: 8) {
                        ForEach(buttons, id: \.self) { row in
                            HStack(spacing: 8) {
                                ForEach(row, id: \.self) { item in
                                    Button(action: {
                                        handleButtonTap(item) // Call the action handler
                                    }) {
                                        Text(item == .clear ? buttonLabel : item.rawValue)
                                            .frame(
                                                width: self.buttonWidth(item: item, geometry: geometry),
                                                height: self.buttonHeight(geometry: geometry)
                                            )
                                            .background(item.ButtonColor(for: colorScheme))
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .fontWeight(.medium)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .simultaneousGesture(
                                        LongPressGesture().onEnded { _ in
                                            if item == .clear {
                                                clearInput() // Long press clears everything
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .frame(maxHeight: geometry.size.height * 0.6) // Keypad uses 60% of total height
                    .padding(8)
                }
            }
            .padding(16)
            .background(colorScheme == .light ? Color(.white) : Color(.black)) // Full view background adapts
        }
    }
    
    // MARK: - Button Width Calculation
    func buttonWidth(item: CalculatorButton, geometry: GeometryProxy) -> CGFloat {
        if item == .equals {
            return (geometry.size.width - (4 * 8)) / 2 // Equals button spans two columns
        }
        return (geometry.size.width - (5 * 8)) / 4 // Standard button width
    }

    // MARK: - Button Height Calculation
    func buttonHeight(geometry: GeometryProxy) -> CGFloat {
        let totalHeight = geometry.size.height * 0.6 // Keypad is 60% of total height
        return totalHeight / CGFloat(buttons.count) // Divide by the number of rows
    }
    
    // MARK: - Button Tap Handling
    private func handleButtonTap(_ button: CalculatorButton) {
        switch button {
        case .clear:
            clearOrDeleteInput()
        case .toggleSign:
            toggleSign()
        case .percent:
            applyPercentage()
        case .equals:
            calculateResult()
        case .add, .subtract, .multiply, .divide:
            appendOperator(button.rawValue)
        case .decimal:
            appendDecimal()
        default:
            appendNumber(button.rawValue)
        }
    }
    
    // MARK: - Button Actions
    private func clearOrDeleteInput() {
        if buttonLabel == "AC" {
            clearInput() // Reset calculator
        } else if input != "0" {
            input.removeLast() // Remove the last character
            if input.isEmpty { input = "0" }
        }
    }
    
    private func clearInput() {
        input = "0"
        result = ""
        isNewCalculation = true
        engine.clear()
    }

    private func appendNumber(_ number: String) {
        if isNewCalculation || input == "0" {
            input = number
            isNewCalculation = false
        } else {
            input += number
        }
        engine.append(number)
    }

    private func appendOperator(_ op: String) {
        if input.last?.isWhitespace ?? false || "+-×÷".contains(input.last ?? " ") {
            return
        }
        input += op
        engine.appendOperator(op)
        isNewCalculation = false
    }

    private func appendDecimal() {
        if isNewCalculation {
            input = "0."
            isNewCalculation = false
        } else if !input.contains(".") {
            let lastToken = input.components(separatedBy: " ").last ?? ""
            if lastToken.isEmpty || "+-×÷".contains(lastToken) {
                input += "0."
            } else if !lastToken.contains(".") {
                input += "."
            }
        }
        engine.append(".")
    }

    private func toggleSign() {
        if let value = Double(input) {
            input = String(value * -1)
        }
    }

    private func applyPercentage() {
        if let value = Double(input) {
            input = String(value / 100)
        }
    }

    private func calculateResult() {
        if "+-×÷".contains(input.last ?? " ") || input.isEmpty {
            input = "Error"
            result = ""
            isNewCalculation = true
        } else {
            result = input
            input = engine.evaluateExpression(input)
            isNewCalculation = true
        }
    }
}
