enum TransactionType { income, expense }

enum TransactionCategory {
  // Receitas
  salary,
  freelance,
  investment,
  otherIncome,
  
  // Despesas
  housing,
  transportation,
  food,
  health,
  education,
  entertainment,
  shopping,
  utilities,
  otherExpense,
}

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final TransactionCategory category;
  final String description;
  final double amount;
  final DateTime date;
  final bool isRecurring;
  final int? recurringIntervalDays; // Para transações recorrentes
  final DateTime? recurringEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    this.isRecurring = false,
    this.recurringIntervalDays,
    this.recurringEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
      ),
      category: TransactionCategory.values.firstWhere(
        (e) => e.toString() == 'TransactionCategory.${json['category']}',
      ),
      description: json['description'],
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      isRecurring: json['is_recurring'] ?? false,
      recurringIntervalDays: json['recurring_interval_days'],
      recurringEndDate: json['recurring_end_date'] != null
          ? DateTime.parse(json['recurring_end_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.toString().split('.').last,
      'category': category.toString().split('.').last,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'is_recurring': isRecurring,
      'recurring_interval_days': recurringIntervalDays,
      'recurring_end_date': recurringEndDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get categoryDisplayName {
    switch (category) {
      case TransactionCategory.salary:
        return 'Salário';
      case TransactionCategory.freelance:
        return 'Freelance';
      case TransactionCategory.investment:
        return 'Investimentos';
      case TransactionCategory.otherIncome:
        return 'Outras Receitas';
      case TransactionCategory.housing:
        return 'Moradia';
      case TransactionCategory.transportation:
        return 'Transporte';
      case TransactionCategory.food:
        return 'Alimentação';
      case TransactionCategory.health:
        return 'Saúde';
      case TransactionCategory.education:
        return 'Educação';
      case TransactionCategory.entertainment:
        return 'Entretenimento';
      case TransactionCategory.shopping:
        return 'Compras';
      case TransactionCategory.utilities:
        return 'Utilidades';
      case TransactionCategory.otherExpense:
        return 'Outras Despesas';
    }
  }

  String get typeDisplayName {
    return type == TransactionType.income ? 'Receita' : 'Despesa';
  }

  Transaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    TransactionCategory? category,
    String? description,
    double? amount,
    DateTime? date,
    bool? isRecurring,
    int? recurringIntervalDays,
    DateTime? recurringEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringIntervalDays: recurringIntervalDays ?? this.recurringIntervalDays,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
