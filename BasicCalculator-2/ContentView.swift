//
//  ContentView.swift
//  BasicCalculator-2
//
//  Created by Harshad Kulkarni on 11/25/24.
//

import SwiftUI

// MARK: - Enum for Calculator Button Types
enum CalculatorButton: String {
    // Different calculator button types with their respective labels
    case zero = "0"
    case one  = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six =  "6"
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
    
    // MARK: - Button Colors Based on Type
    var ButtonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return .orange // Operators and equals button are orange
        case .clear, .percent, .toggleSign:
            return Color(.lightGray) // Utility buttons are light gray
        default:
            return Color(.black) // Number buttons are black
        }
    }
}

// MARK: - Main View for the Calculator
struct MainCalculator: View {
    
    // MARK: - Button Layout
    let buttons: [[CalculatorButton]] = [
        // Define button rows as 2D array
        [.clear, .toggleSign, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals],
    ]
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            Spacer() // Push everything to the bottom
            
            // MARK: - Title Section
            HStack {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Title 2")
                        .font(.title2) // Smaller title
                        .foregroundColor(.gray)
                    Text("Large Title")
                        .font(.largeTitle) // Large title
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .trailing) // Right-align and span full width
            }
            .frame(maxWidth: .infinity) // Ensure HStack fills the available width
            //.background(Color.blue.opacity(0.1)) // Add a light blue background for visualization
            
            // MARK: - Keypad Section
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            // Action for button press
                        }, label: {
                            Text(item.rawValue) // Button label (e.g., "1", "+", etc.)
                                .frame(
                                    width: self.buttonWidth(item: item), // Dynamically calculated width
                                    height: self.buttonheight(item: item) // Dynamically calculated height
                                )
                                .background(item.ButtonColor) // Background color based on button type
                                .foregroundColor(.white) // Text color is white
                                .font(.title) // Font size for the button label
                                .fontWeight(.medium) // Medium font weight
                                .clipShape(RoundedRectangle(cornerRadius: 6)) // Rounded rectangle shape
                        })
                    }
                }
                .frame(maxWidth: .infinity) // Ensure keypad row fills available space
            }
            //.border(.black, width: 1) // Add border to keypad section for debugging layout
        }
        //.border(.black, width: 1) // Add border to overall view for debugging layout
        .padding(24) // Add padding around the entire view (titles + keypad)
    }
    
    // MARK: - Button Width Calculation
    func buttonWidth(item: CalculatorButton) -> CGFloat {
        if item == .equals {
            // Equals button spans two columns
            let equalsWidth = (UIScreen.main.bounds.width - (3 * 16)) / 2
            return equalsWidth
        }
        // Standard button width (1/4th of available width minus spacing)
        let standardWidth = (UIScreen.main.bounds.width - (4 * 16)) / 4
        return standardWidth
    }

    // MARK: - Button Height Calculation
    func buttonHeight() -> CGFloat {
        // Standard button height
        return (UIScreen.main.bounds.width - (5 * 16)) / 4
    }
    
    // MARK: - Alternative Button Height Calculation (Unused)
    func buttonheight(item: CalculatorButton) -> CGFloat {
        // Dynamically calculate height for each button
        return (UIScreen.main.bounds.width - (5 * 16)) / 4
    }
}

// MARK: - Preview
#Preview {
    MainCalculator()
}
