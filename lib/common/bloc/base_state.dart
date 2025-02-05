import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object> get props => [];
}

final class InitialState extends BaseState {}

final class ServerClientError extends BaseState {}
