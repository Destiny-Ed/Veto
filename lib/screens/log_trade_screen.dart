import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_state.dart';
import '../models/trade.dart';

class LogTradeScreen extends StatefulWidget {
  const LogTradeScreen({super.key});

  @override
  State<LogTradeScreen> createState() => _LogTradeScreenState();
}

class _LogTradeScreenState extends State<LogTradeScreen> {
  String _pair = 'XAUUSD';
  String _direction = 'buy';
  String _result = 'win';
  bool _held = true;
  bool _interfered = false;
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Trade')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          DropdownButtonFormField<String>(
            value: _pair,
            decoration: const InputDecoration(labelText: 'Pair', border: OutlineInputBorder()),
            items: ['XAUUSD', 'USDJPY', 'GBPUSD', 'EURUSD', 'US30', 'Other']
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => setState(() => _pair = v!),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'buy', label: Text('Buy')),
              ButtonSegment(value: 'sell', label: Text('Sell')),
            ],
            selected: {_direction},
            onSelectionChanged: (s) => setState(() => _direction = s.first),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'win', label: Text('Win')),
              ButtonSegment(value: 'loss', label: Text('Loss')),
              ButtonSegment(value: 'be', label: Text('BE')),
            ],
            selected: {_result},
            onSelectionChanged: (s) => setState(() => _result = s.first),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Held to TP or SL'),
            value: _held,
            activeColor: const Color(0xFF1E88E5),
            onChanged: (v) => setState(() => _held = v),
          ),
          SwitchListTile(
            title: const Text('Interfered with trade'),
            value: _interfered,
            activeColor: const Color(0xFFEF5350),
            onChanged: (v) => setState(() => _interfered = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: _result == 'loss' ? const Color(0xFFEF5350) : const Color(0xFF1E88E5),
            ),
            child: const Text('Save & Update Lock'),
          ),
        ],
      ),
    );
  }

  void _save() {
    final trade = Trade(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      pair: _pair,
      direction: _direction,
      result: _result,
      heldToTarget: _held,
      interfered: _interfered,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );
    context.read<AppState>().logTrade(trade);
    Navigator.pop(context);
  }
}
