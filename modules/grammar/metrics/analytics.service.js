class AnalyticsService {

  static trackView(userId, lessonId) {
    console.log('View tracked:', userId, lessonId);
  }

  static trackProgress(userId, lessonId, score, timeSpent) {
    console.log('Progress tracked:', userId, lessonId, score, timeSpent);
  }

  static trackCompletionRate(completedLessons, totalLessons) {
    return completedLessons / totalLessons;
  }

  static detectDropOff(timeSpent, estimatedTime) {
    return timeSpent < estimatedTime * 0.3;
  }

}

module.exports = AnalyticsService;
