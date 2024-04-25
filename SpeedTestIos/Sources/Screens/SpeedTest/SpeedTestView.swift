import SwiftUI  // Импортируем фреймворк SwiftUI для построения интерфейсов
import CoreData  // Импортируем фреймворк Core Data для работы с данными

// Представление для тестирования скорости соединения
struct SpeedTestView: View {
    @Environment(\.managedObjectContext) var viewContext  // Контекст Core Data для доступа к данным
    
    // Запрос к Core Data для получения настроек
    @FetchRequest(
        entity: Settings.entity(),  // Используем сущность Settings
        sortDescriptors: [],  // Отсутствие сортировки
        animation: .default  // Анимация по умолчанию
    ) var settings: FetchedResults<Settings>  // Коллекция результатов запроса

    // Переменные состояния для отображения результатов теста
    @State private var errorText: String?  // Сообщение об ошибке
    @State private var momentSpeedValue: Double?  // Моментальная скорость
    @State private var calculatedSpeedValue: Double?  // Вычисляемая скорость
    @State private var testResult: String = "Нажмите кнопку, чтобы начать тест"  // Начальный текст

    // Основной вид SwiftUI
    var body: some View {
        NavigationStack {  // Используем NavigationStack для поддержки навигации
            VStack {  // Вертикальный стек для организации содержимого
                VStack {  // Верхняя часть с кнопкой и текстом
                    Button {  // Кнопка для запуска теста
                        performTest()  // Запускаем тест при нажатии кнопки
                    } label: {  // Определяем содержимое кнопки
                        Image(systemName: "play.fill")  // Иконка кнопки
                            .resizable()  // Позволяет изменять размер
                            .frame(width: 100, height: 100)  // Размер изображения
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],  // Градиент
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).opacity(0.8)  // Прозрачность
                            )
                    }
                    .padding(.top, 200)  // Отступ сверху
                    
                    Text("Начать тест")  // Описание кнопки
                        .bold()  // Жирный шрифт
                        .padding(.top, 20)  // Отступ сверху
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],  // Градиент
                                startPoint: .leading,
                                endPoint: .trailing
                            ).opacity(0.8)  // Прозрачность
                        )
                    
                    if let settings = settings.first {  // Если получены настройки
                        Text("Тип теста: \(settings.testType ?? "Не установлен")")  // Показываем тип теста
                            .padding(.top, 20)  // Отступ сверху
                        Text("Тестируемый url: \(settings.url ?? "Не установлен")")
                            .padding(.top, 20)  // Отступ сверху
                        
                    }
                }
                
                Spacer()  // Разделитель
                
                HStack {  // Горизонтальный стек для отображения результатов
                    if let errorText = errorText {  // Если есть ошибка
                        Text("Ошибка: \(errorText)")  // Показываем текст ошибки
                    } else {  // Если нет ошибки
                        VStack {  // Вертикальный стек для скорости
                            if let momentSpeed = momentSpeedValue {  // Моментальная скорость
                                Text("Моментальная скорость: \(String(format: "%.2f", momentSpeed)) Mbps")
                            }
                            
                            if let calculatedSpeed = calculatedSpeedValue {  // Вычисляемая скорость
                                Text("Вычисляемая скорость: \(String(format: "%.2f", calculatedSpeed)) Mbps")
                            }
                        }
                        .padding(.top, 100)  // Отступ сверху
                        .padding(.bottom, 80)  // Отступ снизу
                    }
                }
            }
        }
        .navigationTitle("Тест скорости")  // Заголовок навигации
        .onAppear {
            determineTestType()  // Определяем тип теста при появлении
        }
    }

    // Функция для запуска теста скорости
    func performTest() {
        if let settings = settings.first {  // Если есть настройки
            let startTime = CFAbsoluteTimeGetCurrent()  // Время начала теста
            let dataSize = 10 * 1024 * 1024  // Размер данных для теста (10 МБ)

            if settings.testType == "uploading" {  // Если тип теста - загрузка
                let data = ConnectionSpeedTest.generateRandomData(sizeInMB: 10)  // Генерация случайных данных
                ConnectionSpeedTest.testUploadSpeed(data: data) { (speed, error) in
                    let endTime = CFAbsoluteTimeGetCurrent()  // Время окончания
                    let elapsedTime = endTime - startTime
                    
                    if let error = error {  // Если есть ошибка
                        errorText = "\(error.localizedDescription)"
                    } else {  // Если тест успешен
                        momentSpeedValue = speed  // Моментальная скорость
                        calculatedSpeedValue = Double(dataSize) / elapsedTime / 1024.0 / 1024.0  // Вычисляемая скорость
                        testResult = "Скорость загрузки: \(speed!) Mbps"
                    }
                }
            } else {  // Если тип теста - соединение
                ConnectionSpeedTest.testConnectionSpeed { (speed, error) in
                    if let error = error {  // Если есть ошибка
                        errorText = "\(error.localizedDescription)"
                    } else {  // Если тест успешен
                        momentSpeedValue = speed
                        testResult = "Скорость соединения: \(speed!) Mbps"
                    }
                }
            }
        }
    }

    // Определение типа теста при появлении
    func determineTestType() {
        if let settings = settings.first {  // Если есть настройки
            if settings.testType == "uploading" {  // Если тип теста - загрузка
                testResult = "Используется тест загрузки"
            } else {  // Если тип теста - соединение
                testResult = "Используется тест скорости соединения"
            }
        }
    }
}
