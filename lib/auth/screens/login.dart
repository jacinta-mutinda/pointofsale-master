import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

import 'company_det.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final auth = Get.put(AuthCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: OtpScreen(),
          ),
        ));
  }
}

// ignore: use_key_in_widget_constructors
class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<String> currentPin = ["", "", "", "", "", ""];
  bool _isLoading = false;
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  TextEditingController pinFiveController = TextEditingController();
  TextEditingController pinSixController = TextEditingController();

  var roundRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    // borderSide: const BorderSide(color: Colors.white),
  );
  int pinIndex = 0;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          buildExitButton(),
          Expanded(
              child: Container(
            alignment: const Alignment(0, 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildSecurityText(),
                const SizedBox(
                  height: 40.0,
                ),
                buildPinRow(),
              ],
            ),
          )),
          buildNumberPad(),
          const SizedBox(
            height: 10.0,
          ),
          buildRegLink(),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  buildNumberPad() {
    return Expanded(
        child: Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1");
                    }),
                KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2");
                    }),
                KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3");
                    }),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4");
                    }),
                KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5");
                    }),
                KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6");
                    }),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7");
                    }),
                KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8");
                    }),
                KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9");
                    }),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 60.0,
                  child: MaterialButton(
                    height: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    onPressed: () {
                      clearPin();
                    },
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: kLightGreen,
                    ),
                    //color: Colors.black12,
                  ),
                ),
                KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    }),
                smallPriBtn(
                    label: 'Log In',
                    txtColour: Colors.white,
                    bgColour: kDarkGreen,
                    isLoading: _isLoading,
                    function: () {
                      var branch =
                          pinOneController.text + pinTwoController.text;
                      var pin = pinThreeController.text +
                          pinFourController.text +
                          pinFiveController.text +
                          pinSixController.text;
                      auth.login(branch, pin);


                    })
              ],
            )
          ],
        ),
      ),
    ));
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 6) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  pinIndexSetup(String text) {
    if (pinIndex == 0)
      // ignore: curly_braces_in_flow_control_structures
      pinIndex = 1;
    else if (pinIndex < 6) {
      pinIndex++;
    }

    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";
    // ignore: avoid_function_literals_in_foreach_calls
    currentPin.forEach((e) {
      strPin += e;
    });
    if (pinIndex == 6) {
      debugPrint(strPin);
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
      case 5:
        pinFiveController.text = text;
        break;
      case 6:
        pinSixController.text = text;
        break;

      default:
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PINNumber(
          roundRectangleBorder: roundRectangleBorder,
          textEditingController: pinOneController,
        ),
        PINNumber(
          roundRectangleBorder: roundRectangleBorder,
          textEditingController: pinTwoController,
        ),
        PINNumber(
          roundRectangleBorder: roundRectangleBorder,
          textEditingController: pinThreeController,
        ),
        PINNumber(
          roundRectangleBorder: roundRectangleBorder,
          textEditingController: pinFourController,
        ),
        PINNumber(
          roundRectangleBorder: roundRectangleBorder,
          textEditingController: pinFiveController,
        ),
        PINNumber(
          roundRectangleBorder: roundRectangleBorder,
          textEditingController: pinSixController,
        ),
      ],
    );
  }

  buildSecurityText() {
    return Column(
      children: [
        SizedBox(
            child: Image.asset('assets/images/nawiri-logo.png',
                width: 100, height: 100, fit: BoxFit.fill)),
        const Text("Enter your Nawiri Passcode", style: kSubTitle),

      ],
    );
  }

  buildExitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {},
            height: 50.0,
            minWidth: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
  buildRegLink() {
    return Column(
      children: [
        textSpan(
            mainLabel: "Don't have an account? ",
            childLabel: 'Register',
            function: () {
              Get.to(const CompanyDetails());
            })

      ],
    );
  }
}

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final RoundedRectangleBorder roundRectangleBorder;
  final formKey = GlobalKey<FormState>();
  // ignore: use_key_in_widget_constructors
  PINNumber(
      {required this.textEditingController,
      required this.roundRectangleBorder});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    var requestModel;
    return Form(
        child: SizedBox(
      width: 50.0,
      child: TextFormField(
        controller: textEditingController,
        enabled: true,
        obscureText: true,
        onSaved: (input) => requestModel.pin = input,
        validator: (value) {
          return value == '222222' ? null : 'Pin is incorrect';
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white30,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: kDarkGreen,
        ),
      ),
    ));
  }

  bool validateAndSave() {
    var globalFormKey;
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  KeyboardNumber({required this.n, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: kDarkGreen),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: const EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
