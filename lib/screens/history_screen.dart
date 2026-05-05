import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/chem_record.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ChemRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = StorageService.getRecords();
  }

  Future<void> _clearHistory() async {
    await StorageService.clearHistory();
    setState(() {
      _historyFuture = StorageService.getRecords();
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History cleared')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}  '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildCard(ChemRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.science, color: kAccentColor, size: 18),
                  const SizedBox(width: 8),
                  Text(record.calculationType, style: kTitleStyle),
                ],
              ),
              Text(_formatDate(record.createdAt),
                  style: const TextStyle(color: kGreyText, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFF2A2D3E)),
          const SizedBox(height: 8),
          ...record.results.entries.map(
                (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: kLabelStyle),
                  Text(
                    e.value < 0.001 || e.value > 99999
                        ? e.value.toStringAsExponential(4)
                        : e.value.toStringAsFixed(4),
                    style: const TextStyle(
                      color: kGreenColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBgColor,
        title: const Text('Calculation History'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: kRedColor),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: FutureBuilder<List<ChemRecord>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kAccentColor));
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(
              child: Text('No history yet.', style: TextStyle(color: kGreyText)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (_, i) => _buildCard(records[i]),
          );
        },
      ),
    );
  }
}