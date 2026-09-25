// Упрощенные модели без Hive для начала
class TokenData {
  final String id;
  final String symbol;
  final String name;
  final double? currentPrice;
  final double? priceChange24h;
  final double? priceChange7d;
  final double? marketCap;
  final double? volume24h;
  final int? holders;
  final double? totalSupply;
  final String? imageUrl;

  TokenData({
    required this.id,
    required this.symbol,
    required this.name,
    this.currentPrice,
    this.priceChange24h,
    this.priceChange7d,
    this.marketCap,
    this.volume24h,
    this.holders,
    this.totalSupply,
    this.imageUrl,
  });
}

class AnalysisReport {
  final String id;
  final TokenData tokenData;
  final AIAnalysisResponse aiAnalysis;
  final DateTime timestamp;

  AnalysisReport({
    required this.id,
    required this.tokenData,
    required this.aiAnalysis,
    required this.timestamp,
  });
}

class AIAnalysisResponse {
  final String verdict;
  final String reasoning;
  final String recommendedHoldTime;
  final int riskLevel;
  final double confidence;
  final Map<String, double> keyMetrics;
  final AnalysisFactors factors;

  AIAnalysisResponse({
    required this.verdict,
    required this.reasoning,
    required this.recommendedHoldTime,
    required this.riskLevel,
    required this.confidence,
    required this.keyMetrics,
    required this.factors,
  });
}

class AnalysisFactors {
  final List<String> positive;
  final List<String> negative;
  final List<String> technical;
  final List<String> fundamental;

  AnalysisFactors({
    required this.positive,
    required this.negative,
    required this.technical,
    required this.fundamental,
  });
}