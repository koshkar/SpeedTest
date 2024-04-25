import Alamofire  // Библиотека для работы с сетевыми запросами
import SwiftUI  // Фреймворк для построения интерфейса
import CoreData  // Фреймворк для работы с Core Data

// Класс для тестирования скорости соединения
struct ConnectionSpeedTest {
    // Получение URL из Core Data непосредственно перед началом теста
    static func getUrlFromCoreData() -> String {
        let context = CoreDataManager.shared.container.viewContext  // Контекст Core Data
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()  // Запрос к Core Data
        let settings: Settings
        
        // Если сущность настроек уже есть, используем ее; если нет, создаем новую
        if let existingSettings = try? context.fetch(fetchRequest).first {
            settings = existingSettings
        } else {
            settings = Settings(context: context)
        }

        return settings.url ?? "https://vk.com"  // Возвращаем URL или значение по умолчанию
    }

    // Тестирование скорости загрузки (download speed)
    static func testConnectionSpeed(completion: @escaping (Double?, Error?) -> Void) {
        let url = getUrlFromCoreData()  // Считываем URL из Core Data
        
        // Проверяем, что URL не пустой
        guard !url.isEmpty else {
            completion(nil, NSError(domain: "ConnectionSpeedTest", code: 1, userInfo: [NSLocalizedDescriptionKey: "URL is empty"]))
            return
        }

        let startTime = CFAbsoluteTimeGetCurrent()  // Время начала теста
        
        // Отправляем запрос к URL
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):  // Если запрос успешен
                let endTime = CFAbsoluteTimeGetCurrent()  // Время окончания
                let elapsedTime = endTime - startTime  // Время выполнения
                // Расчет скорости в Mbps (мегабиты в секунду)
                let speed = Double(data.count) / elapsedTime / 1024.0 / 1024.0
                completion(speed, nil)  // Возвращаем результат
            case .failure(let error):  // Если запрос не удался
                completion(nil, error)  // Возвращаем ошибку
            }
        }
    }

    // Генерация случайных данных для теста
    static func generateRandomData(sizeInMB: Int) -> Data {
        let sizeInBytes = sizeInMB * 1024 * 1024  // Конвертация размера в байты
        var randomBytes = [UInt8](repeating: 0, count: sizeInBytes)  // Создание массива байтов
        _ = SecRandomCopyBytes(kSecRandomDefault, sizeInBytes, &randomBytes)  // Заполнение случайными значениями
        return Data(randomBytes)  // Возвращаем объект Data
    }

    // Тестирование скорости загрузки (upload speed)
    static func testUploadSpeed(data: Data, completion: @escaping (Double?, Error?) -> Void) {
        let url = getUrlFromCoreData()  // Считываем URL из Core Data
        
        // Проверяем, что URL не пустой
        guard !url.isEmpty else {
            completion(nil, NSError(domain: "ConnectionSpeedTest", code: 1, userInfo: [NSLocalizedDescriptionKey: "URL is empty"]))
            return
        }

        let startTime = CFAbsoluteTimeGetCurrent()  // Время начала теста
        
        // Отправляем запрос с загрузкой данных
        AF.upload(data, to: url).responseData { response in
            switch response.result {
            case .success(_):  // Если запрос успешен
                let endTime = CFAbsoluteTimeGetCurrent()  // Время окончания
                let elapsedTime = endTime - startTime  // Время выполнения
                // Расчет скорости в Mbps (мегабиты в секунду)
                let speed = Double(data.count) / elapsedTime / 1024.0 / 1024.0
                completion(speed, nil)  // Возвращаем результат
            case .failure(let error):  // Если произошла ошибка
                completion(nil, error)  // Возвращаем ошибку
            }
        }
    }
}
