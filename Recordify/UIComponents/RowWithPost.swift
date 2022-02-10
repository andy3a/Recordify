//
//  RowWithPost.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 25.01.22.
//

import SwiftUI

struct RowWithPost: View {
    var post: Post
    
    @State var bgColor: UIColor = .systemBackground
    @State var releaseTitleColor: UIColor = .label
    @State var releaseYearColor: UIColor = .label
    @State var artistNameColor: UIColor = .label
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Group {
            Image("cover")
                .resizable()
                //.frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .clipped()
                .padding(.vertical, 10)
            Text("Igor")
                    .font(.title)
                    .foregroundColor(Color(uiColor: releaseTitleColor))
            Text("2022")
                    .foregroundColor(Color(uiColor: releaseYearColor))
            }
            .padding(.horizontal, 20)
           
            
                
                ForEach(0..<10) { index in
                    HStack {
                        Image("play")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    Text("Track #\(index)")
                        .padding()
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
            HStack{
                
                
                Image("alex")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .clipShape(
                        Circle()
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                  
                
                Text("Tyler the creator")
                    .foregroundColor(Color(uiColor: artistNameColor))
                Spacer()
            }
            .padding(.bottom, 21)
            
        }
        
        
        .onAppear(perform: {
            let image = UIImage(named: "cover")
            
            image!.getColors { colors in
                bgColor = (colors?.background)!
                releaseTitleColor = (colors?.primary)!
                releaseYearColor = (colors?.secondary)!
                artistNameColor = (colors?.detail)!
            }
//
//            image!.getColors { colors in
//                bgColor = colors.background
//              mainLabel.textColor = colors.primary
//              secondaryLabel.textColor = colors.secondary
//              detailLabel.textColor = colors.detail
//            }
        })
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(uiColor: bgColor),Color(uiColor: bgColor), .black]), startPoint: .topLeading, endPoint: .bottom))
            //Color(uiColor: bgColor))
        .padding(.bottom, -20)
    }
        
}

struct RowWithPost_Previews: PreviewProvider {
    static var previews: some View {
        let posts: [Post] = [
            Post(id: 0, recordName: "Post of the other user", imageName: nil),
            Post(id: 1, recordName: "Post 2", imageName: nil)
        ]
        
        
        RowWithPost(post: posts[1])
    }
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
       

        return path
    }
}
