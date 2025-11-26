enum GoalStatus { active, completed, paused, cancelled }

enum GoalType { savings, debt, investment, emergency, other }


extension GoalTypeExtension on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.savings:
        return 'Poupança';
      case GoalType.debt:
        return 'Quitar Dívidas';
      case GoalType.investment:
        return 'Investimento';
      case GoalType.emergency:
        return 'Reserva de Emergência';
      case GoalType.other:
        return 'Outro';
    }
  }
}

class FinancialGoal {
  final String id;
  final String userId;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final GoalType type;
  final GoalStatus status;
  final DateTime targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  FinancialGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.type,
    required this.status,
    required this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FinancialGoal.fromJson(Map<String, dynamic> json) {
    return FinancialGoal(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'] ?? '',
      targetAmount: (json['target_amount'] ?? 0).toDouble(),
      currentAmount: (json['current_amount'] ?? 0).toDouble(),
      type: GoalType.values.firstWhere(
        (e) => e.toString() == 'GoalType.${json['type']}',
        orElse: () => GoalType.other,
      ),
      status: GoalStatus.values.firstWhere(
        (e) => e.toString() == 'GoalStatus.${json['status']}',
        orElse: () => GoalStatus.active,
      ),
      targetDate: DateTime.parse(json['target_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'target_date': targetDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}