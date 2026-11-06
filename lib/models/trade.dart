class Trade {
  final String id;
  final DateTime timestamp;
  final String pair;
  final String direction;
  final String result;
  final bool heldToTarget;
  final bool interfered;
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

  Map<String, dynamic> toMap() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'pair': pair,
        'direction': direction,
        'result': result,
        'heldToTarget': heldToTarget,
        'interfered': interfered,
        'note': note,
      };

  factory Trade.fromMap(Map<String, dynamic> map) => Trade(
        id: map['id'],
        timestamp: DateTime.parse(map['timestamp']),
        pair: map['pair'],
        direction: map['direction'],
        result: map['result'],
        heldToTarget: map['heldToTarget'] ?? true,
        interfered: map['interfered'] ?? false,
        note: map['note'],
      );
}
