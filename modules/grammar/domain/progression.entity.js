class Progression {
  constructor({ userId, lessonId, completed, score, timeSpent }) {
    this.userId = userId;
    this.lessonId = lessonId;
    this.completed = completed;
    this.score = score;
    this.timeSpent = timeSpent;
  }
}
module.exports = Progression;
