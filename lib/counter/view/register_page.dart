import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:posclient/counter/auth_service/auth_service.dart';
import 'package:posclient/counter/cubit/register_cubit.dart';
import 'package:posclient/counter/auth_service/auth_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';
import 'package:posclient/counter/model/user_model.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider<FirestoreBloc>(
          create: (context) => FirestoreBloc(FirestoreService()),
        ),
      ],
      child: RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(31, 29, 43, 1),
      body: Padding(
          padding: EdgeInsets.only(right: 27, left: 27),
          child: Column(children: [
            const SizedBox(
              height: 70,
            ),
            Image.asset('assets/images/Login_Logo.png'),
            SizedBox(
              height: 65,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Full Name'),
              ],
            ),
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(
                  hintText: 'Enter Full Name',
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Email address'),
              ],
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Enter Email',
                  hintStyle: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Password'),
              ],
            ),
            BlocBuilder<RegisterCubit, bool>(
              builder: (context, state) {
                return TextFormField(
                  controller: passwordController,
                  obscureText: state,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            context.read<RegisterCubit>().changeValue(),
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.w400)),
                );
              },
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Re-Enter Password'),
              ],
            ),
            BlocBuilder<RegisterCubit, bool>(
              builder: (context, state) {
                return TextFormField(
                  scrollPadding: EdgeInsets.only(bottom: 30),
                  controller: rePasswordController,
                  obscureText: state,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            context.read<RegisterCubit>().changeValue(),
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.w400)),
                );
              },
            ),
            SizedBox(
              height: 75,
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text.trim().length >= 6) {
                  if (passwordController.text.trim() ==
                          rePasswordController.text.trim() &&
                      passwordController.text != null &&
                      rePasswordController != null &&
                      emailController.text != null) {
                    BlocProvider.of<AuthBloc>(context).add(
                      SignUpUser(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      ),
                    );

                    BlocProvider.of<FirestoreBloc>(context).add(
                      AddUser(
                        UserModel(
                          email: emailController.text.trim(),
                          fullName: fullNameController.text.trim(),
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Password should be at least 6 characters!')));
                }
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  backgroundColor: Color.fromRGBO(57, 181, 74, 1),
                  foregroundColor: Colors.black,
                  fixedSize: Size(320, 50)),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/');
                  },
                  child: Text(
                    ' Login here',
                    style: TextStyle(
                        color: Color.fromRGBO(57, 181, 74, 1),
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromRGBO(57, 181, 74, 1)),
                  ),
                )
              ],
            ),
          ])),
    );
  }
}
