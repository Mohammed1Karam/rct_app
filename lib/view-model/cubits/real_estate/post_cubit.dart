import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/realEstatemodel.dart';
import 'package:rct/view-model/cubits/real_estate/post_states.dart';

import 'package:rct/view-model/services/crud.dart';

class HouseCubit extends Cubit<HouseStates> {
  HouseCubit() : super(HouseInitiall());
  final Crud _crud = Crud();
  Future<void> pushOrder(BuildContext context) async {
    HouseModel houseModel = Provider.of<HouseModel>(context, listen: false);
    emit(HouseLoadingg());
    Map<String, File?> images = {
      'identity': houseModel.identity,
      'electronic_instrument': houseModel.electronic_instrument,
      'image1': houseModel.image1,
      'image2': houseModel.image2,
      'image3': houseModel.image3,
      'image4': houseModel.image4,
    };

    try {
      var result = await _crud.postRequestWithFiles(
        linkHouses,
        {
          "house_type": houseModel.house_type,
          "house_name": houseModel.house_type,
          "house_space": houseModel.house_space,
          "city_name": houseModel.city_name,
          "description": houseModel.description,
          "district_name": houseModel.district_name,
          "price": houseModel.price,
          "build_id": houseModel.type_id,
          "location": houseModel.location,
          "lat": houseModel.lat,
          "lng": houseModel.long,
          "status": houseModel.status,
          "agreement": houseModel.agreement,
          "number": houseModel.number,
          "cost": 100,
          "client_phone": houseModel.phone,
        },
        images,
        headers: {},
      );

      if (result.containsKey("data")) {
        print(result);
        emit(HouseSuccesss());
      } else {
        print(result);
        emit(HouseSuccesss());

        // emit(HouseFaild(errMessage: result.entries.toString()));
      }
    } catch (e) {
      print(e);

      emit(HouseFaild(errMessage: "$e"));
    }
  }
}
