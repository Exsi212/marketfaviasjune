import SwiftUI

struct AuthView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "05050A").edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {  // Уменьшенное расстояние между элементами
                    Spacer()
                    
                    Text("FAVIAS")
                        .font(.system(size: 51, weight: .bold))  // Размер шрифта увеличен до 51
                        .foregroundColor(.white)
                    
                    Text("MEDIA PORTFOLIO")
                        .font(.system(size: 28, weight: .medium))  // Размер шрифта изменен на 28
                        .foregroundColor(.gray)

                    Spacer()
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Войти")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .padding(.horizontal, 50)

//                    NavigationLink(destination: RegisterView()) {
//                        Text("Создать аккаунт")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.gray)
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
//                    }
//                    .padding(.horizontal, 50)
//
//                    Spacer()
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
