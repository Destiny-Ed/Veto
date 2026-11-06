import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/session.dart' as lock;
import 'checklist_screen.dart';
import 'log_trade_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _StatusCard(state: state),
            const SizedBox(height: 32),
            if (state.currentState == lock.LockState.pendingMorning)
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChecklistScreen())),
                child: const Text('Complete Morning Checklist'),
              ),
            if (state.canTrade)
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LogTradeScreen())),
                child: const Text('Log a Trade'),
              ),
            if (state.currentState == lock.LockState.dayClosed)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Session ended.\nTrading apps are locked until tomorrow.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFFEF5350)),
                ),
              ),
            const Spacer(),
            Text('Clean streak: ${state.cleanStreak} days', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final AppState state;
  const _StatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLocked = state.currentState != LockState.unlocked;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLocked
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
              : [const Color(0xFF0D47A1), const Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1E88E5).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Icon(isLocked ? Icons.lock : Icons.lock_open, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            isLocked ? 'LOCKED' : 'UNLOCKED',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'Trades today: ${state.todayTrades} / ${state.maxTrades}',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          if (state.todayHadLoss)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Loss taken — session closed', style: TextStyle(color: Color(0xFFFFCDD2))),
            ),
        ],
      ),
    );
  }
}
