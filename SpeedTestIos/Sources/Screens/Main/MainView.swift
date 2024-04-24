import SwiftUI  // Фреймворк для построения интерфейса
import CoreData  // Фреймворк для работы с Core Data

// Основное представление приложения
struct MainView: View {
    @Environment(\.managedObjectContext) var viewContext  // Контекст Core Data для взаимодействия с базой данных
    @State private var showSettings: Bool = false  // Состояние для отображения экрана настроек
    @State private var showSpeedTest: Bool = false  // Состояние для отображения экрана теста скорости
    @State private var selectedAppTheme: AppTheme = .system  // Тема приложения
    
    // Основное представление SwiftUI
    var body: some View {
        NavigationStack {  // Используем NavigationStack для навигации
            VStack {  // Вертикальный стек для организации содержимого
                VStack {  // Верхняя часть с инструкциями
                    HStack {  // Горизонтальный стек для текста и изображения
                        Text("Нажмите на ")  // Инструкции для пользователя
                            .font(.title)
                        Image(systemName: "network")  // Иконка теста скорости
                            .resizable()
                            .frame(width: 30, height: 30)  // Размер изображения
                        Text(" для теста")  // Завершение инструкции
                            .font(.title)
                    }
                    HStack {  // Горизонтальный стек для второй инструкции
                        Text("Или на ")  // Начало второй инструкции
                            .font(.title)
                        Image(systemName: "gear")  // Иконка настроек
                            .resizable()
                            .frame(width: 30, height: 30)  // Размер изображения
                        Text(" для настройки")  // Завершение второй инструкции
                            .font(.title)
                    }
                    .padding([.top, .bottom], 20)  // Отступы сверху и снизу
                }
                .padding(.top, 250)  // Большой отступ сверху
                
                Spacer()  // Разделитель
                
                HStack {  // Горизонтальный стек для кнопок
                    Button(action: { showSpeedTest = true }) {  // Кнопка для запуска теста скорости
                        Image(systemName: "network")  // Иконка для кнопки
                            .resizable()
                            .frame(width: 40, height: 40)  // Размер изображения
                            .foregroundColor(.white)  // Белый цвет иконки
                    }
                    .padding(.leading, 25)  // Отступ слева
                    
                    Spacer()  // Разделитель
                    
                    Button(action: { showSettings = true }) {  // Кнопка для открытия настроек
                        Image(systemName: "gear")  // Иконка для кнопки
                            .resizable()
                            .frame(width: 40, height: 40)  // Размер изображения
                            .foregroundColor(.white)  // Белый цвет иконки
                    }
                    .padding(.trailing, 25)  // Отступ справа
                }
                .navigationTitle("Main")  // Заголовок навигации
                .frame(maxWidth: .infinity)  // Растягивание на всю ширину
                .frame(height: 80)  // Высота контейнера
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],  // Градиентный фон
                        startPoint: .leading,
                        endPoint: .trailing
                    ).opacity(0.8)  // Прозрачность градиента
                )
                .shadow(radius: 10, y: -5)  // Тень снизу
                .clipShape(RoundedRectangle(cornerRadius: 40))  // Скругленные края
                .offset(y: 10)  // Смещение по вертикали
                .padding(.horizontal, 10)  // Отступы по горизонтали
            }
            .navigationDestination(isPresented: $showSettings) {  // Навигация на экран настроек
                SettingsView()  // Представление настроек
            }
            .navigationDestination(isPresented: $showSpeedTest) {  // Навигация на экран теста скорости
                SpeedTestView()  // Представление теста скорости
            }
            .preferredColorScheme(mapToColorScheme(theme: selectedAppTheme))  // Применяем тему
            .onAppear {  // Код, который выполняется при появлении
                loadTheme()  // Загружаем тему из Core Data
            }
        }
    }
    
    // Функция для преобразования темы в ColorScheme SwiftUI
    func mapToColorScheme(theme: AppTheme) -> ColorScheme? {
        switch theme {
        case .light:
            return .light  // Светлая цветовая схема
        case .dark:
            return .dark  // Темная цветовая схема
        case .system:
            return nil  // Системная цветовая схема
        }
    }
    
    // Функция для загрузки темы из Core Data
    func loadTheme() {
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()  // Запрос к Core Data
        if let settings = try? viewContext.fetch(fetchRequest).first {  // Если есть существующие настройки
            selectedAppTheme = AppTheme(rawValue: settings.appTheme ?? "") ?? .system  // Загружаем тему
        }
    }
}
