import 'dart:math';

class ChemCalculatorService {
  // Molarity = moles / volume(L)
  static double calculateMolarity(double moles, double volumeLiters) {
    return moles / volumeLiters;
  }

  // pH = -log10([H+])
  static double calculatePH(double hConcentration) {
    return -log(hConcentration) / ln10;
  }

  // pOH = 14 - pH
  static double calculatePOH(double pH) {
    return 14 - pH;
  }

  // [OH-] = 10^(-pOH)
  static double calculateOHConcentration(double pOH) {
    return pow(10, -pOH).toDouble();
  }

  // [H+] from pH
  static double hFromPH(double pH) {
    return pow(10, -pH).toDouble();
  }

  // Dilution: C1V1 = C2V2 → find C2
  static double calculateDilution({
    required double c1,
    required double v1,
    required double v2,
  }) {
    return (c1 * v1) / v2;
  }
}