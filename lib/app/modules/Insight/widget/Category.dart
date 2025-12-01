import 'package:flutter/material.dart';

class CategoryCards extends StatelessWidget {
  const CategoryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CategoryCard(
          title: 'Income by Category',
          items: [
            CategoryItem(
              label: 'Sales Revenue',
              amount: '₦50,000',
              percentage: '100%',
              color: Color(0xFF10B981), // green
            ),
          ],
        ),
        SizedBox(height: 16),
        CategoryCard(
          title: 'Expenses by Category',
          items: [],
          emptyMessage: 'No expense categories found',
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final List<CategoryItem> items;
  final String? emptyMessage;

  const CategoryCard({
    super.key,
    required this.title,
    required this.items,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              Center(
                child: Text(
                  emptyMessage ?? 'No data available',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CategoryRow(item: item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String label;
  final String amount;
  final String percentage;
  final Color color;

  const CategoryItem({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class _CategoryRow extends StatelessWidget {
  final CategoryItem item;

  const _CategoryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Color indicator square
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        // Label
        Expanded(
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ),
        // Amount and percentage
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.amount,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              item.percentage,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
