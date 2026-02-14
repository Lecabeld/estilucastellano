async function loadMetrics(articleId, type) {

  const articles = await fetch("/assets/data/articles.json").then(r => r.json());
  const metricsStore = await fetch("/assets/data/metrics-store.json").then(r => r.json());

  const article = articles.find(a => a.id === articleId);
  const dynamic = calculateDynamicMetrics(article, metricsStore);
  const profile = METRIC_PROFILES[type];

  const container = document.querySelector(".article-metrics");
  if (!container) return;

  container.innerHTML = "";

  profile.forEach(metric => {

    let value = "";

    if (article.structure[metric] !== undefined) {
      value = article.structure[metric];
    } else if (article.editorial[metric] !== undefined) {
      value = article.editorial[metric];
    } else if (dynamic[metric] !== undefined) {
      value = dynamic[metric];
    }

    if (value) {
      const badge = document.createElement("span");
      badge.className = "metric-badge";
      badge.textContent = formatMetric(metric, value);
      container.appendChild(badge);
    }

  });
}

function formatMetric(metric, value) {

  const labels = {
    isGrammarBase: "Base Gramatical",
    isPillar: "Contenido Pilar",
    isFeatured: "Destacado",
    isRecommended: "Recomendado",
    isTrending: "En Tendencia",
    mostDownloaded: "M¨¢s Descargado",
    level: "Nivel: " + value,
    isUpdated: "Actualizado"
  };

  return labels[metric] || metric;
}
