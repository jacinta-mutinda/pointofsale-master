import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/work_period/shift/shift_ctrl.dart';
import 'package:nawiri/core/work_period/wp_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:intl/intl.dart';

class ShiftPage extends StatefulWidget {
  static const routeName = "/shift";
  const ShiftPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShiftPageState createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  final shiftCtrl = Get.put(ShiftCtrl());
  final bankingCtrl = Get.put(BankingCtrl());
  bool dayShiftValue = true;
  Shift shiftData =
  Shift(id: 1, date: '', desc: '', time: '', float: 0, dayShift: '');
  TextEditingController datectrl = TextEditingController();
  TextEditingController timectrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();
  TextEditingController floatctrl = TextEditingController();
  TextEditingController closeFloatctrl = TextEditingController();
  TextEditingController typectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    datectrl.text = DateFormat("EEEEE, dd, yyyy").format(DateTime.now());
  }

  @override
  void dispose() {
    datectrl.dispose();
    floatctrl.dispose();
    timectrl.dispose();
    descctrl.dispose();
    typectrl.dispose();
    closeFloatctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
          pageTitle:
          shiftCtrl.shiftStarted.value ? 'Close Shift' : 'Open Shift',
          actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text('Enter Shift Details', style: kTitle)),
            Obx(() => !shiftCtrl.shiftStarted.value
                ? Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    dateFormField(
                        label: 'Date',
                        controller: datectrl,
                        showDate: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                            setState(() {
                              datectrl.text = formattedDate;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the shift date';
                          }
                          return null;
                        }),
                    descFormField(
                        label: 'Desription', controller: descctrl),
                    formField(
                        label: 'Opening Float (in Kes)',
                        require: true,
                        controller: floatctrl,
                        type: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the opening float";
                          }
                          return null;
                        }),
                    CheckboxListTile(
                      title: const Text('Day Shift',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                              color: kDarkGreen)),
                      checkColor: kDarkGreen,
                      activeColor: kLightGreen,
                      value: dayShiftValue,
                      onChanged: (value) {
                        setState(() {
                          dayShiftValue = value!;
                        });
                      },
                    ),
                    priBtn(
                      bgColour: kDarkGreen,
                      txtColour: Colors.white,
                      label: 'Start Shift',
                      isLoading: _isLoading,
                      function: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          shiftData.date = datectrl.text;
                          shiftData.time = timectrl.text;
                          shiftData.desc = descctrl.text;
                          shiftData.float = int.parse(floatctrl.text);
                          shiftData.dayShift = 'Y';
                          shiftCtrl.startShift(shiftData);
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    )
                  ],
                ))
                : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    formDropDownField(
                        label: 'Account Type',
                        dropdownValue: shiftCtrl.accDropdown.value,
                        dropItems: bankingCtrl.bankAccStrs,
                        bgcolor: kGrey,
                        function: (String? newValue) {
                          setState(() {
                            shiftCtrl.accDropdown.value = newValue!;
                          });
                        }),
                    formField(
                        label: 'Transaction Type',
                        require: true,
                        controller: typectrl,
                        type: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the transaction type';
                          }
                          return null;
                        }),
                    formField(
                        label: 'Closing Float (in Kes)',
                        require: true,
                        controller: closeFloatctrl,
                        type: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the closing float";
                          }
                          return null;
                        }),
                    priBtn(
                      bgColour: kDarkGreen,
                      txtColour: Colors.white,
                      label: 'Close Shift',
                      isLoading: _isLoading,
                      function: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          shiftCtrl.closeShift(shiftData);
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    )
                  ],
                )))
          ])),
    );
  }
}
