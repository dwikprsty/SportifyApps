class CustomerService {
  final int idCustomerService;
  final String nim;
  final String title;
  final String description;
  final int rating;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime utc8CreatedAt;
  final DateTime utc8UpdatedAt;
  final DateTime? utc8DeletedAt;


  CustomerService({
    required this.idCustomerService,
    required this.nim,
    required this.title,
    required this.description,
    required this.rating,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.utc8CreatedAt,
    required this.utc8UpdatedAt,
    this.utc8DeletedAt,
  });

  factory CustomerService.fromJson(Map<String, dynamic> json) {
    return CustomerService(
      idCustomerService: json['id_customer_service'] as int,
      nim: json['nim'] as String,
      title: json['title_issues'] as String,
      description: json['description_issues'] as String,
      rating: json['rating'] as int,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      utc8CreatedAt: DateTime.parse(json['UTC8_CREATED_AT'] as String),
      utc8UpdatedAt: DateTime.parse(json['UTC8_UPDATED_AT'] as String),
      utc8DeletedAt: json['UTC8_DELETED_AT'] != null
          ? DateTime.parse(json['UTC8_DELETED_AT'] as String)
          : null,
      
    );
  }
}