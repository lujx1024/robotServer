package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.HashSet;
import java.util.Set;

/**
 * TblThirdPartyApiParams generated by hbm2java
 */
public class TblThirdPartyApiParams implements java.io.Serializable {

	private TblThirdPartyApiParamsId id;
	private EntThirdPartyApi entThirdPartyApi;
	private boolean header0Body1;
	private boolean optional;
	private String defaultValue;
	private Set tblThirdPartyApiParamsValues = new HashSet(0);

	public TblThirdPartyApiParams() {
	}

	public TblThirdPartyApiParams(TblThirdPartyApiParamsId id,
			EntThirdPartyApi entThirdPartyApi, boolean header0Body1,
			boolean optional) {
		this.id = id;
		this.entThirdPartyApi = entThirdPartyApi;
		this.header0Body1 = header0Body1;
		this.optional = optional;
	}

	public TblThirdPartyApiParams(TblThirdPartyApiParamsId id,
			EntThirdPartyApi entThirdPartyApi, boolean header0Body1,
			boolean optional, String defaultValue,
			Set tblThirdPartyApiParamsValues) {
		this.id = id;
		this.entThirdPartyApi = entThirdPartyApi;
		this.header0Body1 = header0Body1;
		this.optional = optional;
		this.defaultValue = defaultValue;
		this.tblThirdPartyApiParamsValues = tblThirdPartyApiParamsValues;
	}

	public TblThirdPartyApiParamsId getId() {
		return this.id;
	}

	public void setId(TblThirdPartyApiParamsId id) {
		this.id = id;
	}

	public EntThirdPartyApi getEntThirdPartyApi() {
		return this.entThirdPartyApi;
	}

	public void setEntThirdPartyApi(EntThirdPartyApi entThirdPartyApi) {
		this.entThirdPartyApi = entThirdPartyApi;
	}

	public boolean isHeader0Body1() {
		return this.header0Body1;
	}

	public void setHeader0Body1(boolean header0Body1) {
		this.header0Body1 = header0Body1;
	}

	public boolean isOptional() {
		return this.optional;
	}

	public void setOptional(boolean optional) {
		this.optional = optional;
	}

	public String getDefaultValue() {
		return this.defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public Set getTblThirdPartyApiParamsValues() {
		return this.tblThirdPartyApiParamsValues;
	}

	public void setTblThirdPartyApiParamsValues(Set tblThirdPartyApiParamsValues) {
		this.tblThirdPartyApiParamsValues = tblThirdPartyApiParamsValues;
	}

}