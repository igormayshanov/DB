use project
db.createCollection("employee")
db.createCollection("department")

//3.1 Отобразить коллекции базы данных
show collections

db.department.find()

db.department.drop() 

/*3.2 Вставка записей
• Вставка одной записи insertOne
• Вставка нескольких записей insertMany*/
db.department.insertOne({name: "Инженерный отдел"})

db.department.insertMany([
{name: "Бухгалтерия"},
{name: "Отдел развития"},
{name: "Отдел аренды"},
])
db.department.insertMany([
    {name: "Отдел информационных технологий"},
    {name: "Управление операциями"},
    {name: "СЭБ"},
    ])

db.employee.insertOne({
    name: "Васильев Вася",
    position: "Инженигер",
    id_department: ObjectId("629e2c56c088b8c40352f2cc")
})   

db.employee.insertMany([
    {name: "Васильев Вася", position: "Инженигер", id_department: ObjectId("629e2c56c088b8c40352f2cc")},
    {name: "Иванов Иван", position: "Инженигер", id_department: ObjectId("629e2c56c088b8c40352f2cc")},
    {name: "Месси Лионель", position: "Менеджер", id_department: ObjectId("629e2cf2c088b8c40352f2ce")},
    {name: "Трумен Гарри", position: "Главный инженегр", id_department: ObjectId("629e2c56c088b8c40352f2cc")},
    {name: "Рузвельт Франклин", position: "Специалист", id_department: ObjectId("629e2db7c088b8c40352f2d2")},
    {name: "Брежнев Леонид", position: "Системотехник", id_department: ObjectId("629e2db7c088b8c40352f2d0")},
    {name: "Горбачев Миша", position: "Инженер по инвестремонтам", id_department: ObjectId("629e2c56c088b8c40352f2cc")},
    {name: "Путин Вова", position: "ДФ", id_department: ObjectId("629e2db7c088b8c40352f2d1")},
    {name: "Сталин Иосиф", position: "Супервайзер", id_department: ObjectId("629e2db7c088b8c40352f2d1")},
])

db.project.insertMany([
    {name: "Инвестпрограмма", due_date: new Date(2022,12,1), start_date: new Date(2022,1,1), status: "в работе"},
    {name: "Редизайны", due_date: new Date(2022,12,31), start_date: new Date(2022,1,1), end_date: new Date(2022,3,1), status: "приостановлено"},
    {name: "Открытия", due_date: new Date(2022,10,1), start_date: new Date(2022,1,1), end_date: new Date(2022,3,1), status: "приостановлено"},
    {name: "Закупка ключевого оборудования", due_date: new Date(2022,09,1), start_date: new Date(2021,1,1), status: "в работе"},
])

db.join_project.insertMany([
    {id_project: ObjectId("629e3a8ac088b8c40352f2df"), id_employee: [
        ObjectId("629e3774c088b8c40352f2d5"),
        ObjectId("629e3774c088b8c40352f2d6"),
        ObjectId("629e3774c088b8c40352f2d8")
    ]},
    {id_project: ObjectId("629e3a8ac088b8c40352f2e1"), id_employee:[
        ObjectId("629e3774c088b8c40352f2da"),
        ObjectId("629e3774c088b8c40352f2dc"),
    ] },

    {id_project: ObjectId("629e3a8ac088b8c40352f2e0"), id_employee: [
        ObjectId("629e3774c088b8c40352f2db"),
        ObjectId("629e3774c088b8c40352f2d7"),
    ]},
    {id_project: ObjectId("629e3a8ac088b8c40352f2e2"), id_employee: [
        ObjectId("629e3774c088b8c40352f2d5"),
        ObjectId("629e3774c088b8c40352f2d6"),
        ObjectId("629e3774c088b8c40352f2d8"),
    ]},
])

db.join_project.drop()

/*3.3 Удаление записей
• Удаление одной записи по условию deleteOne
• Удаление нескольких записей по условию deleteMany*/

db.department.deleteOne({name: "Отдел аренды"})
db.employee.deleteOne({position: "Инженигер"})
db.employee.deleteMany({position: "Инженигер"})


/*3.4 Поиск записей
• Поиск по ID
• Поиск записи по атрибуту первого уровня
• Поиск записи по вложенному атрибуту
• Поиск записи по нескольким атрибутам (логический оператор AND)
• Поиск записи по одному из условий (логический оператор OR)
• Поиск с использованием оператора сравнения
(https://docs.mongodb.com/manual/reference/operator/query/#std-label-queryselectors)
• Поиск с использованием двух операторов сравнения
• Поиск по значению в массиве
• Поиск по количеству элементов в массиве
• Поиск записей без атрибута*/

db.department.findOne({_id: ObjectId("629e2c56c088b8c40352f2cc")})
db.employee.find({position: "Инженигер"})
db.employee.find({$and:[{position: "Инженигер"}, {name: "Васильев Вася"}]})
db.employee.find({$or:[{position: "Инженигер"}, {name: "Сталин Иосиф"}]})

