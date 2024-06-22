import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var shouldNavigate: Bool = false
    @State private var errorMessage: String? = nil

    private var userService = UserService(csrfToken: "oQ5LGTg4cHgjm_nX6aVCXp4v-N8qldy6iprqWkVLr2cXVtanjGPhHCKwQekgiv5Wl_d9TN2ltxHlrtvl7dikVQ")

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "05050A").edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()

                    Text("Добро пожаловать")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Введите ваш логин и пароль")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)

                    CustomTextField(placeholder: "Логин", text: $email)
                    CustomSecureField(placeholder: "Пароль", text: $password)

                    Button("Войти") {
                        userService.loginUser(email: email, password: password) { success, responseMessage in
                            DispatchQueue.main.async {
                                if success {
                                    shouldNavigate = true
                                } else {
                                    // Обработка ошибок
                                    errorMessage = responseMessage
                                }
                            }
                        }
                    }
                    .buttonStyle(FillButtonStyle(backgroundColor: Color.green))
                    .padding(.top, 20)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    Spacer()

                    Button("Забыли пароль?") {
                        // Реализация восстановления пароля
                    }
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)

                    // Добавление NavigationLink для навигации к MainView
                    NavigationLink(destination: MainView(), isActive: $shouldNavigate) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 30)
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(5)
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(5)
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
    }
}

struct FillButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
