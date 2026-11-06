enum LockState {
  locked,
  pendingMorning,
  unlocked,
  cooldown,
  dayClosed,
}

class DailySession {
  final DateTime date;
  int tradesTaken;
  bool hadLoss;
  LockState state;
  bool checklistCompleted;
  List<String> ruleBreaks;

  DailySession({
    required this.date,
    this.tradesTaken = 0,
    this.hadLoss = false,
    this.state = LockState.pendingMorning,
    this.checklistCompleted = false,
    this.ruleBreaks = const [],
  });
}
