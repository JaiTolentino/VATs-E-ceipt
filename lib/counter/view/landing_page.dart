import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:posclient/counter/auth_service/auth_bloc.dart';
import 'package:posclient/counter/cubit/landing_cubit.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LandingCubit(),
        ),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => FirestoreBloc(FirestoreService())),
      ],
      child: LandingView(),
    );
  }
}

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(31, 29, 43, 1),
      body: Padding(
        padding: EdgeInsets.only(right: 27, left: 27),
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Image.asset('assets/images/Login_Logo.png'),
            SizedBox(
              height: 65,
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
            BlocBuilder<LandingCubit, bool>(
              builder: (context, state) {
                return TextFormField(
                  controller: passwordController,
                  obscureText: state,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            context.read<LandingCubit>().changeValue(),
                        icon: const Icon(Icons.remove_red_eye),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.w400)),
                );
              },
            ),
            // SizedBox(
            //   height: 16,
            // ),
            // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            //   GestureDetector(
            //     onTap: () {
            //       const snackBar = SnackBar(content: Text('Forgot Password'));

            //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //     },
            //     child: Text('Forgot Password?'),
            //   ),
            // ]),
            SizedBox(
              height: 75,
            ),
            TextButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  BlocProvider.of<AuthBloc>(context).add(
                    SignInUser(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    ),
                  );
                  FirebaseAuth.instance.authStateChanges().listen((User? user) {
                    print(user);
                    if (user == null) {
                      const snackBar = SnackBar(
                        content: Text('Username/Password Incorrect'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      context.go('/home');
                      emailController.text = '';
                      passwordController.text = '';
                    }
                  });
                } else {
                  const snackBar = SnackBar(
                    content: Text('Please enter email and password'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  backgroundColor: Color.fromRGBO(57, 181, 74, 1),
                  foregroundColor: Colors.black,
                  fixedSize: Size(320, 50)),
              child: const Text('Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No account?',
                  style: TextStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/register');
                  },
                  child: Text(
                    ' Register Here',
                    style: TextStyle(
                        color: Color.fromRGBO(57, 181, 74, 1),
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromRGBO(57, 181, 74, 1)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
