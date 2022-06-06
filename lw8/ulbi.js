db.users.insertMany([
    {name: "Gena", age: 48},
    {name: "Tata", age: 33},
    {name: "Mata", age: 25},
    {name: "Antonio", age: 24},
    {name: "Ulbi", age: 22},
])

db.dropDatabase()

db.createCollection("users")

db.users.insertOne({
    name: "ulbitv",
    age: 25
})

db.users.find({age: 25})

db.users.find({$or:[{name: "Ulbi"}, {age: 33}]})

db.users.find({age:{$lt: 28}})

db.users.find({age:{$lte: 25}}) //менье или равно

db.users.find({age:{$gt: 25}}) //больше, чем
db.users.find({age:{$gte: 25}}) //больше или равно, чем

db.users.find({age:{$ne: 25}}) //не равно

db.users.find().sort({age: 1}) //1 - сортировка по возрастанию, -1 по убыванию

db.users.find().limit(4)

db.users.findOne({_id: ObjectId("629adfbf9fe133696c25faba")})

db.users.distinct()

db.users.update(
    {name: "ulbitv"},
    {
        $set: {
            name: "Ilon Mask",
            age: 25
        }
    }
)

db.users.updateMany(
    {},
    {
        $rename: {
            name: "fullname"
        }
    }
)

db.users.deleteOne({age: 24})

db.users.bulkWrite([
    {
        insertOne: {
            document: {fullname: "Nastya", age: 22}
        }
    },
    {
        deleteOne: {
            filter: {fullname: "Tata"}
        }
    }
])

//связь один ко многим
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

db.users.findOne(
    {fullname: "Gena"},
    {posts:1}
)

db.users.find(
    {
        posts: {
            $elemMatch: {
                title: "JavaScript"
            }
        }
    }    
)

db.users.find({posts:{$exists: true}})