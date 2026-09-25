import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ii_antcap/presentation/providers/token_provider.dart';
import 'package:ii_antcap/presentation/widgets/token_card.dart';
import 'package:ii_antcap/presentation/widgets/loading_indicator.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    ref.read(tokenProvider.notifier).updateSearchText(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tokenProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('II AntCap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите название токена (например: bitcoin)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(TokenState state) {
    if (state.isLoading && state.searchResults.isEmpty) {
      return const LoadingIndicator();
    }

    if (state.searchResults.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.searchResults.length,
        itemBuilder: (context, index) {
          final token = state.searchResults[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TokenCard(
              token: token,
              isFavorite: state.favorites.any((t) => t.id == token.id),
              onTap: () => _analyzeToken(token),
              onFavoriteTap: () => _toggleFavorite(token),
            ),
          );
        },
      );
    }

    if (state.searchText.isNotEmpty && state.searchResults.isEmpty) {
      return const Center(
        child: Text('Токены не найдены'),
      );
    }

    return const WelcomeScreen();
  }

  void _analyzeToken(TokenData token) {
    ref.read(tokenProvider.notifier).analyzeToken(token);
    Navigator.pushNamed(context, '/analysis');
  }

  void _toggleFavorite(TokenData token) {
    ref.read(tokenProvider.notifier).toggleFavorite(token);
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'II AntCap',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ваш умный муравей-разведчик в мире криптовалют',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const DisclaimerCard(),
        ],
      ),
    );
  }
}

class DisclaimerCard extends StatelessWidget {
  const DisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Важное предупреждение',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'II AntCap предоставляет исключительно информационные и образовательные материалы. Это не финансовая консультация. Криптоинвестиции сопряжены с высоким риском. Вы действуете на свой собственный страх и риск.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}