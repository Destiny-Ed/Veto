import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<bool> _checks = List.filled(5, false);
  bool _affirmed = false;

  final items = [
    'Max 2 trades. First loss = done for the day.',
    'Hold to TP or SL. No interference.',
    'Minimum 1.3 RR or clear liquidity level.',
    'No revenge trading.',
    'Zero trades is a successful day.',
  ];

  @override
  Widget build(BuildContext context) {
    final allChecked = _checks.every((c) => c) && _affirmed;
    return Scaffold(
      appBar: AppBar(title: const Text('Morning Checklist')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Confirm before unlocking trading apps', style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0))),
          const SizedBox(height: 24),
          ...List.generate(items.length, (i) {
            return CheckboxListTile(
              value: _checks[i],
              onChanged: (v) => setState(() => _checks[i] = v ?? false),
              title: Text(items[i]),
              activeColor: const Color(0xFF1E88E5),
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _affirmed,
            onChanged: (v) => setState(() => _affirmed = v ?? false),
            title: const Text('I affirm I will follow these rules today. Veto has the final say.'),
            activeColor: const Color(0xFF1E88E5),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: allChecked
                ? () {
                    context.read<AppState>().completeChecklist();
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Unlock Trading Apps'),
          ),
        ],
      ),
    );
  }
}
