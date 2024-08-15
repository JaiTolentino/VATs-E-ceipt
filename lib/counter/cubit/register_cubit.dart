import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<bool> {
  RegisterCubit() : super(true);

  void changeValue() => emit(!state);
}
