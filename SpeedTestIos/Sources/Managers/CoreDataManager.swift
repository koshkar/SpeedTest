import CoreData
import SwiftUI

// Создание и управление Core Data Stack
class CoreDataManager {
    static let shared = CoreDataManager()  // Singleton

    let container: NSPersistentContainer  // Core Data контейнер

    init() {
        container = NSPersistentContainer(name: "CoreDataModel")  // Название модели данных
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Ошибка при загрузке Core Data: \(error)")
            }
        }
    }

    func saveContext() {  // Сохранение изменений в Core Data
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Ошибка при сохранении Core Data: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
