function calculateDynamicMetrics(article, metricsData) {

  const data = metricsData[article.id];

  return {
    isTrending: data.views > 800,
    mostDownloaded: data.downloads > 200
  };
}