db.project.find({due_date:{$lte: new Date(2022,12,1)}}) //меньше или равно
db.project.find({due_date:{$gt: new Date(2022,12,1)}}) //больше, чем
db.project.findOne({due_date:{$gte: new Date(2022,12,1)}}) //больше или равно, чем
db.project.find({due_date:{$ne: new Date(2022,12,31)}}) //не равно
db.project.find({$and:[
    {due_date:{$lte: new Date(2022,12,1)}},
    {name:{$ne: "Открытия"}},
]}) 



db.users.update(
    {fullname: "Gena"},
    {
        $set: {
            posts: [
                {title: "JavaScript", text: "js top"},
                {title: "mongo", text: "mongo database"},
            ]
        }
    }
)

/*
{ _id: ObjectId("629e2c56c088b8c40352f2cc"),
  name: 'Инженерный отдел' }
{ _id: ObjectId("629e2cf2c088b8c40352f2cd"),
  name: 'Бухгалтерия' }
{ _id: ObjectId("629e2cf2c088b8c40352f2ce"),
  name: 'Отдел развития' }
{ _id: ObjectId("629e2db7c088b8c40352f2d0"),
  name: 'Отдел информационных технологий' }
{ _id: ObjectId("629e2db7c088b8c40352f2d1"),
  name: 'Управление операциями' }
{ _id: ObjectId("629e2db7c088b8c40352f2d2"), name: 'СЭБ' }
*/

/*
{ _id: ObjectId("629e3a8ac088b8c40352f2df"),
  name: 'Инвестпрограмма',
  due_date: 2022-12-31T21:00:00.000Z,
  start_date: 2022-01-31T21:00:00.000Z,
  status: 'в работе' }
{ _id: ObjectId("629e3a8ac088b8c40352f2e0"),
  name: 'Редизайны',
  due_date: 2023-01-30T21:00:00.000Z,
  start_date: 2022-01-31T21:00:00.000Z,
  end_date: 2022-03-31T21:00:00.000Z,
  status: 'приостановлено' }
{ _id: ObjectId("629e3a8ac088b8c40352f2e1"),
  name: 'Открытия',
  due_date: 2022-10-31T21:00:00.000Z,
  start_date: 2022-01-31T21:00:00.000Z,
  end_date: 2022-03-31T21:00:00.000Z,
  status: 'приостановлено' }
{ _id: ObjectId("629e3a8ac088b8c40352f2e2"),
  name: 'Закупка ключевого оборудования',
  due_date: 2022-09-30T21:00:00.000Z,
  start_date: 2021-01-31T21:00:00.000Z,
  status: 'в работе' }
*/

/*
{ _id: ObjectId("629e3774c088b8c40352f2d5"),
  name: 'Васильев Вася',
  position: 'Инженигер',
  id_department: ObjectId("629e2c56c088b8c40352f2cc") }
{ _id: ObjectId("629e3774c088b8c40352f2d6"),
  name: 'Иванов Иван',
  position: 'Инженигер',
  id_department: ObjectId("629e2c56c088b8c40352f2cc") }
{ _id: ObjectId("629e3774c088b8c40352f2d7"),
  name: 'Месси Лионель',
  position: 'Менеджер',
  id_department: ObjectId("629e2cf2c088b8c40352f2ce") }
{ _id: ObjectId("629e3774c088b8c40352f2d8"),
  name: 'Трумен Гарри',
  position: 'Главный инженегр',
  id_department: ObjectId("629e2c56c088b8c40352f2cc") }
{ _id: ObjectId("629e3774c088b8c40352f2d9"),
  name: 'Рузвельт Франклин',
  position: 'Специалист',
  id_department: ObjectId("629e2db7c088b8c40352f2d2") }
{ _id: ObjectId("629e3774c088b8c40352f2da"),
  name: 'Брежнев Леонид',
  position: 'Системотехник',
  id_department: ObjectId("629e2db7c088b8c40352f2d0") }
{ _id: ObjectId("629e3774c088b8c40352f2db"),
  name: 'Горбачев Миша',
  position: 'Инженер по инвестремонтам',
  id_department: ObjectId("629e2c56c088b8c40352f2cc") }
{ _id: ObjectId("629e3774c088b8c40352f2dc"),
  name: 'Путин Вова',
  position: 'ДФ',
  id_department: ObjectId("629e2db7c088b8c40352f2d1") }
{ _id: ObjectId("629e3774c088b8c40352f2dd"),
  name: 'Сталин Иосиф',
  position: 'Супервайзер',
  id_department: ObjectId("629e2db7c088b8c40352f2d1") }
{ _id: ObjectId("629e380ec088b8c40352f2de"),
  name: 'Васильев Вася',
  position: 'Инженигер',
  id_department: ObjectId("629e2c56c088b8c40352f2cc") }
*/