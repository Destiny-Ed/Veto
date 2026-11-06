import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';
import '../models/trade.dart';
import '../services/blocker_service.dart';

class AppState extends ChangeNotifier {
  late Box _box;
  bool onboardingComplete = false;
  int maxTrades = 2;
  bool firstLossDone = true;
  List<String> selectedApps = [];
  LockState currentState = LockState.pendingMorning;
  int todayTrades = 0;
  bool todayHadLoss = false;
  bool checklistDoneToday = false;
  List<Trade> trades = [];
  int cleanStreak = 0;

  Future<void> init() async {
    _box = Hive.box('veto_box');
    onboardingComplete = _box.get('onboarding', defaultValue: false);
    maxTrades = _box.get('maxTrades', defaultValue: 2);
    firstLossDone = _box.get('firstLossDone', defaultValue: true);
    selectedApps = List<String>.from(_box.get('selectedApps', defaultValue: []));
    cleanStreak = _box.get('cleanStreak', defaultValue: 0);
    // Load trades as simple maps for now (full Hive adapter later)
    final rawTrades = _box.get('all_trades', defaultValue: <Map>[]);
    trades = (rawTrades as List).map((m) => Trade.fromMap(Map<String, dynamic>.from(m))).toList();
    _loadToday();
    await _applyLockState();
    notifyListeners();
  }

  void _loadToday() {
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    todayTrades = _box.get('trades_$key', defaultValue: 0);
    todayHadLoss = _box.get('loss_$key', defaultValue: false);
    checklistDoneToday = _box.get('checklist_$key', defaultValue: false);
    _updateState();
  }

  void _updateState() {
    if (!checklistDoneToday) {
      currentState = LockState.pendingMorning;
    } else if ((todayHadLoss && firstLossDone) || todayTrades >= maxTrades) {
      currentState = LockState.dayClosed;
    } else {
      currentState = LockState.unlocked;
    }
  }

  Future<void> _applyLockState() async {
    if (selectedApps.isEmpty) return;
    if (currentState == LockState.unlocked) {
      await BlockerService.unlockApps(selectedApps);
    } else {
      await BlockerService.lockApps(selectedApps);
    }
  }

  Future<void> completeOnboarding({
    required int max,
    required bool firstLoss,
    required List<String> apps,
  }) async {
    maxTrades = max;
    firstLossDone = firstLoss;
    selectedApps = apps;
    onboardingComplete = true;
    await _box.put('onboarding', true);
    await _box.put('maxTrades', max);
    await _box.put('firstLossDone', firstLoss);
    await _box.put('selectedApps', apps);
    await BlockerService.requestPermissions();
    await _applyLockState();
    notifyListeners();
  }

  Future<void> completeChecklist() async {
    checklistDoneToday = true;
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    await _box.put('checklist_$key', true);
    _updateState();
    await _applyLockState();
    notifyListeners();
  }

  Future<void> logTrade(Trade trade) async {
    trades.add(trade);
    todayTrades++;
    if (trade.result == 'loss') todayHadLoss = true;
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    await _box.put('trades_$key', todayTrades);
    await _box.put('loss_$key', todayHadLoss);
    await _box.put('all_trades', trades.map((t) => t.toMap()).toList());
    _updateState();
    await _applyLockState();
    notifyListeners();
  }

  bool get canTrade => currentState == LockState.unlocked;
}
