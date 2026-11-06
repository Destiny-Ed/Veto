import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';
import '../models/trade.dart';

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
    _loadToday();
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
    } else if (todayHadLoss && firstLossDone || todayTrades >= maxTrades) {
      currentState = LockState.dayClosed;
    } else {
      currentState = LockState.unlocked;
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
    notifyListeners();
  }

  Future<void> completeChecklist() async {
    checklistDoneToday = true;
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    await _box.put('checklist_$key', true);
    _updateState();
    notifyListeners();
    // TODO: unlock apps via platform channel
  }

  Future<void> logTrade(Trade trade) async {
    trades.add(trade);
    todayTrades++;
    if (trade.result == 'loss') todayHadLoss = true;
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    await _box.put('trades_$key', todayTrades);
    await _box.put('loss_$key', todayHadLoss);
    _updateState();
    if (currentState == LockState.dayClosed) {
      // TODO: lock apps via platform channel
    }
    notifyListeners();
  }

  bool get canTrade => currentState == LockState.unlocked;
}
