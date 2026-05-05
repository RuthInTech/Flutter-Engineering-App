class ChemRecord {
  final String calculationType;
  final Map<String, double> inputs;
  final Map<String, double> results;
  final DateTime createdAt;

  ChemRecord({
    required this.calculationType,
    required this.inputs,
    required this.results,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'calculationType': calculationType,
    'inputs': inputs,
    'results': results,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ChemRecord.fromJson(Map<String, dynamic> json) => ChemRecord(
    calculationType: json['calculationType'],
    inputs: Map<String, double>.from(json['inputs']),
    results: Map<String, double>.from(json['results']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}