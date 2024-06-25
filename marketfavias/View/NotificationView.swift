import SwiftUI

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Верхний бар с заголовком и стрелкой назад
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("ИСТОРИЯ УВЕДОМЛЕНИЙ")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Пустая кнопка для выравнивания
                Image(systemName: "chevron.left")
                    .foregroundColor(.clear)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 20) {
                    NotificationItem(username: "max_avdeev_20", action: "нравится твоя айтем.", time: "21 час назад", imageName: "hoodie")
                    NotificationItem(username: "max_avdeev_20", action: "оставил комментарий айтему....", time: "21 час назад", imageName: "hoodie")
                    NotificationItem(username: "max_avdeev_20", action: "подписался на твое портфолио.", time: "21 час назад")
                    NotificationItem(username: "Команда Favias", action: "удалила айтем.", time: "21 час назад", isSupport: true, imageName: "hoodie")
                    NotificationItem(username: "Команда Favias", action: "удалила комментарий.", time: "21 час назад", isSupport: true, imageName: "hoodie")
                    NotificationItem(username: "Команда Favias", action: "убрала значок бренда с твоего аккаунта.", time: "21 час назад", isSupport: true)
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

struct NotificationItem: View {
    let username: String
    let action: String
    let time: String
    let isSupport: Bool
    let imageName: String?
    
    init(username: String, action: String, time: String, isSupport: Bool = false, imageName: String? = nil) {
        self.username = username
        self.action = action
        self.time = time
        self.isSupport = isSupport
        self.imageName = imageName
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !isSupport {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading) {
                Text("\(username) \(action)")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if isSupport {
                    Button(action: {
                        // Действие для кнопки поддержки
                    }) {
                        Text("Написать в поддержку")
                            .font(.caption)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(5)
                    }
                    .padding(.top, 5)
                }
            }
            
            Spacer()
            
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
