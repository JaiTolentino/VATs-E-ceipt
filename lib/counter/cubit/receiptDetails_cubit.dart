import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptdetailsCubit extends Cubit<bool> {
  ReceiptdetailsCubit() : super(true);

  void changeMode() => {emit(!state)};
}
