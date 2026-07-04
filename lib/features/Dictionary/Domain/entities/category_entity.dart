import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, isActive, createdAt];
}
