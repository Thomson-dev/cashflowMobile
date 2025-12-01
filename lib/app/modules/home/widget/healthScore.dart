// Health Score Banner
import 'package:flutter/material.dart';

class HealthScoreBanner extends StatelessWidget {

  final double dailyBurnRate;
  final int daysRemaining;
  final String indicator;
  final String phrase;

  const HealthScoreBanner({

    required this.dailyBurnRate,
    required this.daysRemaining,
    required this.indicator,
    required this.phrase,
  });

  Color getColor() {
    switch (indicator.toLowerCase()) {
      case 'green':
        return const Color(0xFF10B981);
      case 'yellow':
        return const Color(0xFFF59E0B);
      case 'red':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData getIcon() {
    switch (indicator.toLowerCase()) {
      case 'green':
        return Icons.check_circle;
      case 'yellow':
        return Icons.warning;
      case 'red':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getColor().withOpacity(0.3), width: 2),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: getColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(),
                  color: getColor(),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Financial Health',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phrase,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[200], height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
            
              _HealthMetric(
                label: 'Daily Burn',
                value: dailyBurnRate > 0 
                    ? '₦${dailyBurnRate.toStringAsFixed(0)}'
                    : '₦0',
                icon: Icons.local_fire_department,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[200],
              ),
              _HealthMetric(
                label: 'Runway',
                value: daysRemaining >= 999 
                    ? '999+ days' 
                    : '$daysRemaining days',
                icon: Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HealthMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}