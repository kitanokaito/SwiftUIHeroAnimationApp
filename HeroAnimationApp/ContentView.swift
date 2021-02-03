import SwiftUI

struct ContentView: View {
  @State var showEdit = false
  @State var pokeIndex = 0
  
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
        .edgesIgnoringSafeArea(.all)
      
      ScrollView(showsIndicators: false) {
        VStack(spacing: 20) {
          HStack(spacing: 0) {
            Text("Let's Travel")
              .font(.system(size: 20, weight: .bold, design: .default))
            
            Spacer()
            Image(systemName: "magnifyingglass")
              .resizable()
              .frame(width: 20, height: 20)
          }
          .padding(.horizontal)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
              ForEach(data) { poke in
                Image(poke.image)
                  .resizable()
                  .frame(width: 80, height: 80)
                  .clipShape(Circle())
              }
            }
            .padding()
          }
          
          HStack(spacing: 0) {
            Text("Destinations")
              .font(.system(size: 13, weight: .heavy, design: .default))
            
            Spacer()
            Text("See all")
              .font(.system(size: 13, weight: .light, design: .default))
          }
          .padding(.horizontal)
          
          ForEach(0..<data.count) { index in
            GeometryReader { geo in
              EditView(showEdit: self.$showEdit, index: index)
                .offset(y: data[index].expand ? -geo.frame(in: .global).minY : 0)
                .opacity(self.showEdit ? (data[index].expand ? 1 : 0) : 1)
                .onTapGesture {
                  withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1.8, blendDuration: 0)) {
                    if !data[index].expand{
                      self.showEdit.toggle()
                      data[index].expand.toggle()
                    }
                  }
              }
            }
            .frame(height: data[index].expand ? UIScreen.main.bounds.height : 250)
            .simultaneousGesture(DragGesture(minimumDistance: data[index].expand ? 0 : 500).onChanged({ (_) in
              print("dragging")
            }))
          }
        }
      }
      
      if (showEdit) {
        EditView(showEdit: self.$showEdit, index: self.pokeIndex)
      }
    }
    .foregroundColor(.white)
  }
}

struct EditView: View {
  @Binding var showEdit: Bool
  let index: Int
  
  func changeEdit() {
    showEdit.toggle()
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .top) {
        Image(data[index].image)
          .resizable()
          .frame(
            width: UIScreen.main.bounds.width / 1.2,
            height: UIScreen.main.bounds.height / 3
        )
          .overlay(
            LinearGradient(
              gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.8)]),
              startPoint: .top,
              endPoint: .bottom
            )
        )
          .cornerRadius(20)
        
        VStack(alignment: .leading) {
          Text(data[index].title)
          Text(data[index].place)
        }
        .padding(10)
        
        if (self.showEdit) {
          HStack(spacing: 0) {
            gradientIcon(
              action: {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1.8, blendDuration: 0)){
                  data[self.index].expand.toggle()
                  self.showEdit.toggle()
                }
            },
              systemImageName: "chevron.left",
              width: 8,
              height: 15
            )
            
            Spacer()
            gradientIcon(action: {}, systemImageName: "magnifyingglass", width: 15, height: 15)
          }
          .padding(EdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 20))
        }
      }
      
      Spacer()
    }
//    .background(Color.black.opacity(0.2))
    .edgesIgnoringSafeArea(.all)
  }
}

struct gradientIcon: View {
  let action: (() ->Void)
  let systemImageName: String
  let width: CGFloat
  let height: CGFloat
  
  var body: some View {
    Button(action: self.action) {
      ZStack {
        LinearGradient(
          gradient: Gradient(colors: [Color.purple, Color.blue]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
          .frame(width: 50, height: 50)
          .clipShape(Circle())
        
        Image(systemName: systemImageName)
          .resizable()
          .frame(width: width, height: height)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct Poke: Identifiable {
  var id: Int
  var title: String
  var place: String
  var image: String
  @State var expand: Bool
}

var data = [
  Poke(id: 1, title: "ポケモン1", place: "カントー地方", image: "poke1", expand: false),
  Poke(id: 2, title: "ポケモン2", place: "グンマー地方", image: "poke2", expand: false),
  Poke(id: 3, title: "ポケモン3", place: "トウホクー地方", image: "poke3", expand: false),
  Poke(id: 4, title: "ポケモン4", place: "カンサイー地方", image: "poke4", expand: false),
  Poke(id: 5, title: "ポケモン5", place: "チュウブー地方", image: "poke5", expand: false)
]
