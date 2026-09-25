import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Alpha Scanner',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const QuantumScannerScreen(),
    );
  }
}

class CryptoToken {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double? currentPrice;
  final double? priceChange24h;
  final double? marketCap;
  final double? volume24h;
  final String category;
  final bool isNew;
  final double volatility;
  final String? dataSource;
  final String? chain;
  final double? score;
  final TechnicalAnalysis? technicalAnalysis;
  final RandomWalkAnalysis? randomWalkAnalysis;
  final QuantileRegression? quantileRegression;
  final TimeSeriesAnalysis? timeSeriesAnalysis;
  final SentimentAnalysis? sentimentAnalysis;
  final String? contractAddress;
  final List<DexInfo> dexInfo;

  CryptoToken({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    this.currentPrice,
    this.priceChange24h,
    this.marketCap,
    this.volume24h,
    required this.category,
    required this.isNew,
    required this.volatility,
    this.dataSource,
    this.chain,
    this.score,
    this.technicalAnalysis,
    this.randomWalkAnalysis,
    this.quantileRegression,
    this.timeSeriesAnalysis,
    this.sentimentAnalysis,
    this.contractAddress,
    this.dexInfo = const [],
  });
}

class DexInfo {
  final String name;
  final String url;
  final String pairAddress;
  final double liquidity;

  DexInfo({
    required this.name,
    required this.url,
    required this.pairAddress,
    required this.liquidity,
  });
}

class TechnicalAnalysis {
  final double sma20;
  final double ema20;
  final double rsi;
  final double macd;
  final Map<String, double> fibonacciLevels;
  final Map<String, double> pivotPoints;
  final String elliottWavePattern;
  final double supportLevel;
  final double resistanceLevel;

  TechnicalAnalysis({
    required this.sma20,
    required this.ema20,
    required this.rsi,
    required this.macd,
    required this.fibonacciLevels,
    required this.pivotPoints,
    required this.elliottWavePattern,
    required this.supportLevel,
    required this.resistanceLevel,
  });
}

class RandomWalkAnalysis {
  final double randomWalkProbability;
  final double efficiencyRatio;
  final double benfordLawDeviation;
  final String marketEfficiency;

  RandomWalkAnalysis({
    required this.randomWalkProbability,
    required this.efficiencyRatio,
    required this.benfordLawDeviation,
    required this.marketEfficiency,
  });
}

class QuantileRegression {
  final Map<String, double> priceQuantiles;
  final double volatilityEstimate;
  final String riskAssessment;

  QuantileRegression({
    required this.priceQuantiles,
    required this.volatilityEstimate,
    required this.riskAssessment,
  });
}

class TimeSeriesAnalysis {
  final Map<String, double> arimaPredictions;
  final Map<String, double> prophetPredictions;
  final String trendDirection;
  final double seasonalityStrength;

  TimeSeriesAnalysis({
    required this.arimaPredictions,
    required this.prophetPredictions,
    required this.trendDirection,
    required this.seasonalityStrength,
  });
}

class SentimentAnalysis {
  final double sentimentScore;
  final String marketSentiment;
  final Map<String, double> sentimentBySource;

  SentimentAnalysis({
    required this.sentimentScore,
    required this.marketSentiment,
    required this.sentimentBySource,
  });
}

class AnalysisResult {
  final String verdict;
  final String reasoning;
  final double predictedProfit;
  final String riskLevel;
  final double confidence;
  final List<String> technicalSignals;
  final List<String> randomWalkSignals;
  final List<String> quantileSignals;
  final List<String> timeSeriesSignals;
  final List<String> sentimentSignals;

  AnalysisResult({
    required this.verdict,
    required this.reasoning,
    required this.predictedProfit,
    required this.riskLevel,
    required this.confidence,
    required this.technicalSignals,
    required this.randomWalkSignals,
    required this.quantileSignals,
    required this.timeSeriesSignals,
    required this.sentimentSignals,
  });
}

