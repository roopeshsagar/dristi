package org.pucar.util;

import static org.pucar.config.ServiceConstants.IDGEN_ERROR;
import static org.pucar.config.ServiceConstants.NO_IDS_FOUND_ERROR;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.egov.common.contract.idgen.IdGenerationRequest;
import org.egov.common.contract.idgen.IdGenerationResponse;
import org.egov.common.contract.idgen.IdRequest;
import org.egov.common.contract.idgen.IdResponse;
import org.egov.common.contract.request.RequestInfo;
import org.egov.tracer.model.CustomException;
import org.pucar.config.Configuration;
import org.pucar.repository.ServiceRequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class IdgenUtil {

	@Autowired
	private ObjectMapper mapper;

	@Autowired
	private ServiceRequestRepository restRepo;

	@Autowired
	private Configuration configs;

	public List<String> getIdList(RequestInfo requestInfo, String tenantId, String idName, String idformat,
			Integer count) {
		List<IdRequest> reqList = new ArrayList<>();
		for (int i = 0; i < count; i++) {
			reqList.add(IdRequest.builder().idName(idName).format(idformat).tenantId(tenantId).build());
		}

		IdGenerationRequest request = IdGenerationRequest.builder().idRequests(reqList).requestInfo(requestInfo)
				.build();
		StringBuilder uri = new StringBuilder(configs.getIdGenHost()).append(configs.getIdGenPath());
		IdGenerationResponse response = mapper.convertValue(restRepo.fetchResult(uri, request),
				IdGenerationResponse.class);

		List<IdResponse> idResponses = response.getIdResponses();

		if (CollectionUtils.isEmpty(idResponses))
			throw new CustomException(IDGEN_ERROR, NO_IDS_FOUND_ERROR);

		return idResponses.stream().map(IdResponse::getId).collect(Collectors.toList());
	}
}