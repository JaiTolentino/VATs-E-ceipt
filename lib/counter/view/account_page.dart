import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posclient/counter/auth_service/auth_bloc.dart';
import 'package:posclient/counter/auth_service/auth_service.dart';
import 'package:posclient/counter/cubit/account_cubit.dart';
import 'package:posclient/counter/firestore_service/firestore_bloc.dart';
import 'package:posclient/counter/firestore_service/firestore_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => AccountCubit()),
      BlocProvider(create: (context) => FirestoreBloc(FirestoreService())),
      BlocProvider(create: (context) => AuthBloc())
    ], child: AccountView());
  }
}

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/');
    }
    BlocProvider.of<FirestoreBloc>(context).add(GetUser(user!.email!));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 29, 43, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutUser());

                context.go('/');
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<FirestoreBloc, FirestoreState>(
        builder: (context, state) {
          if (state is FirestoreUserLoaded) {
            nameController.text = state.user!.fullName;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.width * 0.3,
                    color: Color.fromRGBO(31, 29, 43, 1),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Image.network(
                            state.file!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () async {
                            final ImagePicker pocker = ImagePicker();

                            final XFile? image = await pocker.pickImage(
                                source: ImageSource.gallery);

                            if (image != null) {
                              BlocProvider.of<FirestoreBloc>(context).add(
                                  UploadUserProfilePhoto(image, user!.email!));
                            }
                            // Uint8List? bytesFromPicker =
                            //     await ImagePickerWeb.getImageAsBytes();
                            // if (bytesFromPicker != null) {
                            //   BlocProvider.of<FirestoreBloc>(context).add(
                            //     UploadUserProfilePhoto(
                            //       bytesFromPicker,
                            //       'jaitolentinoo@gmail.com',
                            //     ),
                            //   );
                            // }
                          },
                          child: Text('Change Photo'),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Color.fromRGBO(57, 181, 74, 1),
                              foregroundColor: Colors.white,
                              fixedSize: Size(145, 35)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                elevation: 5,
                                shadowColor: Colors.black,
                                child: TextFormField(
                                  controller: nameController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Color.fromRGBO(57, 181, 74, 1),
                                      onPressed: () {
                                        BlocProvider.of<FirestoreBloc>(context)
                                            .add(
                                          ChangeFullName(
                                            user!.email!,
                                            nameController.text,
                                          ),
                                        );
                                      },
                                    ),
                                    fillColor: Colors.black,
                                    hintText: state.user!.fullName,
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                elevation: 5,
                                shadowColor: Colors.black,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: emailController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: state.user!.email,
                                    hintStyle: TextStyle(
                                        wordSpacing: 20, color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                elevation: 5,
                                shadowColor: Colors.black,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: passwordController,
                                  obscureText: true,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    fillColor: Colors.black,
                                    hintText: "******",
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        changePassword(
                                          user!.email!,
                                        ),
                                      );
                                    },
                                    child: Text('Change Password via Email'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        backgroundColor:
                                            Color.fromRGBO(57, 181, 74, 1),
                                        foregroundColor: Colors.white,
                                        fixedSize: Size(200, 45)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromRGBO(57, 181, 74, 1),
        unselectedLabelStyle:
            const TextStyle(color: Color.fromRGBO(130, 130, 130, 1)),
        showUnselectedLabels: true,
        unselectedItemColor: Color.fromRGBO(130, 130, 130, 1),
        backgroundColor: const Color.fromRGBO(31, 29, 43, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () => context.go('/home'), icon: Icon(Icons.home)),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.qr_code),
                onPressed: () => context.go('/qr'),
              ),
              label: "QR Code"),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.receipt),
                onPressed: () => context.go('/expenses'),
              ),
              label: "Expenses"),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.person),
                onPressed: () => context.go('/account'),
              ),
              label: "Account"),
        ],
      ),
    );
  }
}
