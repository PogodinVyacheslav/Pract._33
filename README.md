Бекенд приложение:

Взаимодействие с базой данных

Необходим Docker Desktop и Postman

Команды для запуска:
git clone https://github.com/PogodinVyacheslav/Pract._33
cd Pract._33/FastAPI (Переход в нужную директорию)
docker-compose up --build (Запуск контейнеров)

Поиск сотрудников в Postman:
POST-запрос на http://127.0.0.1:8000/searchEmpl/
с телом в формате JSON: (нажать на Send)
{
    "search_term": "параметр"
}