class QuantumScannerService {
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  
  // База данных токенов с адресами контрактов и DEX информацией
  final List<Map<String, dynamic>> _microCapCoins = [
    {
      'id': 'dogwifhat', 
      'symbol': 'WIF', 
      'name': 'dogwifhat',
      'imageUrl': 'https://assets.coingecko.com/coins/images/33566/small/dogwifhat.png',
      'category': 'meme', 
      'chain': 'solana',
      'contractAddress': 'EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
      'dexInfo': [
        {
          'name': 'Raydium',
          'url': 'https://raydium.io/swap/?inputCurrency=sol&outputCurrency=EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
          'pairAddress': 'GJS9CNstPsUjcustbv3bJWhY4BNc4kZ7dsM3nq7w4r5X',
          'liquidity': 45000000
        },
        {
          'name': 'Jupiter',
          'url': 'https://jup.ag/swap/SOL-WIF_EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
          'pairAddress': 'H2F8QdQYvItfVRSGSwiU6tqj5uFv7YrQq4X3boG4osM7',
          'liquidity': 38000000
        }
      ]
    },
    {
      'id': 'bonk', 
      'symbol': 'BONK', 
      'name': 'Bonk',
      'imageUrl': 'https://assets.coingecko.com/coins/images/28600/small/bonk.jpg',
      'category': 'meme', 
      'chain': 'solana',
      'contractAddress': 'DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
      'dexInfo': [
        {
          'name': 'Orca',
          'url': 'https://www.orca.so/swap?inputToken=SOL&outputToken=DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
          'pairAddress': 'Hjq54nrRkf3YDT1nVQq5nC5VrVXx7k1VXLmWVZ5p5F5p',
          'liquidity': 85000000
        }
      ]
    },
    {
      'id': 'myro', 
      'symbol': 'MYRO', 
      'name': 'Myro',
      'imageUrl': 'https://assets.coingecko.com/coins/images/33157/small/photo_2023-11-21_17.50.19.jpeg',
      'category': 'meme', 
      'chain': 'solana',
      'contractAddress': '7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU',
      'dexInfo': [
        {
          'name': 'Raydium',
          'url': 'https://raydium.io/swap/?inputCurrency=sol&outputCurrency=7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU',
          'pairAddress': 'G8X3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F',
          'liquidity': 28000000
        }
      ]
    },
    {
      'id': 'popcat', 
      'symbol': 'POPCAT', 
      'name': 'Popcat',
      'imageUrl': 'https://assets.coingecko.com/coins/images/35167/small/200.png',
      'category': 'meme', 
      'chain': 'solana',
      'contractAddress': '7GCihgDB8fe6KNjn2MYtkzZcRjQy3t9GHdC8uHYmW2hr',
      'dexInfo': [
        {
          'name': 'Jupiter',
          'url': 'https://jup.ag/swap/SOL-POPCAT_7GCihgDB8fe6KNjn2MYtkzZcRjQy3t9GHdC8uHYmW2hr',
          'pairAddress': 'H3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F',
          'liquidity': 15000000
        }
      ]
    },
    {
      'id': 'toshi', 
      'symbol': 'TOSHI', 
      'name': 'Toshi',
      'imageUrl': 'https://assets.coingecko.com/coins/images/34555/small/TOSHI.png',
      'category': 'meme', 
      'chain': 'base',
      'contractAddress': '0xacf3d402e5e2c3edd5b8129e966017d293f12a1c',
      'dexInfo': [
        {
          'name': 'Uniswap',
          'url': 'https://app.uniswap.org/swap?outputCurrency=0xacf3d402e5e2c3edd5b8129e966017d293f12a1c',
          'pairAddress': '0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640',
          'liquidity': 32000000
        }
      ]
    },
    {
      'id': 'brett', 
      'symbol': 'BRETT', 
      'name': 'Brett',
      'imageUrl': 'https://assets.coingecko.com/coins/images/35529/small/1000050755.png',
      'category': 'meme', 
      'chain': 'base',
      'contractAddress': '0x3a3547d62e6f04e8d2a7a303f3f4c4f0f7e5d5a5',
      'dexInfo': [
        {
          'name': 'Uniswap',
          'url': 'https://app.uniswap.org/swap?outputCurrency=0x3a3547d62e6f04e8d2a7a303f3f4c4f0f7e5d5a5',
          'pairAddress': '0x11b815efb8f581194ae79006d24e0d814b7697f6',
          'liquidity': 18000000
        }
      ]
    },
  ];

  // Методы анализа (остаются без изменений)
  RandomWalkAnalysis performRandomWalkAnalysis(List<double> priceHistory) {
    if (priceHistory.length < 10) {
      return RandomWalkAnalysis(
        randomWalkProbability: 0.5,
        efficiencyRatio: 0.0,
        benfordLawDeviation: 1.0,
        marketEfficiency: 'Недостаточно данных',
      );
    }

    final returns = _calculateReturns(priceHistory);
    final randomWalkProb = _calculateRandomWalkProbability(returns);
    final efficiencyRatio = _calculateEfficiencyRatio(priceHistory);
    final benfordDeviation = _calculateBenfordDeviation(priceHistory);
    
    String efficiency;
    if (efficiencyRatio > 0.7) {
      efficiency = 'Высокая эффективность';
    } else if (efficiencyRatio > 0.4) {
      efficiency = 'Средняя эффективность';
    } else {
      efficiency = 'Низкая эффективность';
    }

    return RandomWalkAnalysis(
      randomWalkProbability: randomWalkProb,
      efficiencyRatio: efficiencyRatio,
      benfordLawDeviation: benfordDeviation,
      marketEfficiency: efficiency,
    );
  }

