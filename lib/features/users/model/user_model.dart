class User {
  final String id;
  final String email;
  final String name;
  final double monthlyIncome;
  final double monthlyFixedExpenses;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.monthlyIncome,
    required this.monthlyFixedExpenses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? '',
      monthlyIncome: (json['monthly_income'] ?? 0).toDouble(),
      monthlyFixedExpenses: (json['monthly_fixed_expenses'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'monthly_income': monthlyIncome,
      'monthly_fixed_expenses': monthlyFixedExpenses,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    double? monthlyIncome,
    double? monthlyFixedExpenses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyFixedExpenses: monthlyFixedExpenses ?? this.monthlyFixedExpenses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}