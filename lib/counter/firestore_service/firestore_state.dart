part of 'firestore_bloc.dart';

abstract class FirestoreState {}

class FirestoreInitial extends FirestoreState {}

class FirestoreLoading extends FirestoreState {}

class FirestoreLoaded extends FirestoreState {
  final List<UserModel> user;

  FirestoreLoaded(this.user);
}

class FirestoreUserLoaded extends FirestoreState {
  final UserModel? user;
  final String? file;
  FirestoreUserLoaded(this.user, this.file);
}

class FirestoreUserReceiptsLoaded extends FirestoreState {
  final List<ReceiptModel> userReceipts;
  final UserModel? user;

  FirestoreUserReceiptsLoaded(this.userReceipts, this.user);
}

class FirestoreUserReceiptsUpdatedLoaded extends FirestoreState {
  final List<ReceiptModel> userReceipts;
  FirestoreUserReceiptsUpdatedLoaded(this.userReceipts);
}

class FirestoreOperationSuccess extends FirestoreState {
  final String message;

  FirestoreOperationSuccess(this.message);
}

class FirestoreError extends FirestoreState {
  final String errorMessage;

  FirestoreError(this.errorMessage);
}

class FirestoreReceiptLoaded extends FirestoreState {
  FirestoreReceiptLoaded(this.receipt, this.products);
  final ReceiptModel? receipt;
  final List<ProductModel> products;
}

class FirestoreProductsLoaded extends FirestoreState {
  FirestoreProductsLoaded(this.products);
  final List<ProductModel> products;
}

class FirestoreImageLoaded extends FirestoreState {
  FirestoreImageLoaded(this.image);
  final String? image;
}
