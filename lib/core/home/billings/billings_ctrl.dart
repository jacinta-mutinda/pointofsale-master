import 'package:get/get.dart';
import 'package:nawiri/core/home/billings/single_bill.dart';
import 'package:nawiri/core/home/home_models.dart';

class BillingsCtrl extends GetxController {
  RxInt singleBillId = 1.obs;
  Billing singleBill = Billing(id: 1, name: '', date: '', paid: false);
  RxList<Billing> billings = RxList<Billing>();

  @override
  void onInit() {
    super.onInit();
    getUserBills();
  }

  // ---------- Get Functions -----------------

  getUserBills() {
    billings.clear();
    billings.value = [
      Billing(id: 1, name: '01', date: '17/01/23', paid: false),
      Billing(id: 2, name: '02', date: '12/12/22', paid: true),
      Billing(id: 3, name: '03', date: '12/11/22', paid: true),
    ];
  }

  getSingleBill() {
    singleBill =
        billings.where((element) => element.id == (singleBillId.value)).first;
    Get.dialog(const SingleUserBill());
  }
}
