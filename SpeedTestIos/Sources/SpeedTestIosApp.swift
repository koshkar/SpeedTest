import SwiftUI  // Фреймворк для построения пользовательского интерфейса SwiftUI

@main  // Указывает на точку входа в приложение
struct SpeedTestIosApp: App {  // Основная структура приложения
    let coreDataManager = CoreDataManager.shared  // Менеджер Core Data
    @Environment(\.managedObjectContext) var managedObjectContext  // Контекст Core Data из окружения

    var body: some Scene {  // Основное представление приложения
        WindowGroup {  // Группа окон, представляющая приложение
            MainView()  // Основное представление приложения
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)  // Передаем контекст Core Data
        }
    }
}
