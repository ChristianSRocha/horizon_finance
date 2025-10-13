enum GoalStatus { active, completed, paused, cancelled }

enum GoalType { savings, debt, investment, emergency, other }

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
      ),
      status: GoalStatus.values.firstWhere(
        (e) => e.toString() == 'GoalStatus.${json['status']}',
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

  String get typeDisplayName {
    switch (type) {
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

  String get statusDisplayName {
    switch (status) {
      case GoalStatus.active:
        return 'Ativo';
      case GoalStatus.completed:
        return 'Concluído';
      case GoalStatus.paused:
        return 'Pausado';
      case GoalStatus.cancelled:
        return 'Cancelado';
    }
  }

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  double get remainingAmount {
    return (targetAmount - currentAmount).clamp(0.0, double.infinity);
  }

  int get daysRemaining {
    final now = DateTime.now();
    final difference = targetDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  double get dailyRequiredAmount {
    if (daysRemaining <= 0) return 0.0;
    return remainingAmount / daysRemaining;
  }

  bool get isCompleted {
    return status == GoalStatus.completed || currentAmount >= targetAmount;
  }

  bool get isOverdue {
    return DateTime.now().isAfter(targetDate) && !isCompleted;
  }

  FinancialGoal copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    GoalType? type,
    GoalStatus? status,
    DateTime? targetDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinancialGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      type: type ?? this.type,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
