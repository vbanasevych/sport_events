// 1. Створення колекції
db.createCollection("match_live_feeds");

// 2. Вставка складного документа трансляції
db.match_live_feeds.insertOne({
  _id: "match_501",
  event_id: 10,
  sport: "Football",
  status: "LIVE",
  current_score: { team_a: 2, team_b: 1 },
  broadcast_events: [
    {
      minute: 14,
      event_type: "GOAL",
      player_id: 105,
      team_id: 20,
      description: "Неймовірний удар з-за меж штрафного!",
      metadata: { assist_by: 102, distance_meters: 22 }
    },
    {
      minute: 32,
      event_type: "YELLOW_CARD",
      player_id: 201,
      team_id: 21,
      description: "Жорсткий фол у центрі поля.",
      metadata: { reason: "Foul" }
    }
  ],
  viewers_online: 45000
});

// 3. Читання трансляції
db.match_live_feeds.findOne({ _id: "match_501" });

// 4. Додавання нової події до існуючої трансляції (наприклад, ще один гол)
db.match_live_feeds.updateOne(
  { _id: "match_501" },
  { 
    $push: { 
      broadcast_events: {
        minute: 45,
        event_type: "GOAL",
        player_id: 10,
        description: "Гол у роздягальню!",
        metadata: { penalty: true }
      } 
    },
    $set: { "current_score.team_a": 3 }
  }
);