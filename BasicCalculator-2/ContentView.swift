//
//  ContentView.swift
//  BasicCalculator-2
//
//  Created by Harshad Kulkarni on 11/25/24.
//

import SwiftUI

enum CalculatorButton: String {
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
    
    var ButtonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return .orange
        case .clear, .percent, .toggleSign:
            return Color(.lightGray)
        default :
            return Color(.black)
        }
    }
}

struct MainCalculator: View {
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .toggleSign, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals],
    ]
    
    var body: some View {
        
            VStack {
                            Spacer() // Push everything to the bottom
                            
                            // Right-aligned Small and Big text
                            HStack {
                                Spacer() // Pushes the text to the right
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text("Small")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                    Text("Big")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                                .padding(.trailing, 20) // Add some padding on the right
                            }

                //Other buttons
                ForEach(buttons, id: \.self) { row in
                    HStack{
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                            }, label: {
                                Text(item.rawValue)
                                    .frame(
                                        width:self.buttonWidth(item: item),
                                        height:self.buttonheight(item: item)
                                    )
                                    .background(item.ButtonColor)
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            })
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
    
    func buttonWidth(item: CalculatorButton) -> CGFloat {
        if item == .equals {
            let zeroWidth = (UIScreen.main.bounds.width - (3 * 16)) / 2
            return zeroWidth
        }
        
        let standardWidth = (UIScreen.main.bounds.width - (4 * 16)) / 4
        return standardWidth
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonheight(item: CalculatorButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*16)) / 4
    }
}

#Preview {
    MainCalculator()
}
