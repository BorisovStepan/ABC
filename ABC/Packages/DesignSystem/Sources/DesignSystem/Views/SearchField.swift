//
//  SearchField.swift
//  DesignSystem
//
//  Created by s.barysau on 12.03.26.
//

import SwiftUI

public struct SearchField: View {
    @Binding var text: String
    var focus: FocusState<Bool>.Binding
    let placeholder: String = "Search"
    
    public init(text: Binding<String>, focus: FocusState<Bool>.Binding) {
        _text = text
        self.focus = focus
    }
    
    public var body: some View {
        HStack(spacing: Grid.Space.s) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .focused(focus)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, Grid.Space.m)
        .padding(.vertical, Grid.Space.s)
        .background(
            RoundedRectangle(cornerRadius: Grid.Space.s, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
}
