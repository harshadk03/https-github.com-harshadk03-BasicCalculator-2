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
            return colorScheme == .light ? .orange : .orange // Bright colors for operators
        case .clear, .percent, .toggleSign:
            return colorScheme == .light ? Color(.lightGray) : Color(.lightGray) // Neutral tones
        default:
            return colorScheme == .light ? .black : Color(.darkGray) // Numbers adapt to mode
        }
    }
}

// MARK: - Main View for the Calculator
struct MainCalculator: View {
    
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
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer() // Push everything to the bottom
                
                // MARK: - Title Section
                HStack {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Title 2")
                            .font(.title2)
                            .foregroundColor(.secondary) // Dynamically adapt to light/dark mode
                        Text("Large Title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary) // Dynamically adapt to light/dark mode
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                //.background(colorScheme == .light ? Color(.systemGray6) : Color(.systemGray4)) // Adaptive background
                
                // MARK: - Keypad Section
                ForEach(buttons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                // Button action
                            }, label: {
                                Text(item.rawValue)
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonheight(item: item)
                                    )
                                    .background(item.ButtonColor(for: colorScheme)) // Adaptive button color
                                    .foregroundColor(colorScheme == .light ? .white : .white) // Adaptive text color
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            })
                        }
                    }
        
                    .frame(maxWidth: .infinity)
                }
                //.border(colorScheme == .light ? .black : .white, width: 1) // Border adapts to mode
            }
            .padding(24)
            .background(colorScheme == .light ? Color(.white) : Color(.black)) // Full view background adapts
            
        }
        //.border(colorScheme == .light ? .black : .white, width: 1) // Border adapts to mode
    }
    
    // MARK: - Button Width Calculation
    func buttonWidth(item: CalculatorButton) -> CGFloat {
        if item == .equals {
            // Equals button spans two columns
            let equalsWidth = (UIScreen.main.bounds.width - (3 * 16)) / 2
            return equalsWidth
        }
        // Standard button width
        let standardWidth = (UIScreen.main.bounds.width - (4 * 16)) / 4
        return standardWidth
    }

    // MARK: - Button Height Calculation
    func buttonheight(item: CalculatorButton) -> CGFloat {
        // Standard button height
        return (UIScreen.main.bounds.width - (5 * 16)) / 4
    }
}

// MARK: - Preview
#Preview {
    MainCalculator()
}
