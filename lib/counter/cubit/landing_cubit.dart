import 'package:flutter_bloc/flutter_bloc.dart';

class LandingCubit extends Cubit<bool> {
  LandingCubit() : super(true);

  void changeValue() => emit(!state);
}
