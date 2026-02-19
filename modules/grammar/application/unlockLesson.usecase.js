function canAccess(userLevel, lessonLevel) {
  const hierarchy = { public: 0, basic: 1, premium: 2 };
  return hierarchy[userLevel] >= hierarchy[lessonLevel];
}

module.exports = canAccess;
