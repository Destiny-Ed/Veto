import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: state.trades.isEmpty
          ? const Center(child: Text('No trades logged yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.trades.length,
              itemBuilder: (context, i) {
                final t = state.trades[state.trades.length - 1 - i];
                final isLoss = t.result == 'loss';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isLoss ? const Color(0xFFEF5350) : const Color(0xFF1E88E5),
                      child: Text(t.result[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text('${t.pair} ${t.direction.toUpperCase()}'),
                    subtitle: Text('${t.result.toUpperCase()} • ${t.heldToTarget ? "Held" : "Interfered"}'),
                    trailing: Text(
                      '${t.timestamp.hour.toString().padLeft(2, '0')}:${t.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Color(0xFFB0B0B0)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
