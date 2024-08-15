import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<bool> {
  ResetPasswordCubit() : super(true);

  void changeValue() => emit(!state);
}