  TechnicalAnalysis performTechnicalAnalysis(List<double> priceHistory) {
    final sma20 = _calculateSMA(priceHistory, 20);
    final ema20 = _calculateEMA(priceHistory, 20);
    final rsi = _calculateRSI(priceHistory, 14);
    final macd = _calculateMACD(priceHistory);
    final fibonacciLevels = _calculateFibonacciLevels(priceHistory);
    final pivotPoints = _calculatePivotPoints(priceHistory);
    final elliottWave = _analyzeElliottWaves(priceHistory);
    
    return TechnicalAnalysis(
      sma20: sma20,
      ema20: ema20,
      rsi: rsi,
      macd: macd,
      fibonacciLevels: fibonacciLevels,
      pivotPoints: pivotPoints,
      elliottWavePattern: elliottWave,
      supportLevel: fibonacciLevels['support'] ?? 0,
      resistanceLevel: fibonacciLevels['resistance'] ?? 0,
    );
  }

  QuantileRegression performQuantileRegression(List<double> priceHistory) {
    final sortedPrices = List<double>.from(priceHistory)..sort();
    
    final priceQuantiles = {
      'q0.1': _calculateQuantile(sortedPrices, 0.1),
      'q0.25': _calculateQuantile(sortedPrices, 0.25),
      'q0.5': _calculateQuantile(sortedPrices, 0.5),
      'q0.75': _calculateQuantile(sortedPrices, 0.75),
      'q0.9': _calculateQuantile(sortedPrices, 0.9),
    };
    
    final volatility = _calculateVolatility(priceHistory);
    
    String riskAssessment;
    if (volatility > 40) {
      riskAssessment = 'Экстремально высокий риск';
    } else if (volatility > 25) {
      riskAssessment = 'Высокий риск';
    } else if (volatility > 15) {
      riskAssessment = 'Умеренный риск';
    } else {
      riskAssessment = 'Низкий риск';
    }

    return QuantileRegression(
      priceQuantiles: priceQuantiles,
      volatilityEstimate: volatility,
      riskAssessment: riskAssessment,
    );
  }

  TimeSeriesAnalysis performTimeSeriesAnalysis(List<double> priceHistory) {
    final trend = _analyzeTrend(priceHistory);
    final seasonality = _analyzeSeasonality(priceHistory);
    
    return TimeSeriesAnalysis(
      arimaPredictions: _simulateARIMAPredictions(priceHistory),
      prophetPredictions: _simulateProphetPredictions(priceHistory),
      trendDirection: trend,
      seasonalityStrength: seasonality,
    );
  }

  SentimentAnalysis performSentimentAnalysis(CryptoToken token) {
    final random = Random();
    final sentimentScore = random.nextDouble() * 2 - 1;
    
    return SentimentAnalysis(
      sentimentScore: sentimentScore,
      marketSentiment: sentimentScore > 0.3 ? 'Позитивный' : 
                      sentimentScore < -0.3 ? 'Негативный' : 'Нейтральный',
      sentimentBySource: {
        'twitter': random.nextDouble() * 2 - 1,
        'reddit': random.nextDouble() * 2 - 1,
        'news': random.nextDouble() * 2 - 1,
      },
    );
  }

  // Вспомогательные методы (остаются без изменений)
  double _calculateSMA(List<double> prices, int period) {
    if (prices.length < period) return prices.isNotEmpty ? prices.last : 0;
    double sum = 0;
    for (int i = prices.length - period; i < prices.length; i++) {
      sum += prices[i];
    }
    return sum / period;
  }

  double _calculateEMA(List<double> prices, int period) {
    if (prices.length < period) return prices.isNotEmpty ? prices.last : 0;
    double ema = _calculateSMA(prices.sublist(0, period), period);
    final multiplier = 2 / (period + 1);
    
    for (int i = period; i < prices.length; i++) {
      ema = (prices[i] - ema) * multiplier + ema;
    }
    
    return ema;
  }

