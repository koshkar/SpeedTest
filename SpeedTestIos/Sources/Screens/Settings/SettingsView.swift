import SwiftUI  // Импортируем фреймворк для построения интерфейса
import CoreData  // Импортируем фреймворк для работы с Core Data

// Представление для настройки параметров тестирования
struct SettingsView: View {
    @Environment(\.managedObjectContext) var viewContext  // Доступ к контексту Core Data

    // Состояния для хранения значений, используемых в этом представлении
    @State var urlText: String = ""  // Хранит URL-адрес для тестирования
    @State var selectedAppTheme: AppTheme = .system  // Хранит выбранную тему
    @State var selectedTestType: TestType = .loading  // Хранит выбранный тип теста

    var body: some View {  // Основное представление SwiftUI
        NavigationView {  // Используем NavigationView для поддержки навигации
            VStack {  // Вертикальный стек для организации элементов
                Form {  // Используем Form для ввода данных
                    // Секция для выбора темы приложения
                    Section(header: Text("Тема приложения")) {
                        Picker("Тема", selection: $selectedAppTheme) {  // Picker для выбора темы
                            ForEach(AppTheme.allCases, id: \.self) { theme in  // Все возможные темы
                                Text(theme.rawValue)  // Текстовое представление темы
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())  // Используем сегментированный стиль пикера
                    }
                    
                    // Секция для ввода URL-адреса
                    Section(header: Text("URL для тестирования")) {
                        TextEditor(text: $urlText)  // Поле для ввода текста
                            .frame(height: 80)  // Высота текстового редактора
                    }
                    
                    // Секция для выбора типа теста
                    Section(header: Text("Тип теста")) {
                        Picker("Тип", selection: $selectedTestType) {  // Picker для выбора типа теста
                            ForEach(TestType.allCases, id: \.self) { type in  // Все возможные типы тестов
                                Text(type.rawValue)  // Текстовое представление типа
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())  // Сегментированный стиль пикера
                    }
                }

                // Кнопка для сохранения настроек
                Button("Сохранить") {
                    withAnimation {  // Используем анимацию при нажатии
                        saveSettings()  // Сохраняем настройки в Core Data
                    }
                }
                .padding()  // Добавляем отступы вокруг кнопки
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],  // Градиентный фон
                        startPoint: .leading,
                        endPoint: .trailing
                    ).opacity(0.8)  // Прозрачность градиента
                )
                .foregroundColor(.white)  // Белый цвет текста
                .cornerRadius(10)  // Скругленные края
                .frame(maxWidth: .infinity)  // Растягивание на всю ширину
                .buttonStyle(PlainButtonStyle())  // Отключение выделения по умолчанию
            }
        }
        .navigationTitle("Настройки")  // Заголовок в NavigationView
        .onAppear {  // Код, который выполняется при появлении представления
            let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()  // Запрос для получения настроек
            if let settings = try? viewContext.fetch(fetchRequest).first {  // Если есть существующие настройки
                urlText = settings.url ?? "https://vk.com"  // Загружаем URL
                selectedAppTheme = AppTheme(rawValue: settings.appTheme ?? "") ?? .system  // Загружаем тему
                selectedTestType = TestType(rawValue: settings.testType ?? "") ?? .loading  // Загружаем тип теста
            }
        }
        .preferredColorScheme(mapToColorScheme(theme: selectedAppTheme))  // Применяем цветовую схему
    }

    // Функция для сохранения настроек в Core Data
    func saveSettings() {
        let settings: Settings  // Создаем переменную для хранения сущности настроек
        if let existingSettings = try? viewContext.fetch(Settings.fetchRequest()).first {  // Если есть существующие настройки
            settings = existingSettings
        } else {
            settings = Settings(context: viewContext)  // Если нет, создаем новую сущность
        }

        // Сохраняем значения в настройки
        settings.url = urlText
        settings.appTheme = selectedAppTheme.rawValue
        settings.testType = selectedTestType.rawValue

        do {
            try viewContext.save()  // Сохраняем изменения в Core Data
        } catch {
            print("Ошибка при сохранении данных: \(error)")  // Обрабатываем ошибки
        }
    }

    // Функция для сопоставления темы приложения с цветовой схемой SwiftUI
    func mapToColorScheme(theme: AppTheme) -> ColorScheme? {
        switch theme {
        case .light:
            return .light  // Светлая цветовая схема
        case .dark:
            return .dark  // Темная цветовая схема
        case .system:
            return nil  // Цветовая схема по умолчанию (системная)
        }
    }
}

// Дополнительные элементы, используемые в SettingsView
extension SettingsView {
    enum TestType: String, CaseIterable, Codable {  // Возможные типы тестов
        case loading, uploading  // Тест скорости загрузки и выгрузки
    }
}

enum AppTheme: String, CaseIterable, Codable {  // Возможные темы приложения
    case light, dark, system  // Светлая, темная и системная темы
}
