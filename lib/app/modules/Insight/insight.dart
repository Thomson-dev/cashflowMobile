import 'package:cashflow/app/modules/Insight/controller/insight_controller.dart';
import 'package:cashflow/app/modules/Insight/widget/AIPoweredInsights.dart';
import 'package:cashflow/app/modules/Insight/widget/Category.dart';
import 'package:cashflow/app/modules/Insight/widget/PeriodSummaryCard.dart';
import 'package:cashflow/app/modules/Insight/widget/StatsCard.dart';
import 'package:cashflow/app/modules/Insight/widget/TrendCard.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum Period { d7, d30, d90, y1 }

class FinancialInsightsScreen extends StatefulWidget {
  const FinancialInsightsScreen({super.key});

  @override
  State<FinancialInsightsScreen> createState() =>
      _FinancialInsightsScreenState();
}

class _FinancialInsightsScreenState extends State<FinancialInsightsScreen>
    with TickerProviderStateMixin {
  Period _period = Period.d30;
  late TabController _tabController;
  final InsightController _insightController = Get.put(InsightController());

  String _label(Period p) {
    switch (p) {
      case Period.d7:
        return '7 Days';
      case Period.d30:
        return '30 Days';
      case Period.d90:
        return '90 Days';
      case Period.y1:
        return '1 Year';
    }
  }

  Widget _periodButton(Period p) {
    final bool active = _period == p;
    return ElevatedButton(
      onPressed: () => setState(() => _period = p),
      style: ElevatedButton.styleFrom(
        elevation: active ? 0 : 0,
        backgroundColor: active ? const Color(0xFF00A77F) : Colors.white,
        foregroundColor: active ? Colors.white : const Color(0xFF374151),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: active ? const Color(0xFF00A77F) : const Color(0xFFE5E7EB),
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(
        _label(p),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13, // Smaller button font size
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _insightController.refreshInsights,
          child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    Container(
                      height: 36,

                      child: const Icon(
                        Icons.analytics_rounded,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Financial Insights',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Time Period',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                            Icon(
                              size: 18,
                              Icons.calendar_today_outlined,
                              color: Color(0xFF6B7280),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 2x2 grid of buttons
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 3.0, // wide pill-like buttons
                              ),
                          children: [
                            _periodButton(Period.d7),
                            _periodButton(Period.d30),
                            _periodButton(Period.d90),
                            _periodButton(Period.y1),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Add your charts/content below as needed...
                SizedBox(height: 10),
                Container(
                  child: Column(
                    children: [
                      StatCard(
                        title: 'Total Income',
                        value: '₦50,000',
                        valueColor: const Color(0xFF10B981), // green
                        badgeColor: const Color(0xFFE6FFF6),
                        badgeIconColor: const Color(0xFF10B981),
                        icon: Icons.trending_up,
                      ),
                      const SizedBox(height: 10),
                      StatCard(
                        title: 'Total Expenses',
                        value: '₦0',
                        valueColor: const Color(0xFFEF4444), // red
                        badgeColor: const Color(0xFFFFEEEE),
                        badgeIconColor: const Color(0xFFEF4444),
                        icon: Icons.trending_down,
                      ),
                      const SizedBox(height: 10),
                      StatCard(
                        title: 'Net Amount',
                        value: '₦50,000',
                        valueColor: const Color(0xFF10B981),
                        badgeColor: const Color(0xFFEAF2FF),
                        badgeIconColor: const Color(0xFF3B82F6), // blue
                        icon: Icons.attach_money,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                // TrendCard(),
                SizedBox(height: 16),
                CategoryCard(
                  title: 'Income by Category',
                  items: [
                    CategoryItem(
                      label: 'Sales Revenue',
                      amount: '₦50,000',
                      percentage: '100%',
                      color: Colors.green,
                    ),
                    CategoryItem(
                      label: 'Freelance',
                      amount: '₦25,000',
                      percentage: '50%',
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() {
                  if (_insightController.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF10B981),
                        ),
                      ),
                    );
                  }

                  if (_insightController.errorMessage.value.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _insightController.errorMessage.value,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!_insightController.hasInsights) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.insights_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No insights available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pull down to refresh',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return AIPoweredInsights(
                    insights: _insightController.insights.value,
                    aiInsights: _insightController.aiInsights.value,
                  );
                }),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
