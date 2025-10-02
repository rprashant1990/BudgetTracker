import SwiftUI

struct AmountStyle: ViewModifier {
    let type: ExpenseType

    func body(content: Content) -> some View {
        content
            .font(.body.monospacedDigit())
            .foregroundStyle(getColor())
    }
    
    private func getColor() -> Color {
        switch type {
        case .debit:
            return .red
        case .credit:
            return .green
        default:
            return .blue
        }
    }
}

extension View {
    func amountStyle(for type: ExpenseType) -> some View {
        self.modifier(AmountStyle(type: type))
    }
    
    func amountStyle(for amount: Double) -> some View {
        if amount >= 0 {
            self.modifier(AmountStyle(type: .credit))
        } else {
            self.modifier(AmountStyle(type: .debit))
        }
    }
}