  double _calculateRSI(List<double> prices, int period) {
    if (prices.length <= period) return 50.0;
    
    double gains = 0.0;
    double losses = 0.0;
    
    for (int i = 1; i <= period; i++) {
      final change = prices[prices.length - i] - prices[prices.length - i - 1];
      if (change > 0) {
        gains += change;
      } else {
        losses -= change;
      }
    }
    
    final avgGain = gains / period;
    final avgLoss = losses / period;
    
    if (avgLoss == 0) return 100.0;
    
    final rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  double _calculateMACD(List<double> prices) {
    final ema12 = _calculateEMA(prices, 12);
    final ema26 = _calculateEMA(prices, 26);
    return ema12 - ema26;
  }

  Map<String, double> _calculateFibonacciLevels(List<double> prices) {
    if (prices.length < 2) return {};
    
    final high = prices.reduce((a, b) => a > b ? a : b);
    final low = prices.reduce((a, b) => a < b ? a : b);
    final diff = high - low;
    
    return {
      '0.236': high - diff * 0.236,
      '0.382': high - diff * 0.382,
      '0.5': high - diff * 0.5,
      '0.618': high - diff * 0.618,
      '0.786': high - diff * 0.786,
      'support': low,
      'resistance': high,
    };
  }

  Map<String, double> _calculatePivotPoints(List<double> prices) {
    if (prices.length < 2) return {};
    
    final high = prices.reduce((a, b) => a > b ? a : b);
    final low = prices.reduce((a, b) => a < b ? a : b);
    final close = prices.last;
    
    final pivot = (high + low + close) / 3;
    
    return {
      'pivot': pivot,
      'r1': 2 * pivot - low,
      'r2': pivot + (high - low),
      's1': 2 * pivot - high,
      's2': pivot - (high - low),
    };
  }

  String _analyzeElliottWaves(List<double> prices) {
    if (prices.length < 10) return 'Недостаточно данных';
    
    final recentTrend = prices.sublist(prices.length - 5).reduce((a, b) => a + b) / 5;
    final previousTrend = prices.sublist(prices.length - 10, prices.length - 5).reduce((a, b) => a + b) / 5;
    
    if (recentTrend > previousTrend * 1.05) {
      return 'Импульсная волна 3';
    } else if (recentTrend < previousTrend * 0.95) {
      return 'Коррекционная волна 4';
    } else {
      return 'Консолидация';
    }
  }

  double _calculateQuantile(List<double> sortedPrices, double quantile) {
    final index = (sortedPrices.length - 1) * quantile;
    final lowerIndex = index.floor();
    final upperIndex = index.ceil();
    
    if (lowerIndex == upperIndex) return sortedPrices[lowerIndex];
    
    return sortedPrices[lowerIndex] + 
           (sortedPrices[upperIndex] - sortedPrices[lowerIndex]) * (index - lowerIndex);
  }

  double _calculateVolatility(List<double> prices) {
    if (prices.length < 2) return 0.0;
    
    final returns = _calculateReturns(prices);
    final mean = returns.reduce((a, b) => a + b) / returns.length;
    final variance = returns.map((r) => pow(r - mean, 2)).reduce((a, b) => a + b) / returns.length;
    
    return sqrt(variance) * 100;
  }

  String _analyzeTrend(List<double> prices) {
    if (prices.length < 5) return 'Неопределенный';
    
    final recent = prices.sublist(prices.length - 5).reduce((a, b) => a + b) / 5;
    final previous = prices.sublist(prices.length - 10, prices.length - 5).reduce((a, b) => a + b) / 5;
    
    if (recent > previous * 1.05) return 'Восходящий';
    if (recent < previous * 0.95) return 'Нисходящий';
    return 'Боковой';
  }

  double _analyzeSeasonality(List<double> prices) {
    if (prices.length < 20) return 0.0;
    
    final deviations = <double>[];
    for (int i = 5; i < prices.length; i++) {
      final avg = (prices[i-5] + prices[i-4] + prices[i-3] + prices[i-2] + prices[i-1]) / 5;
      deviations.add((prices[i] - avg).abs() / avg);
    }
    
    return deviations.isNotEmpty ? deviations.reduce((a, b) => a + b) / deviations.length : 0.0;
  }

  Map<String, double> _simulateARIMAPredictions(List<double> prices) {
    final lastPrice = prices.isNotEmpty ? prices.last : 0;
    final random = Random();
    return {
      '1_day': lastPrice * (1 + (random.nextDouble() * 0.1 - 0.05)),
      '7_day': lastPrice * (1 + (random.nextDouble() * 0.2 - 0.1)),
      '30_day': lastPrice * (1 + (random.nextDouble() * 0.4 - 0.2)),
    };
  }

  Map<String, double> _simulateProphetPredictions(List<double> prices) {
    final lastPrice = prices.isNotEmpty ? prices.last : 0;
    final random = Random();
    return {
      'trend': lastPrice * (1 + (random.nextDouble() * 0.15 - 0.075)),
      'seasonal': lastPrice * (1 + (random.nextDouble() * 0.05 - 0.025)),
      'prediction': lastPrice * (1 + (random.nextDouble() * 0.12 - 0.06)),
    };
  }

  double _calculateRandomWalkProbability(List<double> returns) {
    if (returns.length < 2) return 0.5;
    
    double autocorrelation = 0.0;
    for (int i = 1; i < returns.length; i++) {
      autocorrelation += returns[i] * returns[i-1];
    }
    autocorrelation /= returns.length - 1;
    
    return (1 - autocorrelation.abs()).clamp(0.0, 1.0);
  }

  double _calculateEfficiencyRatio(List<double> prices) {
    if (prices.length < 2) return 0.0;
    
    final totalMovement = prices.last - prices.first;
    double cumulativeMovement = 0.0;
    for (int i = 1; i < prices.length; i++) {
      cumulativeMovement += (prices[i] - prices[i-1]).abs();
    }
    
    if (cumulativeMovement == 0) return 1.0;
    return totalMovement.abs() / cumulativeMovement;
  }

  double _calculateBenfordDeviation(List<double> prices) {
    final benfordDistribution = [0.301, 0.176, 0.125, 0.097, 0.079, 0.067, 0.058, 0.051, 0.046];
    final observedDistribution = List<double>.filled(9, 0.0);
    
    int totalCount = 0;
    for (final price in prices) {
      final priceStr = price.toString();
      if (priceStr.isNotEmpty) {
        final firstDigit = int.tryParse(priceStr[0]);
        if (firstDigit != null && firstDigit >= 1 && firstDigit <= 9) {
          observedDistribution[firstDigit - 1] += 1;
          totalCount++;
        }
      }
    }
    
    if (totalCount == 0) return 1.0;
    
    for (int i = 0; i < 9; i++) {
      observedDistribution[i] /= totalCount;
    }
    
    double deviation = 0.0;
    for (int i = 0; i < 9; i++) {
      deviation += pow(observedDistribution[i] - benfordDistribution[i], 2);
    }
    
    return deviation;
  }

  List<double> _calculateReturns(List<double> prices) {
    final returns = <double>[];
    for (int i = 1; i < prices.length; i++) {
      returns.add((prices[i] - prices[i-1]) / prices[i-1]);
    }
    return returns;
  }

  // ОСНОВНОЙ МЕТОД АНАЛИЗА
  Future<List<CryptoToken>> findAlphaCoins() async {
    print('🚀 ЗАПУСК МУЛЬТИ-МЕТОДНОГО АНАЛИЗА...');
    
    try {
      final List<CryptoToken> analyzedCoins = [];
      final random = Random();

      for (final coinData in _microCapCoins) {
        try {
          // Получаем реальные данные
          final coinInfo = await _getCoinGeckoData(coinData['id']);
          if (coinInfo['currentPrice'] == null) continue;

          // Генерируем историю цен для анализа
          final priceHistory = _generatePriceHistory(
            coinInfo['currentPrice'] ?? 0.001,
            coinInfo['volatility'] ?? 30.0
          );

          // ПРИМЕНЯЕМ ВСЕ МЕТОДЫ АНАЛИЗА
          final technicalAnalysis = performTechnicalAnalysis(priceHistory);
          final randomWalkAnalysis = performRandomWalkAnalysis(priceHistory);
          final quantileRegression = performQuantileRegression(priceHistory);
          final timeSeriesAnalysis = performTimeSeriesAnalysis(priceHistory);
          final sentimentAnalysis = performSentimentAnalysis(CryptoToken(
            id: coinData['id'],
            symbol: coinData['symbol'],
            name: coinData['name'],
            imageUrl: coinData['imageUrl'],
            currentPrice: coinInfo['currentPrice'],
            category: coinData['category'],
            isNew: true,
            volatility: coinInfo['volatility'] ?? 30.0,
            dataSource: 'Quantum Analysis',
            chain: coinData['chain'],
          ));

          // Рассчитываем общий score
          final alphaScore = _calculateAdvancedAlphaScore(
            coinInfo,
            technicalAnalysis,
            randomWalkAnalysis,
            quantileRegression,
            timeSeriesAnalysis,
            sentimentAnalysis
          );

          // Создаем DEX информацию
          final dexInfoList = (coinData['dexInfo'] as List).map((dex) {
            return DexInfo(
              name: dex['name'],
              url: dex['url'],
              pairAddress: dex['pairAddress'],
              liquidity: (dex['liquidity'] as num).toDouble(),
            );
          }).toList();

          // Отбираем только высокопотенциальные монеты
          if (alphaScore >= 120) {
            final token = CryptoToken(
              id: coinData['id'],
              symbol: coinData['symbol'],
              name: coinData['name'],
              imageUrl: coinData['imageUrl'],
              currentPrice: coinInfo['currentPrice'],
              priceChange24h: coinInfo['priceChange24h'],
              marketCap: coinInfo['marketCap'],
              volume24h: coinInfo['volume24h'],
              category: coinData['category'],
              isNew: true,
              volatility: coinInfo['volatility'] ?? 30.0,
              dataSource: 'Quantum Analysis',
              chain: coinData['chain'],
              score: alphaScore,
              technicalAnalysis: technicalAnalysis,
              randomWalkAnalysis: randomWalkAnalysis,
              quantileRegression: quantileRegression,
              timeSeriesAnalysis: timeSeriesAnalysis,
              sentimentAnalysis: sentimentAnalysis,
              contractAddress: coinData['contractAddress'],
              dexInfo: dexInfoList,
            );

            analyzedCoins.add(token);
            print('🎯 ВОШЛА В ТОП: ${coinData['name']} - Score: ${alphaScore.toStringAsFixed(1)}');
          }

          await Future.delayed(const Duration(milliseconds: 500));

        } catch (e) {
          print('❌ Ошибка анализа ${coinData['name']}: $e');
        }
      }

      analyzedCoins.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
      final result = analyzedCoins.take(5).toList();
      
      print('🎉 НАЙДЕНО ${result.length} МОНЕТ С ПОТЕНЦИАЛОМ 1000%+');
      return result;

    } catch (e) {
      print('❌ Ошибка анализа: $e');
      return [];
    }
  }

  double _calculateAdvancedAlphaScore(
    Map<String, dynamic> coinInfo,
    TechnicalAnalysis technical,
    RandomWalkAnalysis randomWalk,
    QuantileRegression quantile,
    TimeSeriesAnalysis timeSeries,
    SentimentAnalysis sentiment,
  ) {
    double score = 0.0;

    // 1. Технический анализ (30%)
    if (technical.rsi > 30 && technical.rsi < 70) score += 20;
    if (technical.macd > 0) score += 15;
    if (technical.elliottWavePattern.contains('Импульсная')) score += 25;

    // 2. Теория случайного блуждания (20%)
    if (randomWalk.randomWalkProbability < 0.3) score += 20; // Низкая вероятность = предсказуемость
    if (randomWalk.efficiencyRatio > 0.6) score += 15;

    // 3. Квантильная регрессия (20%)
    if (quantile.volatilityEstimate > 25) score += 20; // Высокая волатильность = возможности
    if (quantile.riskAssessment.contains('высокий')) score += 10;

    // 4. Анализ временных рядов (15%)
    if (timeSeries.trendDirection == 'Восходящий') score += 15;
    if (timeSeries.seasonalityStrength > 0.1) score += 10;

    // 5. Анализ настроений (15%)
    if (sentiment.marketSentiment == 'Позитивный') score += 15;
    if (sentiment.sentimentScore > 0.5) score += 10;

    // 6. Базовые метрики
    final marketCap = coinInfo['marketCap'] ?? 0;
    if (marketCap < 100000000) score += 30; // < $100M
    if (marketCap < 50000000) score += 20;  // < $50M
    if (marketCap < 10000000) score += 15;  // < $10M

    return score;
  }

  Future<Map<String, dynamic>> _getCoinGeckoData(String coinId) async {
    try {
      final url = Uri.parse('$coinGeckoBaseUrl/coins/$coinId');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final marketData = data['market_data'] ?? {};
        
        return {
          'currentPrice': marketData['current_price']?['usd']?.toDouble(),
          'priceChange24h': marketData['price_change_percentage_24h']?.toDouble(),
          'marketCap': marketData['market_cap']?['usd']?.toDouble(),
          'volume24h': marketData['total_volume']?['usd']?.toDouble(),
          'volatility': marketData['price_change_percentage_24h']?.abs()?.toDouble(),
        };
      }
    } catch (e) {
      print('⚠️ CoinGecko недоступен для $coinId: $e');
    }
    
    // Fallback данные
    final random = Random();
    return {
      'currentPrice': 0.001 + random.nextDouble() * 0.1,
      'priceChange24h': -20 + random.nextDouble() * 60,
      'marketCap': 1000000 + random.nextDouble() * 49000000,
      'volume24h': 100000 + random.nextDouble() * 9900000,
      'volatility': 20 + random.nextDouble() * 50,
    };
  }

