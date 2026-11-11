// 1. Створюємо пустий матч
db.match_live_feeds.insertOne({ _id: "match_999", broadcast_events: [] });

// 2. Генеруємо масив з 50 000 подій
let events = [];
for(let i=0; i<50000; i++){
    events.push({ minute: i%90, event_type: "TEST", desc: "Test " + i });
}

// 3. Записуємо їх в базу
db.match_live_feeds.updateOne({ _id: "match_999" }, { $push: { broadcast_events: { $each: events } } });

// 4. Заміряємо час читання цього документа
let start = new Date();
let match = db.match_live_feeds.findOne({ _id: "match_999" });
let end = new Date();
print("Час читання 50,000 вкладених записів у MongoDB: " + (end - start) + " мілісекунд");