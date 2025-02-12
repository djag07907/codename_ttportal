import 'package:equatable/equatable.dart';

base class BaseResponse extends Equatable {
  final int code;
  final String? lang;
  final String message;

  const BaseResponse({
    required this.code,
    required this.lang,
    required this.message,
  });

  @override
  List<Object?> get props => [];
}
