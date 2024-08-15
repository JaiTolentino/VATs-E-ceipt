import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posclient/counter/model/userAuth_model.dart';
import 'package:posclient/counter/auth_service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();

  AuthBloc() : super(AuthInitState()) {
    on<AuthEvent>((event, emit) {});
    on<SignUpUser>(
      (event, emit) async {
        emit(AuthLoadingState(isLoading: true));
        try {
          final UserAuthModel? user =
              await authService.signUpUser(event.email, event.password);

          if (user != null) {
            emit(AuthSuccessState(user));
          } else {
            emit(const AuthFailedState('Error Creating User!'));
          }
        } catch (e) {
          print(e.toString());
        }
        emit(AuthLoadingState(isLoading: false));
      },
    );

    on<SignInUser>(
      (event, emit) async {
        emit(AuthLoadingState(isLoading: true));
        try {
          await authService.signInUser(event.email, event.password);
          emit(AuthLoadingState(isLoading: false));
          emit(AuthLoginSuccess('Logged in'));
        } catch (e) {
          emit(AuthFailedState('Error logging in'));
        }
      },
    );

    on<changePassword>(
      (event, emit) async {
        emit(AuthLoadingState(isLoading: true));

        try {
          await authService.changePassword(event.email);

          emit(AuthLoginSuccess('Email Sent'));
        } catch (e) {
          emit(AuthFailedState('Error sending Email'));
        }
      },
    );

    on<SignOutUser>(
      (event, emit) async {
        emit(AuthLoadingState(isLoading: true));
        try {
          await authService.signOutUser();
          emit(AuthLoadingState(isLoading: false));
        } catch (e) {
          emit(AuthFailedState('Error signing out'));
        }
      },
    );
  }
}
