package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblCustomizedConfigForIndustry generated by hbm2java
 */
public class TblCustomizedConfigForIndustry implements java.io.Serializable {

	private TblCustomizedConfigForIndustryId id;
	private EntIndustry entIndustry;
	private EntConfig entConfig;
	private String value;
	private String description;

	public TblCustomizedConfigForIndustry() {
	}

	public TblCustomizedConfigForIndustry(TblCustomizedConfigForIndustryId id,
			EntIndustry entIndustry, EntConfig entConfig, String value,
			String description) {
		this.id = id;
		this.entIndustry = entIndustry;
		this.entConfig = entConfig;
		this.value = value;
		this.description = description;
	}

	public TblCustomizedConfigForIndustryId getId() {
		return this.id;
	}

	public void setId(TblCustomizedConfigForIndustryId id) {
		this.id = id;
	}

	public EntIndustry getEntIndustry() {
		return this.entIndustry;
	}

	public void setEntIndustry(EntIndustry entIndustry) {
		this.entIndustry = entIndustry;
	}

	public EntConfig getEntConfig() {
		return this.entConfig;
	}

	public void setEntConfig(EntConfig entConfig) {
		this.entConfig = entConfig;
	}

	public String getValue() {
		return this.value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}