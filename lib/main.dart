import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';

void main(){
  runApp(const ChemApp());
}
class ChemApp extends StatelessWidget{
  const ChemApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Chem Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00D2FF),
          secondary: const Color(0xFF00D2FF),
          surface: const Color(0xFF1D1F33),

        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0XFF1D1F33),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00D2FF), width: 1.5),

          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          labelStyle: const TextStyle(color: Color(0xFF8D8E98)),
          prefixIconColor: const Color(0xFF00D2FF),
        ),

      ),
      home: const CalculatorScreen(),
    );
  }
}