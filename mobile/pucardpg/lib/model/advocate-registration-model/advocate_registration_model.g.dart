// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advocate_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponseListImpl _$$ResponseListImplFromJson(Map<String, dynamic> json) =>
    _$ResponseListImpl(
      id: json['id'] as String?,
      tenantId: json['tenantId'] as String?,
      applicationNumber: json['applicationNumber'] as String?,
      status: json['status'] as String?,
      barRegistrationNumber: json['barRegistrationNumber'] as String?,
      advocateType: json['advocateType'] as String?,
      organisationID: json['organisationID'] as String?,
      individualId: json['individualId'] as String?,
      isActive: json['isActive'] as bool?,
      workflow: json['workflow'] == null
          ? null
          : Workflow.fromJson(json['workflow'] as Map<String, dynamic>),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalDetails: json['additionalDetails'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ResponseListImplToJson(_$ResponseListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'applicationNumber': instance.applicationNumber,
      'status': instance.status,
      'barRegistrationNumber': instance.barRegistrationNumber,
      'advocateType': instance.advocateType,
      'organisationID': instance.organisationID,
      'individualId': instance.individualId,
      'isActive': instance.isActive,
      'workflow': instance.workflow,
      'documents': instance.documents,
      'additionalDetails': instance.additionalDetails,
    };

_$AdvocateImpl _$$AdvocateImplFromJson(Map<String, dynamic> json) =>
    _$AdvocateImpl(
      id: json['id'] as String?,
      barRegistrationNumber: json['barRegistrationNumber'] as String?,
      applicationNumber: json['applicationNumber'] as String?,
      individualId: json['individualId'] as String?,
      responseList: (json['responseList'] as List<dynamic>)
          .map((e) => ResponseList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdvocateImplToJson(_$AdvocateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barRegistrationNumber': instance.barRegistrationNumber,
      'applicationNumber': instance.applicationNumber,
      'individualId': instance.individualId,
      'responseList': instance.responseList,
    };

_$AdvocateRegistrationRequestImpl _$$AdvocateRegistrationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AdvocateRegistrationRequestImpl(
      advocate: ResponseList.fromJson(json['advocate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AdvocateRegistrationRequestImplToJson(
        _$AdvocateRegistrationRequestImpl instance) =>
    <String, dynamic>{
      'advocate': instance.advocate,
    };

_$AdvocateRegistrationResponseImpl _$$AdvocateRegistrationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AdvocateRegistrationResponseImpl(
      responseInfo: json['responseInfo'] == null
          ? const ResponseInfoSearch(status: "")
          : ResponseInfoSearch.fromJson(
              json['responseInfo'] as Map<String, dynamic>),
      advocates: (json['advocates'] as List<dynamic>)
          .map((e) => ResponseList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdvocateRegistrationResponseImplToJson(
        _$AdvocateRegistrationResponseImpl instance) =>
    <String, dynamic>{
      'responseInfo': instance.responseInfo,
      'advocates': instance.advocates,
    };