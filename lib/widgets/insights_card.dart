import 'package:flutter/material.dart';
import 'package:horizon_finance/features/ai_insights/provider/ai_insights_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class InsightsCard extends ConsumerStatefulWidget {
  const InsightsCard({super.key});

  @override
  ConsumerState<InsightsCard> createState() => _InsightsCardState();
}

class _InsightsCardState extends ConsumerState<InsightsCard> {
  Timer? _refreshTimer;
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.92);

  @override
  void initState() {
    super.initState();
    // Atualiza insights a cada 5 minutos
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      ref.invalidate(aiInsightsProvider);
    });

    // Auto-scroll suave 
    Timer.periodic(const Duration(seconds: 25), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insightsAsync = ref.watch(aiInsightsProvider);
    final primaryBlue = Theme.of(context).primaryColor;

    return insightsAsync.when(
      loading: () => _buildLoadingState(primaryBlue),
      error: (err, stack) => _buildErrorState(err.toString(), primaryBlue),
      data: (insights) {
        if (insights.insights.isEmpty) {
          return _buildEmptyState(primaryBlue);
        }
        return _buildInsightsCarousel(insights.insights, primaryBlue);
      },
    );
  }

  Widget _buildLoadingState(Color primaryBlue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: primaryBlue, size: 24),
                const SizedBox(width: 12),
                Text(
                  "Gerando Insights...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(color: primaryBlue, strokeWidth: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, Color primaryBlue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ops! Algo deu errado",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tente novamente em instantes",
                    style: TextStyle(fontSize: 12, color: Colors.red.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              color: primaryBlue,
              onPressed: () => ref.invalidate(aiInsightsProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color primaryBlue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.insights_outlined, color: primaryBlue, size: 48),
            const SizedBox(height: 12),
            Text(
              "Adicione transações",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Insights serão gerados automaticamente",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCarousel(List<String> insights, Color primaryBlue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com ícone e título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, primaryBlue.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Horizon Insights",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        Text(
                          "Atualizado agora",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Botão de refresh
                Container(
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.refresh, color: primaryBlue, size: 20),
                    onPressed: () => ref.invalidate(aiInsightsProvider),
                    tooltip: "Gerar novos insights",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Carrossel de cards
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: insights.length,
              itemBuilder: (context, index) {
                return _buildInsightCard(
                  insights[index],
                  index,
                  primaryBlue,
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              insights.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? primaryBlue
                      : primaryBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String text, int index, Color primaryBlue) {
    // Cores diferentes para cada card
    final gradientColors = [
      [primaryBlue, primaryBlue.withOpacity(0.7)],
      [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
      [const Color(0xFFE53935), const Color(0xFFEF5350)],
    ];

    final gradient = gradientColors[index % gradientColors.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Ícone decorativo no fundo
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.insights,
                size: 120,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge de número
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "horizon AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Texto do insight
                     Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
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