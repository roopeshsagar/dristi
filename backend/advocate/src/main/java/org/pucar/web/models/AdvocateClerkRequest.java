package org.pucar.web.models;

import java.util.ArrayList;
import java.util.List;

import org.egov.common.contract.request.RequestInfo;
import org.springframework.validation.annotation.Validated;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * AdvocateClerkRequest
 */
@Validated
@jakarta.annotation.Generated(value = "org.egov.codegen.SpringBootCodegen", date = "2024-03-31T21:18:00.002622+05:30[Asia/Kolkata]")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AdvocateClerkRequest {
	@JsonProperty("requestInfo")

	@Valid
	private RequestInfo requestInfo = null;

	@JsonProperty("cases")
	@Valid
	private List<AdvocateClerk> cases = null;

	public AdvocateClerkRequest addCasesItem(AdvocateClerk casesItem) {
		if (this.cases == null) {
			this.cases = new ArrayList<>();
		}
		this.cases.add(casesItem);
		return this;
	}

}