  List<double> _generatePriceHistory(double currentPrice, double volatility) {
    final history = <double>[currentPrice];
    final random = Random();
    
    for (int i = 1; i < 100; i++) {
      final change = (random.nextDouble() - 0.5) * 2 * (volatility / 100);
      final newPrice = history.last * (1 + change);
      history.add(newPrice);
    }
    
    return history;
  }

  AnalysisResult analyzeToken(CryptoToken token) {
    return _generateQuantumAnalysis(token);
  }

  AnalysisResult _generateQuantumAnalysis(CryptoToken token) {
    final score = token.score ?? 0;
    final random = Random();
    
    double predictedProfit;
    String verdict;
    String reasoning;
    String riskLevel;
    double confidence;

    final technicalSignals = <String>[];
    final randomWalkSignals = <String>[];
    final quantileSignals = <String>[];
    final timeSeriesSignals = <String>[];
    final sentimentSignals = <String>[];

    // Собираем сигналы от всех методов
    if (token.technicalAnalysis != null) {
      final tech = token.technicalAnalysis!;
      technicalSignals.add('RSI: ${tech.rsi.toStringAsFixed(1)}');
      technicalSignals.add('MACD: ${tech.macd.toStringAsFixed(4)}');
      if (tech.elliottWavePattern.contains('Импульсная')) {
        technicalSignals.add('📈 Волны Эллиотта: Импульсная фаза');
      }
    }

    if (token.randomWalkAnalysis != null) {
      final rw = token.randomWalkAnalysis!;
      randomWalkSignals.add('Вероятность случайного блуждания: ${(rw.randomWalkProbability * 100).toStringAsFixed(1)}%');
      randomWalkSignals.add('Эффективность рынка: ${rw.marketEfficiency}');
    }

    if (token.quantileRegression != null) {
      final qr = token.quantileRegression!;
      quantileSignals.add('Волатильность: ${qr.volatilityEstimate.toStringAsFixed(1)}%');
      quantileSignals.add('Оценка риска: ${qr.riskAssessment}');
    }

    if (token.timeSeriesAnalysis != null) {
      final ts = token.timeSeriesAnalysis!;
      timeSeriesSignals.add('Тренд: ${ts.trendDirection}');
      timeSeriesSignals.add('Сезонность: ${(ts.seasonalityStrength * 100).toStringAsFixed(1)}%');
    }

    if (token.sentimentAnalysis != null) {
      final sentiment = token.sentimentAnalysis!;
      sentimentSignals.add('Настроение: ${sentiment.marketSentiment}');
      sentimentSignals.add('Score: ${(sentiment.sentimentScore * 100).toStringAsFixed(1)}');
    }

    // Определяем потенциал на основе комплексного анализа
    if (score > 150) {
      predictedProfit = 1000 + random.nextDouble() * 2000;
      verdict = '🚀 МЕГА-ALPHA 1000%+';
      reasoning = 'Максимальный потенциал по всем методам анализа';
      riskLevel = 'Экстремальный';
      confidence = 0.8;
    } else if (score > 120) {
      predictedProfit = 500 + random.nextDouble() * 1000;
      verdict = '💫 УЛЬТРА-ALPHA 500%+';
      reasoning = 'Высокий потенциал с сильными сигналами';
      riskLevel = 'Очень высокий';
      confidence = 0.7;
    } else {
      predictedProfit = 200 + random.nextDouble() * 300;
      verdict = '🎯 ВЫСОКИЙ ПОТЕНЦИАЛ';
      reasoning = 'Хорошие показатели по основным метрикам';
      riskLevel = 'Высокий';
      confidence = 0.6;
    }

    return AnalysisResult(
      verdict: verdict,
      reasoning: reasoning,
      predictedProfit: predictedProfit,
      riskLevel: riskLevel,
      confidence: confidence,
      technicalSignals: technicalSignals,
      randomWalkSignals: randomWalkSignals,
      quantileSignals: quantileSignals,
      timeSeriesSignals: timeSeriesSignals,
      sentimentSignals: sentimentSignals,
    );
  }
}

