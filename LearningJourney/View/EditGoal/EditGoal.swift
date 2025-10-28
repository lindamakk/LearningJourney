//
//  EditGoal.swift
//  learning_journey
//
//  Created by Linda on 26/10/2025.
//

import SwiftUI
import SwiftData

struct EditGoal: View {
    

    var body: some View {
        
        
            VStack(alignment: .leading) {
               
                Text("I want to learn")
                    .font(.title2)
            TextField("e.g. Swift", text: .constant(""))
                Divider()
                Spacer().frame(height: 24)
                Text("I want to learn it in a ")
                    .font(.title2)
                
                HStack(spacing: 8) {
                    CustomGlassButton( title: "Week",  isActive:true, action: {}, )
                    
                  
                        CustomGlassButton(title: "Month",  action: {},)
                    
                    CustomGlassButton(title:  "Year", action: {},)
                }

                Spacer()
            }.padding(20)

            .navigationTitle("Learning Goal")
                   .navigationBarTitleDisplayMode(.inline)
        }


}

#Preview {
    EditGoal()
        .modelContainer(for: Item.self, inMemory: true)
}

