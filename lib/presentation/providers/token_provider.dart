import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ii_antcap/data/models/token_models.dart';
import 'package:ii_antcap/data/repositories/token_repository.dart';
import 'package:ii_antcap/data/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  return TokenRepository(apiService: ref.read(apiServiceProvider));
});

final tokenProvider = StateNotifierProvider<TokenNotifier, TokenState>((ref) {
  return TokenNotifier(repository: ref.read(tokenRepositoryProvider));
});

class TokenState {
  final String searchText;
  final List<TokenData> searchResults;
  final TokenData? selectedToken;
  final AnalysisReport? analysisReport;
  final bool isLoading;
  final String? errorMessage;
  final List<AnalysisReport> history;
  final List<TokenData> favorites;

  TokenState({
    this.searchText = '',
    this.searchResults = const [],
    this.selectedToken,
    this.analysisReport,
    this.isLoading = false,
    this.errorMessage,
    this.history = const [],
    this.favorites = const [],
  });

  TokenState copyWith({
    String? searchText,
    List<TokenData>? searchResults,
    TokenData? selectedToken,
    AnalysisReport? analysisReport,
    bool? isLoading,
    String? errorMessage,
    List<AnalysisReport>? history,
    List<TokenData>? favorites,
  }) {
    return TokenState(
      searchText: searchText ?? this.searchText,
      searchResults: searchResults ?? this.searchResults,
      selectedToken: selectedToken ?? this.selectedToken,
      analysisReport: analysisReport ?? this.analysisReport,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      history: history ?? this.history,
      favorites: favorites ?? this.favorites,
    );
  }
}

class TokenNotifier extends StateNotifier<TokenState> {
  final TokenRepository _repository;

  TokenNotifier({required TokenRepository repository})
      : _repository = repository,
        super(TokenState());

  void updateSearchText(String text) {
    state = state.copyWith(searchText: text);
    if (text.isNotEmpty) {
      _searchTokens();
    } else {
      state = state.copyWith(searchResults: []);
    }
  }

  Future<void> _searchTokens() async {
    try {
      final results = await _repository.searchTokens(state.searchText);
      state = state.copyWith(searchResults: results);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка поиска: $e');
    }
  }

  Future<void> analyzeToken(TokenData token) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      selectedToken: token,
    );

    try {
      final fullTokenData = await _repository.getTokenData(token.id);
      final report = await _repository.analyzeToken(fullTokenData);
      
      state = state.copyWith(
        analysisReport: report,
        isLoading: false,
        history: [report, ...state.history],
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Ошибка анализа: $e',
        isLoading: false,
      );
    }
  }

  void toggleFavorite(TokenData token) {
    final isCurrentlyFavorite = state.favorites.any((t) => t.id == token.id);
    final newFavorites = isCurrentlyFavorite
        ? state.favorites.where((t) => t.id != token.id).toList()
        : [...state.favorites, token];
    
    state = state.copyWith(favorites: newFavorites);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void resetAnalysis() {
    state = state.copyWith(
      selectedToken: null,
      analysisReport: null,
      searchText: '',
      searchResults: [],
    );
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}