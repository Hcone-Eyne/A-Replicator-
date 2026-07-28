import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  BaseModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