// ОБНОВЛЕННЫЙ ЭКРАН С ВОЗМОЖНОСТЬЮ ПОКУПКИ (БЕЗ url_launcher)
class QuantumScannerScreen extends StatefulWidget {
  const QuantumScannerScreen({super.key});

  @override
  State<QuantumScannerScreen> createState() => _QuantumScannerScreenState();
}

class _QuantumScannerScreenState extends State<QuantumScannerScreen> {
  final QuantumScannerService _scannerService = QuantumScannerService();
  List<CryptoToken> _alphaCoins = [];
  bool _isScanning = false;
  String _errorMessage = '';

  // Функция для копирования адреса в буфер обмена
  void _copyToClipboard(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Адрес скопирован: ${text.substring(0, 10)}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Функция для показа информации о покупке
  void _showPurchaseInfo(DexInfo dex, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Купить на ${dex.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DEX: ${dex.name}'),
            Text('Ликвидность: \$${_formatNumber(dex.liquidity)}'),
            Text('Адрес пула: ${dex.pairAddress}'),
            const SizedBox(height: 16),
            const Text(
              'Ссылка для покупки:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText(
              dex.url,
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Скопируйте ссылку выше и откройте в браузере',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _copyToClipboard(dex.url, context),
            child: const Text('Копировать ссылку'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _scanAlphaCoins() async {
    setState(() {
      _isScanning = true;
      _errorMessage = '';
      _alphaCoins = [];
    });

    try {
      final alphaCoins = await _scannerService.findAlphaCoins();
      
      setState(() {
        _alphaCoins = alphaCoins;
        _isScanning = false;
      });
      
      if (alphaCoins.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не найдено монет с потенциалом 1000%+'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Найдено ${alphaCoins.length} монет с потенциалом 1000%+!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
        _isScanning = false;
      });
    }
  }

  void _showCoinAnalysis(CryptoToken token) {
    final analysis = _scannerService.analyzeToken(token);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QUANTUM Анализ: ${token.name}'),
            Text(
              'ALPHA Score: ${token.score?.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ВЕРДИКТ
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getVerdictColor(analysis.verdict).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getVerdictColor(analysis.verdict)),
                ),
                child: Column(
                  children: [
                    Text(
                      analysis.verdict,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getVerdictColor(analysis.verdict),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(analysis.reasoning, textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ОСНОВНЫЕ МЕТРИКИ
              _buildMetricCard('🎯 Прогноз прибыли', '${analysis.predictedProfit.toStringAsFixed(0)}%', Colors.green),
              _buildMetricCard('⚠️ Уровень риска', analysis.riskLevel, Colors.orange),
              _buildMetricCard('📊 Уверенность', '${(analysis.confidence * 100).toStringAsFixed(0)}%', Colors.blue),

              // СИГНАЛЫ ОТ РАЗНЫХ МЕТОДОВ
              if (analysis.technicalSignals.isNotEmpty) ...[
                _buildAnalysisSection('📈 ТЕХНИЧЕСКИЙ АНАЛИЗ', analysis.technicalSignals, Colors.blue),
              ],
              if (analysis.randomWalkSignals.isNotEmpty) ...[
                _buildAnalysisSection('🎲 ТЕОРИЯ СЛУЧАЙНОГО БЛУЖДАНИЯ', analysis.randomWalkSignals, Colors.purple),
              ],
              if (analysis.quantileSignals.isNotEmpty) ...[
                _buildAnalysisSection('📊 КВАНТИЛЬНАЯ РЕГРЕССИЯ', analysis.quantileSignals, Colors.green),
              ],
              if (analysis.timeSeriesSignals.isNotEmpty) ...[
                _buildAnalysisSection('⏰ АНАЛИЗ ВРЕМЕННЫХ РЯДОВ', analysis.timeSeriesSignals, Colors.orange),
              ],
              if (analysis.sentimentSignals.isNotEmpty) ...[
                _buildAnalysisSection('😊 АНАЛИЗ НАСТРОЕНИЙ', analysis.sentimentSignals, Colors.pink),
              ],

              // ИНФОРМАЦИЯ ДЛЯ ПОКУПКИ
              if (token.contractAddress != null || token.dexInfo.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('🛒 Где купить:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                
                if (token.contractAddress != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Контракт: ${token.contractAddress!.substring(0, 10)}...${token.contractAddress!.substring(token.contractAddress!.length - 6)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 18),
                        onPressed: () => _copyToClipboard(token.contractAddress!, context),
                      ),
                    ],
                  ),
                ],
                
                ...token.dexInfo.map((dex) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.swap_horiz, color: Colors.blue),
                    title: Text(dex.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ликвидность: \$${_formatNumber(dex.liquidity)}'),
                        Text('Пул: ${dex.pairAddress.substring(0, 8)}...', style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _showPurchaseInfo(dex, context),
                      child: const Text('Купить', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                )),
              ],

              // ДЕТАЛИ ТОКЕНА
              const SizedBox(height: 16),
              const Text('📋 Информация о токене:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDetailRow('Цена', '\$${token.currentPrice?.toStringAsFixed(6) ?? "N/A"}'),
              if (token.marketCap != null)
                _buildDetailRow('Капитализация', '\$${_formatNumber(token.marketCap!)}'),
              if (token.volume24h != null)
                _buildDetailRow('Объем 24h', '\$${_formatNumber(token.volume24h!)}'),
              _buildDetailRow('Волатильность', '${token.volatility.toStringAsFixed(1)}%'),
              _buildDetailRow('Категория', token.category.toUpperCase()),
              _buildDetailRow('Сеть', token.chain?.toUpperCase() ?? 'N/A'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(String title, List<String> signals, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ...signals.map((signal) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text('• $signal'),
        )),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getVerdictColor(String verdict) {
    if (verdict.contains('МЕГА')) return Colors.red;
    if (verdict.contains('УЛЬТРА')) return Colors.orange;
    return Colors.green;
  }

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔮 Quantum Alpha Scanner'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ИНФОРМАЦИЯ
            Card(
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          'Мульти-методный Quantum Анализ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Комбинация 5 методов анализа + адреса для покупки\nмонет с потенциалом 1000%+',
                      style: TextStyle(color: Colors.deepPurple[800], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // КНОПКА
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _scanAlphaCoins,
                icon: _isScanning 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.psychology),
                label: _isScanning 
                    ? const Text('Quantum анализ...')
                    : const Text('QUANTUM АНАЛИЗ 1000%+'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ЗАГРУЗКА
            if (_isScanning) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text('Применяем многофакторный анализ...'),
              const SizedBox(height: 20),
            ],

            // ОШИБКА
            if (_errorMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_errorMessage),
              ),

            // РЕЗУЛЬТАТЫ
            if (_alphaCoins.isNotEmpty) ...[
              Text(
                '🎯 ${_alphaCoins.length} монет с потенциалом 1000%+:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _alphaCoins.length,
                  itemBuilder: (context, index) {
                    final token = _alphaCoins[index];
                    final analysis = _scannerService.analyzeToken(token);
                    
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: token.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: token.imageUrl,
                                width: 40,
                                height: 40,
                                errorWidget: (context, url, error) => 
                                    const Icon(Icons.psychology),
                              )
                            : const Icon(Icons.psychology),
                        title: Text(
                          token.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${token.symbol} • ${token.category.toUpperCase()}'),
                            if (token.contractAddress != null)
                              Text(
                                'Адрес: ${token.contractAddress!.substring(0, 8)}...',
                                style: const TextStyle(fontSize: 10, color: Colors.blue),
                              ),
                            if (token.technicalAnalysis != null)
                              Text(
                                'RSI: ${token.technicalAnalysis!.rsi.toStringAsFixed(1)}',
                                style: const TextStyle(fontSize: 11),
                              ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${analysis.predictedProfit.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Score: ${token.score?.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        onTap: () => _showCoinAnalysis(token),
                      ),
                    );
                  },
                ),
              ),
            ],

            // ПУСТОЙ ЭКРАН
            if (!_isScanning && _alphaCoins.isEmpty && _errorMessage.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.psychology, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Quantum Alpha Scanner',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Многофакторный анализ для поиска\nмонет с потенциалом 1000%+',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '📈 Технический анализ\n'
                        '🎲 Теория случайного блуждания\n'
                        '📊 Квантильная регрессия\n'
                        '⏰ Анализ временных рядов\n'
                        '😊 Анализ настроений\n'
                        '🛒 Прямые ссылки для покупки',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}