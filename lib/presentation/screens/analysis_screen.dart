import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ii_antcap/presentation/providers/token_provider.dart';
import 'package:ii_antcap/presentation/widgets/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tokenProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: LoadingIndicator(),
      );
    }

    final report = state.analysisReport;
    if (report == null) {
      return const Scaffold(
        body: Center(
          child: Text('Нет данных для анализа'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(tokenProvider.notifier).resetAnalysis();
            Navigator.pop(context);
          },
        ),
        title: const Text('Анализ токена'),
        actions: [
          IconButton(
            icon: Icon(
              state.favorites.any((t) => t.id == report.tokenData.id)
                  ? Icons.star
                  : Icons.star_border,
            ),
            onPressed: () {
              ref.read(tokenProvider.notifier).toggleFavorite(report.tokenData);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTokenHeader(report.tokenData),
            const SizedBox(height: 16),
            _buildVerdictCard(report),
            const SizedBox(height: 16),
            _buildMetricsCard(report),
            const SizedBox(height: 16),
            _buildFactorsCard(report),
            const SizedBox(height: 16),
            _buildTimestamp(report),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenHeader(TokenData token) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (token.imageUrl != null)
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(token.imageUrl!),
              )
            else
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: Text(
                  token.symbol.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    token.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    token.symbol,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerdictCard(AnalysisReport report) {
    final verdictColor = _getVerdictColor(report.aiAnalysis.verdict);
    final riskColor = _getRiskColor(report.aiAnalysis.riskLevel);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вердикт',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      report.aiAnalysis.verdict,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: verdictColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Уровень риска',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    _buildRiskIndicator(report.aiAnalysis.riskLevel, riskColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report.aiAnalysis.reasoning,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(report.aiAnalysis.recommendedHoldTime),
                Text(
                  'Уверенность: ${(report.aiAnalysis.confidence * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskIndicator(int riskLevel, Color color) {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index < riskLevel ? color : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildMetricsCard(AnalysisReport report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ключевые метрики',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Price metrics
            if (report.tokenData.currentPrice != null)
              _buildMetricRow(
                'Текущая цена',
                _formatCurrency(report.tokenData.currentPrice!),
                change: report.tokenData.priceChange24h,
              ),
            if (report.tokenData.marketCap != null)
              _buildMetricRow(
                'Рыночная капитализация',
                _formatLargeNumber(report.tokenData.marketCap!),
              ),
            if (report.tokenData.volume24h != null)
              _buildMetricRow(
                'Объем торгов 24ч',
                _formatLargeNumber(report.tokenData.volume24h!),
              ),
            const SizedBox(height: 12),
            // AI Metrics
            ...report.aiAnalysis.keyMetrics.entries.map((entry) {
              return _buildMetricProgressRow(
                _capitalize(entry.key.replaceAll('_', ' ')),
                entry.value,
                '${(entry.value * 100).toInt()}%',
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {double? change}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (change != null) ...[
                const SizedBox(width: 8),
                Text(
                  '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: change >= 0 ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricProgressRow(String label, double progress, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            percent: progress,
            lineHeight: 6,
            progressColor: _getProgressColor(progress),
            backgroundColor: Colors.grey[300],
            barRadius: const Radius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorsCard(AnalysisReport report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Факторы анализа',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (report.aiAnalysis.factors.positive.isNotEmpty)
              _buildFactorSection('Положительные', report.aiAnalysis.factors.positive, Colors.green),
            if (report.aiAnalysis.factors.negative.isNotEmpty)
              _buildFactorSection('Отрицательные', report.aiAnalysis.factors.negative, Colors.red),
            if (report.aiAnalysis.factors.technical.isNotEmpty)
              _buildFactorSection('Технические', report.aiAnalysis.factors.technical, Colors.blue),
            if (report.aiAnalysis.factors.fundamental.isNotEmpty)
              _buildFactorSection('Фундаментальные', report.aiAnalysis.factors.fundamental, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorSection(String title, List<String> factors, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...factors.map((factor) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, top: 2),
              child: Text(
                '• $factor',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimestamp(AnalysisReport report) {
    return Text(
      'Анализ выполнен: ${_formatDateTime(report.timestamp)}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Helper methods
  Color _getVerdictColor(String verdict) {
    switch (verdict) {
      case 'Покупать':
        return Colors.green;
      case 'Не покупать':
        return Colors.red;
      case 'Осторожно':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getRiskColor(int riskLevel) {
    switch (riskLevel) {
      case 1:
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress > 0.7) return Colors.green;
    if (progress > 0.3) return Colors.orange;
    return Colors.red;
  }

  String _formatCurrency(double value) {
    if (value < 1) {
      return '\$${value.toStringAsFixed(6)}';
    }
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatLargeNumber(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    }
    return _formatCurrency(value);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}