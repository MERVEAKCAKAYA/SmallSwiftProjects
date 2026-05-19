//
//  RatingView.swift
//  BookwormApp
//
//  Created by Merve Akçakaya on 19.05.2026.
//

import SwiftUI

struct RatingView: View {
    //kendi verisi olmadığı için @State kullanmadık @Binding kullandık. Parent'tan aldığı veriyi kullanıp guncelleyecek.
    @Binding var rating: Int
    var label = ""
    var maxRating = 5
    var offImage : Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack{
            if label.isEmpty == false{
                Text(label)
            }
            ForEach(1...maxRating, id:\.self){number in
                Button{
                    //kullanıcı default rating değerini değiştirdiğinde bunu algılamak için kullanılır
                    rating = number
                }label:{
                    image(for: number).foregroundStyle(number>rating ? offColor : onColor)
                }
            }
        }
        .buttonStyle(.plain)
    }
    func image(for number : Int) -> Image{
        //bu fonksiyon offImage'ı özelleştirmeyi sağlar. Bunu yazmazsak image onImage ile aynı olur sadece rengi değişir.
        if(number > rating){
            return offImage ?? onImage
        }else{
            return onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(4), offImage: Image(systemName: "star"))
}
