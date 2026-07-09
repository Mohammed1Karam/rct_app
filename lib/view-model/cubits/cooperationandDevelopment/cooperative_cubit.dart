import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/cooperationandDevelopment/coopeativestates.dart';
import 'package:rct/model/cooperativeMdel.dart';
import 'package:rct/view-model/services/crud.dart';

class CooperativeCubit extends Cubit<Coopeativestates> {
  CooperativeCubit() : super(InitialCooperativeStates());
  final Crud _crud = Crud();
  Future<void> RawLandFunction(BuildContext context) async {
    CooperativeModel cooperativemdel =
        Provider.of<CooperativeModel>(context, listen: false);
    emit(RawLandLoadingStates());
    Map<String, File?> images = {
      'identity': cooperativemdel.identity,
      'electronic_instrument': cooperativemdel.electronic_instrument,
    };
    print("+++++++++++++++++++++++++++++++++++++++++++");
    print(cooperativemdel.birthDate);
    print(cooperativemdel.nationalIdNumber);

    try {
      var result = await _crud.postRequestWithFiles(
        "$linkServerName/api/rawlands",
        {
          "city_name": cooperativemdel.city_name,
          "district_name": cooperativemdel.district_name,
          "price": cooperativemdel.price,
          "build_id": cooperativemdel.type_id,
          "location": cooperativemdel.location,
          "lat": cooperativemdel.lat,
          "lng": cooperativemdel.long,
          "status": cooperativemdel.status,
          "agreement": cooperativemdel.agreement,
          "client_birth": cooperativemdel.birthDate,
          "identity_number": cooperativemdel.nationalIdNumber,
        },
        images,
        headers: {
          "Content-Type": "application/json",
          "Accept-Language": CacheHelper.getData(key: "lang"),
        },
      );

      if (result.containsKey("data")) {
        print(result);
        emit(RawLandSuccessStates());
      } else {
        print(result);
        emit(RawLandSuccessStates());
        // emit(RawLandFailedStates(result.entries.toString()));
      }
    } catch (e) {
      print(e);

      emit(RawLandFailedStates("$e"));
    }
  }

// Old buildings function

  Future<void> OldBuildingsFunction(BuildContext context) async {
    CooperativeModel cooperativemdel =
        Provider.of<CooperativeModel>(context, listen: false);
    emit(OldBildingsLoadingStates());
    Map<String, File?> images = {
      'identity': cooperativemdel.identity,
      'electronic_instrument': cooperativemdel.electronic_instrument,
    };

    try {
      var result = await _crud.postRequestWithFiles(
        "$linkServerName/api/oldbuildings",
        {
          "city_name": cooperativemdel.city_name,
          "district_name": cooperativemdel.district_name,
          "price": cooperativemdel.price,
          "build_id": cooperativemdel.type_id,
          "location": cooperativemdel.location,
          "lat": cooperativemdel.lat,
          "lng": cooperativemdel.long,
          "status": cooperativemdel.status,
          "agreement": cooperativemdel.agreement,
        },
        images,
        headers: {
          "Content-Type": "application/json",
          "Accept-Language": CacheHelper.getData(key: "lang"),
        },
      );

      if (result.containsKey("data")) {
        print(result);
        emit(OldBildingSuccessStates());
      } else {
        print(result);

        emit(OldBildingSuccessStates());

        // emit(OldBildingFailedStates(result.entries.toString()));
      }
    } catch (e) {
      print(e);

      emit(OldBildingFailedStates("$e"));
    }
  }

//plans function

  Future<void> PlansFunction(BuildContext context) async {
    CooperativeModel cooperativeModel =
        Provider.of<CooperativeModel>(context, listen: false);
    emit(PlansLoadingStates());
    Map<String, File?> images = {
      'identity': cooperativeModel.identity,
      'electronic_instrument': cooperativeModel.electronic_instrument,
      'schema': cooperativeModel.schema,
    };

    try {
      var result = await _crud.postRequestWithFiles(
        "$linkServerName/api/formschemas",
        {
          "city_name": cooperativeModel.city_name,
          "district_name": cooperativeModel.district_name,
          "price": cooperativeModel.price,
          "build_id": cooperativeModel.type_id,
          "location": cooperativeModel.location,
          "lat": cooperativeModel.lat,
          "lng": cooperativeModel.long,
          "status": cooperativeModel.status,
          "agreement": cooperativeModel.agreement,
        },
        images,
        headers: {},
      );

      if (result.containsKey("data")) {
        print(result);
        emit(PlansSuccessStates());
      } else {
        print(result);
        emit(PlansSuccessStates());
        // emit(PlansFailedStates(result.entries.toString()));
      }
    } catch (e) {
      print(e);

      emit(PlansFailedStates("$e"));
    }
  }
}
