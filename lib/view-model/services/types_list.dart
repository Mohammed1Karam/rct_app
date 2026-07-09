import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

class TypesList {
  Crud _crud = Crud();
  Future<List> get() async {
    var data = await _crud.getRequest(linkTypes);
    print(data["data"]);
    return data["data"];
    
  }
}
