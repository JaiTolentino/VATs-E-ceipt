import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesCubit extends Cubit<String> {
  ExpensesCubit() : super('');
  void changeState(String value) {
    emit(value);
  }
}
