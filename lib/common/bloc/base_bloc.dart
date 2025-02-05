import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<T, R> extends Bloc<T, R> {
  BaseBloc(super.initialState);
}
