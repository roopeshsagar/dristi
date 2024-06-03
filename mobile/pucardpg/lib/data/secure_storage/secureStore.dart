import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pucardpg/model/appconfig/mdmsResponse.dart';
import 'package:pucardpg/model/auth-response/auth_response.dart';
import 'package:pucardpg/model/response/responsemodel.dart';
import 'package:pucardpg/model/role_actions/role_actions_model.dart';
import 'package:pucardpg/model/serviceRegistry/serviceRegistryModel.dart';

import '../../model/localization/localizationModel.dart';

class SecureStore {
  final storage = const FlutterSecureStorage();
  SecureStore();

  Future setLocalizations(
      LocalizationModel localizationList, String locale) async {
    String jsonLocalizationList = json.encode(localizationList.toJson());
    await storage.write(key: locale, value: jsonLocalizationList);
  }

  Future<String?> getLocalizations(String locale) async {
    return await storage.read(key: locale);
  }

  //App configs
  Future setAppConfig(MdmsResponseModel mdmsResponseModel) async {
    String jsonMdmsResponse = json.encode(mdmsResponseModel.toJson());
    await storage.write(key: 'appConfig', value: jsonMdmsResponse);
  }

  Future<String?> getAppConfig() async {
    return await storage.read(key: 'appConfig');
  }

  //service Registry
  Future setServiceRegistry(ServiceRegistryModel serviceRegistryModel) async {
    String jsonServiceRegistryList = json.encode(serviceRegistryModel.toJson());
    await storage.write(key: 'serviceRegistry', value: jsonServiceRegistryList);
  }

  Future<String?> getServiceRegistry() async {
    return await storage.read(key: 'serviceRegistry');
  }

  //access token
  Future setAccessToken(String? accessToken) async {
    await storage.write(key: 'accessToken', value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future deleteAccessToken() async {
    await storage.delete(key: 'accessToken');
  }

  Future setRefreshToken(String? accessToken) async {
    await storage.write(key: 'refreshToken', value: accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  Future deleteRefreshToken() async {
    await storage.delete(key: 'refreshToken');
  }

  //other auth information
  Future setAccessInfo(AuthResponse accessInfo) async {
    String jsonAccessInfo = json.encode(accessInfo.toJson());
    await storage.write(key: 'accessInfo', value: jsonAccessInfo);
  }

  Future<AuthResponse?> getAccessInfo() async {
    String? jsonAccessInfo = await storage.read(key: 'accessInfo');
    if (jsonAccessInfo == null) return null;
    try {
      return AuthResponse.fromJson(json.decode(jsonAccessInfo));
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future deleteAccessInfo() async {
    await storage.delete(key: 'accessInfo');
  }

  Future setUserRequest(UserRequest userRequest) async {
    String jsonUserRequest = json.encode(userRequest.toJson());
    await storage.write(key: 'userRequest', value: jsonUserRequest);
  }

  Future<UserRequest?> getUserRequest() async {
    String? jsonUserRequest = await storage.read(key: 'userRequest');
    if (jsonUserRequest == null) return null;
    try {
      return UserRequest.fromJson(json.decode(jsonUserRequest));
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future deleteUserRequest() async {
    await storage.delete(key: 'userRequest');
  }

  //role actions
  Future setRoleActions(RoleActionsWrapperModel actionsWrapper) async {
    String jsonActionsWrapper = json.encode(actionsWrapper.toJson());
    await storage.write(key: 'actionsWrapper', value: jsonActionsWrapper);
  }

  Future<RoleActionsWrapperModel?> getRoleActions() async {
    String? jsonActionsWrapper = await storage.read(key: 'actionsWrapper');

    if (jsonActionsWrapper == null) return null;

    try {
      return RoleActionsWrapperModel.fromJson(json.decode(jsonActionsWrapper));
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  //Individual ID
  Future setSelectedIndividual(String? id) async {
    await storage.write(key: 'individualId', value: id);
  }

  Future<String?> getSelectedIndividual() async {
    final result = await storage.read(key: 'individualId');
    return result;
  }

  Future deleteSelectedIndividual() async {
    await storage.delete(key: 'individualId');
  }
}