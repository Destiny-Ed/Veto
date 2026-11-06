import 'package:hive/hive.dart';

part 'trade.g.dart';

@HiveType(typeId: 0)
class Trade {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final String pair;
  @HiveField(3)
  final String direction; // buy/sell
  @HiveField(4)
  final String result; // win/loss/be
  @HiveField(5)
  final bool heldToTarget;
  @HiveField(6)
  final bool interfered;
  @HiveField(7)
  final String? note;

  Trade({
    required this.id,
    required this.timestamp,
    required this.pair,
    required this.direction,
    required this.result,
    required this.heldToTarget,
    required this.interfered,
    this.note,
  });
}
