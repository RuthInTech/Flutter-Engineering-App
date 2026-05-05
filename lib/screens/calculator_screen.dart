import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/chem_record.dart';
import '../services/chem_calculator_service.dart';
import '../services/storage_service.dart';
import '../widgets/result_card.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _molesController = TextEditingController();
  final _volumeController = TextEditingController();
  final _hConcController = TextEditingController();
  final _c1Controller = TextEditingController();
  final _v1Controller = TextEditingController();
  final _v2Controller = TextEditingController();

  int _selectedTab = 0;
  ChemRecord? _record;

  final List<String> _tabs = ['Molarity', 'pH / pOH', 'Dilution'];

  @override
  void dispose() {
    _molesController.dispose();
    _volumeController.dispose();
    _hConcController.dispose();
    _c1Controller.dispose();
    _v1Controller.dispose();
    _v2Controller.dispose();
    super.dispose();
  }

  void _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    ChemRecord result;

    if (_selectedTab == 0) {
      // Molarity
      final moles = double.parse(_molesController.text);
      final volume = double.parse(_volumeController.text);
      final molarity = ChemCalculatorService.calculateMolarity(moles, volume);
      result = ChemRecord(
        calculationType: 'Molarity',
        inputs: {'Moles (mol)': moles, 'Volume (L)': volume},
        results: {'Molarity (M)': molarity},
        createdAt: DateTime.now(),
      );
    } else if (_selectedTab == 1) {
      // pH / pOH
      final hConc = double.parse(_hConcController.text);
      final pH = ChemCalculatorService.calculatePH(hConc);
      final pOH = ChemCalculatorService.calculatePOH(pH);
      final ohConc = ChemCalculatorService.calculateOHConcentration(pOH);
      result = ChemRecord(
        calculationType: 'pH / pOH',
        inputs: {'[H⁺] concentration (M)': hConc},
        results: {
          'pH': pH,
          'pOH': pOH,
          '[OH⁻] (M)': ohConc,
        },
        createdAt: DateTime.now(),
      );
    } else {
      // Dilution
      final c1 = double.parse(_c1Controller.text);
      final v1 = double.parse(_v1Controller.text);
      final v2 = double.parse(_v2Controller.text);
      final c2 = ChemCalculatorService.calculateDilution(c1: c1, v1: v1, v2: v2);
      result = ChemRecord(
        calculationType: 'Dilution (C₁V₁=C₂V₂)',
        inputs: {'C₁ (M)': c1, 'V₁ (L)': v1, 'V₂ (L)': v2},
        results: {'C₂ (M)': c2},
        createdAt: DateTime.now(),
      );
    }

    await StorageService.saveRecord(result);
    setState(() => _record = result);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to history'),
        backgroundColor: Color(0xFF1D1F33),
      ),
    );
  }

  void _clear() {
    _molesController.clear();
    _volumeController.clear();
    _hConcController.clear();
    _c1Controller.clear();
    _v1Controller.clear();
    _v2Controller.clear();
    setState(() => _record = null);
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return 'Must be greater than 0';
    return null;
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: _validateNumber,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF4A4D5E)),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildMolarityForm() {
    return Column(
      children: [
        _buildField(
          controller: _molesController,
          label: 'Moles (mol)',
          icon: Icons.bubble_chart,
          hint: 'e.g. 2.5',
        ),
        _buildField(
          controller: _volumeController,
          label: 'Volume (L)',
          icon: Icons.water_drop,
          hint: 'e.g. 1.0',
        ),
      ],
    );
  }

  Widget _buildPHForm() {
    return _buildField(
      controller: _hConcController,
      label: '[H⁺] Concentration (M)',
      icon: Icons.science,
      hint: 'e.g. 0.001',
    );
  }

  Widget _buildDilutionForm() {
    return Column(
      children: [
        _buildField(
          controller: _c1Controller,
          label: 'Initial Concentration C₁ (M)',
          icon: Icons.opacity,
          hint: 'e.g. 5.0',
        ),
        _buildField(
          controller: _v1Controller,
          label: 'Initial Volume V₁ (L)',
          icon: Icons.water_drop,
          hint: 'e.g. 0.5',
        ),
        _buildField(
          controller: _v2Controller,
          label: 'Final Volume V₂ (L)',
          icon: Icons.water,
          hint: 'e.g. 2.0',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBgColor,
        title: const Text('Chem Calculator'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: kAccentColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tab selector
              Container(
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(_tabs.length, (i) {
                    final selected = _selectedTab == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedTab = i;
                          _record = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? kAccentColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _tabs[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.black : kGreyText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // Form fields
              if (_selectedTab == 0) _buildMolarityForm(),
              if (_selectedTab == 1) _buildPHForm(),
              if (_selectedTab == 2) _buildDilutionForm(),

              const SizedBox(height: 8),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate, color: Colors.black),
                      label: const Text(
                        'Calculate',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.clear, color: kGreyText),
                      label: const Text(
                        'Clear',
                        style: TextStyle(color: kGreyText),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF2A2D3E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (_record != null) ResultCard(record: _record!),
            ],
          ),
        ),
      ),
    );
  }
}