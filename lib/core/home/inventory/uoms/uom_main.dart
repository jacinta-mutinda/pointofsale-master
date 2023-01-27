import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/uoms/uom_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/utils/functions.dart';

class UoMsPage extends StatefulWidget {
  static const routeName = "/uoms";
  const UoMsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UoMsPageState createState() => _UoMsPageState();
}

class _UoMsPageState extends State<UoMsPage> {
  final invtCtrl = Get.put(InventoryCtrl());
  final ScrollController _scrollctrl = ScrollController();
  TextEditingController searchCtrl = TextEditingController();
  final GlobalKey<FormState> _searchForm = GlobalKey<FormState>();
  bool _showBackToTopBtn = false;
  bool _isAddLoading = false;

  @override
  void initState() {
    super.initState();
    invtCtrl.getUoMs();
    _scrollctrl.addListener(() {
      if (_scrollctrl.position.pixels == _scrollctrl.position.maxScrollExtent) {
        listAppender(
            rangeList: invtCtrl.rangeUomList, selectList: invtCtrl.uoms);
      }
      setState(() {
        if (_scrollctrl.offset >= 400) {
          _showBackToTopBtn = true;
        } else {
          _showBackToTopBtn = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollctrl.dispose();
  }

  void _scrollToTop() {
    _scrollctrl.animateTo(0,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(
            pageTitle: 'Units of Measurement (UoM)', actions: <Widget>[]),
        body: SingleChildScrollView(
            controller: _scrollctrl,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
                child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All UoMs',
                          style: kTitle,
                        ),
                        smallPriBtn(
                            label: 'Add UoM',
                            txtColour: Colors.white,
                            bgColour: kDarkGreen,
                            isLoading: _isAddLoading,
                            function: () {
                              invtCtrl.isUoMEdit.value = false;
                              invtCtrl.fieldsUoMRequired.value = true;
                              Get.to(const UomForm());
                            }),
                      ])),
              Obx(() => invtCtrl.showUoMLoading.value
                  ? loadingWidget(label: 'Loading Units of Measurement ...')
                  : invtCtrl.showUoMData.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Form(
                                            key: _searchForm,
                                            child: searchForm(
                                                label: 'Search by uom name',
                                                controller: searchCtrl,
                                                suffix: true,
                                                inputType: TextInputType.text,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter search name';
                                                  }
                                                  return null;
                                                },
                                                searchFunction: () {
                                                  if (_searchForm.currentState!
                                                      .validate()) {
                                                    invtCtrl.searchUomFilter(
                                                        searchCtrl.text);
                                                  }
                                                })),
                                        GestureDetector(
                                            onTap: () {
                                              invtCtrl.getUoMs();
                                              searchCtrl.clear();
                                            },
                                            child: const Icon(
                                              Icons.refresh,
                                              color: kDarkGreen,
                                              size: 25,
                                            ))
                                      ])),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, right: 5),
                                        child: Obx(() => RichText(
                                                text: TextSpan(children: [
                                              const TextSpan(
                                                text: 'Showing ',
                                                style: kBlackTxt,
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${invtCtrl.rangeUomList.length} ',
                                                style: kNeonTxt,
                                              ),
                                              const TextSpan(
                                                text: ' of ',
                                                style: kBlackTxt,
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${invtCtrl.uoms.length} ',
                                                style: kDarkGreenTxt,
                                              ),
                                              const TextSpan(
                                                text: ' UoMs',
                                                style: kBlackTxt,
                                              )
                                            ]))))
                                  ]),
                              Obx(
                                () => ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var uoms = invtCtrl.rangeUomList;
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Card(
                                              color: kGrey,
                                              elevation: 7.0,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: kLightGreen),
                                                    child: const Icon(
                                                        Icons.person,
                                                        size: 20,
                                                        color: Colors.white)),
                                                title: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Text(
                                                        uoms[index].name,
                                                        style: kCardTitle)),
                                                subtitle: Text(
                                                    uoms[index].uomCode,
                                                    style: kCardTitle),
                                                trailing: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: kDarkGreen),
                                                    child: const Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
                                                        size: 25,
                                                        color: Colors.white)),
                                                onTap: () async {
                                                  invtCtrl.isUoMEdit.value =
                                                      true;
                                                  invtCtrl.fieldsUoMRequired
                                                      .value = false;
                                                  invtCtrl.uoMToEdit.value =
                                                      uoms[index].id;
                                                  Get.to(() => const UomForm());
                                                },
                                              )));
                                    },
                                    itemCount: invtCtrl.rangeUomList.length),
                              ),
                            ])
                      : noItemsWidget(label: 'No Units of Measurement Found'))
            ]))),
        floatingActionButton: _showBackToTopBtn
            ? FloatingActionButton(
                elevation: 2.0,
                backgroundColor: kDarkGreen,
                onPressed: _scrollToTop,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              )
            : Container());
  }
}
