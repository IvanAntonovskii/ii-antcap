import 'package:hive/hive.dart';

part 'token_models.g.dart';

@HiveType(typeId: 0)
class TokenData {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String symbol;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final double? currentPrice;
  
  @HiveField(4)
  final double? priceChange24h;
  
  @HiveField(5)
  final double? priceChange7d;
  
  @HiveField(6)
  final double? marketCap;
  
  @HiveField(7)
  final double? volume24h;
  
  @HiveField(8)
  final int? holders;
  
  @HiveField(9)
  final double? totalSupply;
  
  @HiveField(10)
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

  factory TokenData.fromCoinGecko(Map<String, dynamic> json) {
    return TokenData(
      id: json['id'],
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      name: json['name'] ?? '',
      currentPrice: json['market_data']?['current_price']?['usd']?.toDouble(),
      priceChange24h: json['market_data']?['price_change_percentage_24h']?.toDouble(),
      priceChange7d: json['market_data']?['price_change_percentage_7d']?.toDouble(),
      marketCap: json['market_data']?['market_cap']?['usd']?.toDouble(),
      volume24h: json['market_data']?['total_volume']?['usd']?.toDouble(),
      imageUrl: json['image']?['small'],
    );
  }

  factory TokenData.fromSearch(Map<String, dynamic> json) {
    return TokenData(
      id: json['id'],
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['thumb'],
    );
  }
}

@HiveType(typeId: 1)
class AnalysisReport {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final TokenData tokenData;
  
  @HiveField(2)
  final AIAnalysisResponse aiAnalysis;
  
  @HiveField(3)
  final DateTime timestamp;

  AnalysisReport({
    required this.id,
    required this.tokenData,
    required this.aiAnalysis,
    required this.timestamp,
  });
}

@HiveType(typeId: 2)
class AIAnalysisResponse {
  @HiveField(0)
  final String verdict;
  
  @HiveField(1)
  final String reasoning;
  
  @HiveField(2)
  final String recommendedHoldTime;
  
  @HiveField(3)
  final int riskLevel;
  
  @HiveField(4)
  final double confidence;
  
  @HiveField(5)
  final Map<String, double> keyMetrics;
  
  @HiveField(6)
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

@HiveType(typeId: 3)
class AnalysisFactors {
  @HiveField(0)
  final List<String> positive;
  
  @HiveField(1)
  final List<String> negative;
  
  @HiveField(2)
  final List<String> technical;
  
  @HiveField(3)
  final List<String> fundamental;

  AnalysisFactors({
    required this.positive,
    required this.negative,
    required this.technical,
    required this.fundamental,
  });
}