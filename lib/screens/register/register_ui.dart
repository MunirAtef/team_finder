
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_finder/screens/login/login_ui.dart';
import 'package:team_finder/screens/register/register_cubit.dart';
import 'package:team_finder/shared_widgets/edited_button.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';
import 'package:team_finder/shared_widgets/login_background.dart';
import 'package:team_finder/shared_widgets/gradient_divider.dart';



class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterCubit cubit = BlocProvider.of<RegisterCubit>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          "REGISTER",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
      ),

      body: Stack(
        children: [
          const LoginBackground(),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (BuildContext context, RegisterState state) {
                return Column(
                  children: [
                    const SizedBox(width: double.infinity, height: 60),

                    EditedTextField(
                      controller: cubit.emailController,
                      hint: "Email",
                      prefix: Icon(Icons.email, color: Colors.cyan[700]),
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),

                    EditedTextField(
                      controller: cubit.passController,
                      hint: "Password",
                      prefix: Icon(Icons.lock, color: Colors.cyan[700]),
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      hideText: state.passHidden,
                      suffix: IconButton(
                        onPressed: () => cubit.changePassVisibility(),
                        icon: state.passHidden?
                          const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )
                    ),

                    EditedTextField(
                      controller: cubit.confirmPassController,
                      hint: "Confirm Password",
                      prefix: Icon(Icons.lock, color: Colors.cyan[700]),
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      hideText: state.confirmPassHidden,
                      suffix: IconButton(
                        onPressed: () => cubit.changeConfirmPassVisibility(),
                        icon: state.confirmPassHidden?
                          const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      )
                    ),

                    EditedButton(
                      text: "NEXT",
                      leading: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white
                      ),
                      isLoading: state.loadingEmail,

                      onPressed: state.loadingGoogle ? null
                        : () async => await cubit.registerWithEmail(context),
                    ),

                    const Divider(thickness: 2, indent: 50, endIndent: 50),

                    EditedButton(
                      color: Colors.red,
                      text: "REGISTER WITH GOOGLE",
                      leading: const Icon(FontAwesomeIcons.google, color: Colors.white),
                      isLoading: state.loadingGoogle,

                      onPressed: state.loadingEmail ? null
                        : () async => await cubit.registerWithGoogle(context),
                    ),

                    const GradiantDivider(),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Login()
                          )
                        );
                      },
                      child:  Text(
                        "ALREADY HAVE AN ACCOUNT? LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.cyan[800]
                        ),
                      )
                    )
                  ],
                );
              },

            ),
          )
        ],
      )
    );
  }



}


