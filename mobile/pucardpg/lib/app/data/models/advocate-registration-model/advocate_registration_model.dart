import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pucardpg/app/data/models/advocate-request-info/advocate_request_info.dart';
import 'package:pucardpg/app/data/models/document-model/document_model.dart';
import 'package:pucardpg/app/data/models/individual-search/individual_search_model.dart';
import 'package:pucardpg/app/data/models/workflow-model/workflow_model.dart';

part 'advocate_registration_model.freezed.dart';
part 'advocate_registration_model.g.dart';

@freezed
class Advocate with _$Advocate {
  const factory Advocate({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: 'tenantId') String? tenantId,
    @JsonKey(name: 'applicationNumber') String? applicationNumber,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'barRegistrationNumber') String? barRegistrationNumber,
    @JsonKey(name: 'advocateType') String? advocateType,
    @JsonKey(name: 'organisationID') String? organisationID,
    @JsonKey(name: 'individualId') String? individualId,
    @JsonKey(name: 'isActive') bool? isActive,
    @JsonKey(name: 'workflow') Workflow? workflow,
    @JsonKey(name: 'documents') List<Document>? documents,
    @JsonKey(name: 'additionalDetails') Map<String, dynamic>? additionalDetails,
  }) = _Advocate;

  factory Advocate.fromJson(Map<String, dynamic> json) =>
      _$AdvocateFromJson(json);
}

@freezed
class AdvocateRegistrationRequest with _$AdvocateRegistrationRequest {
  const factory AdvocateRegistrationRequest({
    @JsonKey(name: 'RequestInfo') required AdvocateRequestInfo requestInfo,
    @JsonKey(name: 'advocates') required List<Advocate> advocates
  }) = _AdvocateRegistrationRequest;

  factory AdvocateRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$AdvocateRegistrationRequestFromJson(json);
}

@freezed
class AdvocateRegistrationResponse with _$AdvocateRegistrationResponse {
  const factory AdvocateRegistrationResponse({
    @JsonKey(name: 'responseInfo') @Default(ResponseInfoSearch(status: "")) ResponseInfoSearch responseInfo,
    @JsonKey(name: 'advocates') required List<Advocate> advocates,
  }) = _AdvocateRegistrationResponse;

  factory AdvocateRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$AdvocateRegistrationResponseFromJson(json);
}