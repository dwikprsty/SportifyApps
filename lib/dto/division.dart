class DivisionDepartment {
  final int idDivisionTarget;
  final String divisionTarget;
  final String divisionDepartmentName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  DivisionDepartment({
    required this.idDivisionTarget,
    required this.divisionTarget,
    required this.divisionDepartmentName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_division_target': idDivisionTarget,
      'division_target': divisionTarget,
      'division_department_name': divisionDepartmentName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory DivisionDepartment.fromJson(Map<String, dynamic> json) {
    return DivisionDepartment(
      idDivisionTarget: json['id_division_target'] as int,
      divisionTarget: json['division_target'] as String,
      divisionDepartmentName: json['division_department_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }
}