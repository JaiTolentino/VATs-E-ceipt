import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';
import 'package:posclient/counter/model/product_model.dart';
import 'package:posclient/counter/model/receipt_model.dart';
import 'package:posclient/counter/model/user_model.dart';
part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreService firestoreService;

  FirestoreBloc(this.firestoreService) : super(FirestoreInitial()) {
    on<GetUsers>((event, emit) async {
      try {
        emit(FirestoreLoading());
        final users = await firestoreService.getUsers().first;
        emit(FirestoreLoaded(users.toList()));
      } catch (e) {
        emit(FirestoreError('Failed to load users'));
      }
    });
    on<GetUserReceipts>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          final userReceipts =
              await firestoreService.getUserReceipts(event.email);
          final user = await firestoreService.getUser(event.email);
          emit(FirestoreUserReceiptsLoaded(userReceipts.toList(), user));
        } catch (e) {
          print(e);
          emit(FirestoreError('Failed to load user Receipts'));
        }
      },
    );

    on<GetUserReceiptsUpdateTag>(
      (event, emit) async {
        emit(FirestoreLoading());
        try {
          final receipts = await firestoreService.getUserReceipts(event.email);
          Iterable<ReceiptModel> searchedList = receipts.where(
            (item) => item.receiptCategory
                .toString()
                .toLowerCase()
                .contains(event.query.toLowerCase()),
          );
          emit(FirestoreUserReceiptsUpdatedLoaded(searchedList.toList()));
        } catch (e) {
          emit(FirestoreError('Failed to update list'));
        }
      },
    );
    on<GetUserReceiptsUpdate>(
      (event, emit) async {
        emit(FirestoreLoading());
        try {
          final receipts = await firestoreService.getUserReceipts(event.email);
          Iterable<ReceiptModel> searchedList = receipts.where(
            (item) => item.referenceNumber
                .toString()
                .toLowerCase()
                .contains(event.query.toLowerCase()),
          );
          emit(FirestoreUserReceiptsUpdatedLoaded(searchedList.toList()));
        } catch (e) {
          emit(FirestoreError('Failed to update list'));
        }
      },
    );

    on<AddUser>((event, emit) async {
      try {
        emit(FirestoreLoading());
        await firestoreService.addUser(event.user);
        emit(FirestoreOperationSuccess('User added successfully'));
      } catch (e) {
        FirestoreError('Failed to add user');
      }
    });
    on<GetUser>(
      (event, emit) async {
        emit(FirestoreLoading());

        String? file;
        try {
          String? rawfile = await firestoreService.getUserProfile(event.email);
          file = rawfile;
        } catch (e) {
          String? defaultFile = await firestoreService.getDefaultProfile();
          file = defaultFile;
        }
        try {
          final user = await firestoreService.getUser(event.email);
          emit(FirestoreUserLoaded(user, file));
        } catch (e) {
          emit(FirestoreError('Failed to load user'));
        }
      },
    );

    on<AddReceipt>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          await firestoreService.addReceipt(event.receipt);
          emit(FirestoreOperationSuccess('Receipt added successfully'));
        } catch (e) {
          print(e);

          emit(FirestoreError('Failed to add receipt'));
        }
      },
    );

    on<AssignReceiptToUser>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          await firestoreService.assignReceiptToUser(
              event.referenceNumber, event.email);
          emit(
              FirestoreOperationSuccess('Receipt assign to user successfully'));
        } catch (e) {
          emit(FirestoreError('Failed to assign receipt to user'));
        }
      },
    );

    on<GetReceipt>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          final receipt =
              await firestoreService.getReceipt(event.referenceNumber);
          final products =
              await firestoreService.getReceiptProducts(event.referenceNumber);

          emit(FirestoreReceiptLoaded(receipt, products.toList()));
        } catch (e) {
          emit(FirestoreError('Failed to load Receipt'));
        }
      },
    );

    on<ChangeProductTag>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          await firestoreService.changeProductTag(
              event.referenceNumber, event.tag);
          final receipt =
              await firestoreService.getReceipt(event.referenceNumber);
          final products =
              await firestoreService.getReceiptProducts(event.referenceNumber);

          emit(FirestoreReceiptLoaded(receipt, products.toList()));
        } catch (e) {
          emit(FirestoreError('Failed to edit tag'));
        }
      },
    );

    on<UploadUserProfilePhoto>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          await firestoreService.uploadUserProfilePhoto(
              event.file, event.email);
          emit(FirestoreOperationSuccess('User profile photo uploaded'));
        } catch (e) {
          print(e);
          emit(FirestoreError('Error uploading profile photo'));
        }
      },
    );

    on<ChangeFullName>(
      (event, emit) async {
        emit(FirestoreLoading());
        String? file;

        try {
          String? rawfile = await firestoreService.getUserProfile(event.email);
          file = rawfile;
        } catch (e) {
          String? defaultFile = await firestoreService.getDefaultProfile();
          file = defaultFile;
        }
        try {
          await firestoreService.changeFullName(event.email, event.name);
          final user = await firestoreService.getUser(event.email);
          emit(FirestoreUserLoaded(user, file));
        } catch (e) {
          print(e);
          emit(FirestoreError('Error changing name'));
        }
      },
    );

    on<GetUserProfile>(
      (event, emit) async {
        try {
          emit(FirestoreLoading());
          String? file = await firestoreService.getUserProfile(event.email);
          emit(FirestoreImageLoaded(file));
        } catch (e) {
          emit(FirestoreError('Error fetching Image'));
        }
      },
    );
  }
}
