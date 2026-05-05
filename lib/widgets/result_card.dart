import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/chem_record.dart';

class ResultCard extends StatelessWidget {
  final ChemRecord record;

  const ResultCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: kAccentColor, size: 20),
              const SizedBox(width: 8),
              Text(record.calculationType, style: kTitleStyle),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2A2D3E)),
          const SizedBox(height: 12),
          ...record.results.entries.map(
                (e) => _resultRow(e.key, _formatValue(e.value)),
          ),
        ],
      ),
    );
  }

  String _formatValue(double val) {
    if (val < 0.001 || val > 99999) {
      return val.toStringAsExponential(4);
    }
    return val.toStringAsFixed(4);
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: kLabelStyle),
          Text(value, style: kValueStyle.copyWith(color: kGreenColor)),
        ],
      ),
    );
  }
}