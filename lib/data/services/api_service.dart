import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/token_models.dart';

class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<TokenData>> searchTokens(String query) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/search?query=$query'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coins = data['coins'] as List?;
        
        return coins?.map((coin) => TokenData.fromSearch(coin)).toList() ?? [];
      } else {
        throw Exception('Failed to search tokens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<TokenData> getTokenData(String tokenId) async {
    try {
      final response = await _client
          .get(Uri.parse(
            '$_baseUrl/coins/$tokenId?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false',
          ))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TokenData.fromCoinGecko(data);
      } else {
        throw Exception('Failed to fetch token data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Token data fetch failed: $e');
    }
  }

  Future<AIAnalysisResponse> analyzeToken(TokenData tokenData) async {
    // Mock AI analysis - replace with real API call
    await Future.delayed(const Duration(seconds: 2));
    
    final priceChange24h = tokenData.priceChange24h ?? 0.0;
    final marketCap = tokenData.marketCap ?? 0.0;

    if (priceChange24h > 20 && marketCap > 1000000000) {
      return AIAnalysisResponse(
        verdict: 'Покупать',
        reasoning: 'Токен демонстрирует сильный рост с высокой рыночной капитализацией, что указывает на устойчивость.',
        recommendedHoldTime: 'Среднесрочный (1-6 мес.)',
        riskLevel: 2,
        confidence: 0.85,
        keyMetrics: {
          'price_strength': (priceChange24h / 100).clamp(0.0, 1.0),
          'volume_activity': ((tokenData.volume24h ?? 0) / 1000000000).clamp(0.0, 1.0),
          'market_cap_strength': (marketCap / 10000000000).clamp(0.0, 1.0),
        },
        factors: AnalysisFactors(
          positive: ['Высокий объем торгов', 'Сильное ценовое движение'],
          negative: ['Волатильность', 'Конкуренция на рынке'],
          technical: ['RSI показывает перекупленность', 'Поддержка на текущем уровне'],
          fundamental: ['Активная разработка', 'Растущее сообщество'],
        ),
      );
    } else if (priceChange24h < -10) {
      return AIAnalysisResponse(
        verdict: 'Не покупать',
        reasoning: 'Значительное падение цены за последние 24 часа может указывать на негативный тренд.',
        recommendedHoldTime: 'Не применимо',
        riskLevel: 4,
        confidence: 0.75,
        keyMetrics: {
          'price_strength': (priceChange24h / 100).clamp(0.0, 1.0),
          'volume_activity': ((tokenData.volume24h ?? 0) / 1000000000).clamp(0.0, 1.0),
          'market_cap_strength': (marketCap / 10000000000).clamp(0.0, 1.0),
        },
        factors: AnalysisFactors(
          positive: ['Низкая цена входа'],
          negative: ['Сильное падение', 'Низкий объем'],
          technical: ['Сопротивление на верхних уровнях', 'Слабые поддержки'],
          fundamental: ['Неопределенность на рынке'],
        ),
      );
    } else {
      return AIAnalysisResponse(
        verdict: 'Осторожно',
        reasoning: 'Токен показывает смешанные сигналы. Рекомендуется дополнительный анализ.',
        recommendedHoldTime: 'Краткосрочный (< 1 мес.)',
        riskLevel: 3,
        confidence: 0.65,
        keyMetrics: {
          'price_strength': (priceChange24h / 100).clamp(0.0, 1.0),
          'volume_activity': ((tokenData.volume24h ?? 0) / 1000000000).clamp(0.0, 1.0),
          'market_cap_strength': (marketCap / 10000000000).clamp(0.0, 1.0),
        },
        factors: AnalysisFactors(
          positive: ['Стабильность цены', 'Умеренный объем'],
          negative: ['Неопределенный тренд', 'Конкуренция'],
          technical: ['Консолидация в диапазоне', 'Нейтральные индикаторы'],
          fundamental: ['Средняя активность сообщества'],
        ),
      );
    }
  }

  void dispose() {
    _client.close();
  }
}