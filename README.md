# 🧪 Chemical Concentration & pH Calculator

A Flutter app for calculating chemical concentration, pH, pOH, and dilution — built with a sleek dark theme UI.

---

## Screenshots

| Calculator Screen | History Screen |
|---|---|
| Molarity, pH/pOH, Dilution tabs | Saved past calculations |

---

## What the App Does

- Calculate **Molarity** from moles and volume
- Calculate **pH**, **pOH**, and **[OH⁻]** from hydrogen ion concentration
- Calculate **dilution** using C₁V₁ = C₂V₂
- Save calculation history locally
- Clear history anytime

---

## Formulas Used

| Calculation | Formula |
|---|---|
| Molarity | M = moles / volume (L) |
| pH | pH = -log₁₀([H⁺]) |
| pOH | pOH = 14 - pH |
| [OH⁻] | [OH⁻] = 10^(-pOH) |
| Dilution | C₂ = (C₁ × V₁) / V₂ |

---

## Features

- 3 calculation modes via tab selector: **Molarity**, **pH / pOH**, **Dilution**
- Input validation with helpful error messages
- Results displayed in a styled result card
- Auto-saves every calculation to local history
- History screen with delete option
- Dark theme UI with cyan accent color

---

## Project Structure

```
lib/
├── main.dart                        # App entry point and theme
├── constants.dart                   # Colors and text styles
├── models/
│   └── chem_record.dart             # Data model for a calculation
├── services/
│   ├── chem_calculator_service.dart # All formula logic
│   └── storage_service.dart         # Save/load history
├── screens/
│   ├── calculator_screen.dart       # Main calculator UI
│   └── history_screen.dart          # History list UI
└── widgets/
    └── result_card.dart             # Result display widget
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  font_awesome_flutter: ^10.6.0
```

---

## Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/chem-calculator.git
   cd chem-calculator
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## Example Usage

### pH / pOH Calculation
| Input | Value |
|---|---|
| [H⁺] Concentration | 0.001 M |

| Output | Value |
|---|---|
| pH | 3.0000 |
| pOH | 11.0000 |
| [OH⁻] | 1.0000e-11 M |

### Molarity Calculation
| Input | Value |
|---|---|
| Moles | 2.5 mol |
| Volume | 1.0 L |

| Output | Value |
|---|---|
| Molarity | 2.5000 M |

### Dilution Calculation
| Input | Value |
|---|---|
| C₁ | 5.0 M |
| V₁ | 0.5 L |
| V₂ | 2.0 L |

| Output | Value |
|---|---|
| C₂ | 1.2500 M |

---

## Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Dart](https://dart.dev/) - Programming language
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local storage
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) - Icons

---

## Course Assignments

- **Assignment I** — Add Amharic localization
- **Assignment II** — Enhance the UI further
- **Assignment III** — Work on remaining engineering projects

---

## License

This project is open source and available under the [MIT License](LICENSE).
