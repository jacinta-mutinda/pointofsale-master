import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nawiri/utils/urls.dart';


Future<List> getShiftsalesReports() async {
  final uri = Uri.parse(getShiftSaleReportUrl);

  var branchId = '097b6779-fb9b-4c0e-ad6d-5924ac19c3e0';

  var body = jsonEncode({
 'branch_id':branchId,
  });
  

  http.Response response = await http.post(
    uri,
    body: body,
  );

  return json.decode(response.body);
  
}

