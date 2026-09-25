import 'package:ii_antcap/data/services/api_service.dart';
import 'package:ii_antcap/data/models/token_models.dart';

class TokenRepository {
  final ApiService _apiService;

  TokenRepository({required ApiService apiService}) : _apiService = apiService;

  Future<List<TokenData>> searchTokens(String query) async {
    return await _apiService.searchTokens(query);
  }

  Future<TokenData> getTokenData(String tokenId) async {
    return await _apiService.getTokenData(tokenId);
  }

  Future<AnalysisReport> analyzeToken(TokenData tokenData) async {
    final aiAnalysis = await _apiService.analyzeToken(tokenData);
    
    return AnalysisReport(
      id: '${tokenData.id}_${DateTime.now().millisecondsSinceEpoch}',
      tokenData: tokenData,
      aiAnalysis: aiAnalysis,
      timestamp: DateTime.now(),
    );
  }

  void dispose() {
    _apiService.dispose();
  }
}