part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();

  List<Object> get props => [];
}

class SignUpUser extends AuthEvent {
  final String email;
  final String password;

  const SignUpUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutUser extends AuthEvent {}

class SignInUser extends AuthEvent {
  final String email;
  final String password;

  SignInUser(this.email, this.password);
}

class changePassword extends AuthEvent {
  changePassword(this.email);
  final String email;
}
