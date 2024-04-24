import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pucardpg/app/data/models/advocate-clerk-registration-model/advocate_clerk_registration_model.dart';
import 'package:pucardpg/app/data/models/advocate-registration-model/advocate_registration_model.dart';
import 'package:pucardpg/app/data/models/advocate-request-info/advocate_request_info.dart';
import 'package:pucardpg/app/data/models/advocate-search/advocate_search_model.dart';
import 'package:pucardpg/app/data/models/individual-search/individual_search_model.dart';

part 'advocate_clerk_search_model.freezed.dart';
part 'advocate_clerk_search_model.g.dart';

@freezed
class AdvocateClerkSearchRequest with _$AdvocateClerkSearchRequest {
  const factory AdvocateClerkSearchRequest({
    @JsonKey(name: "criteria") @Default([]) List<SearchCriteria> criteria,
    @JsonKey(name: 'status') @Default([]) List<String> status,
    @JsonKey(name: 'tenantId') String? tenantId,
    @JsonKey(name: 'RequestInfo') required AdvocateRequestInfo requestInfo,
  }) = _AdvocateClerkSearchRequest;

  factory AdvocateClerkSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$AdvocateClerkSearchRequestFromJson(json);
}

@freezed
class AdvocateClerkSearchResponse with _$AdvocateClerkSearchResponse {
  const factory AdvocateClerkSearchResponse ({
    @JsonKey(name: 'responseInfo') @Default(ResponseInfoSearch(status: "")) ResponseInfoSearch responseInfo,
    @JsonKey(name: 'clerks') @Default([]) List<Clerk> clerks,
  }) = _AdvocateClerkSearchResponse;

  factory AdvocateClerkSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$AdvocateClerkSearchResponseFromJson(json);
}