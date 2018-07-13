package org.sgpro.signalmaster;

public class HttpResult {

	private HttpResultData params;
	
	private status result;
	
	public enum status {
		SUCCESS("SUCCESS"),
		ERROR("ERROR");
		
		status(String s) {
			display = s;
		}
		
		@Override
		public String toString() {
			// TODO Auto-generated method stub
			return display;
		}
		
		private String display;
	}

	protected HttpResult(HttpResultData data, status result) {
		super();
		this.params = data;
		this.result = result;
	}

 

	public HttpResultData getParams() {
		return params;
	}



	public void setParams(HttpResultData params) {
		this.params = params;
	}


	public status getResult() {
		return result;
	}

	public static HttpResult aSuccess(HttpResultData hr) {
		return new HttpResult(hr, status.SUCCESS);
	}
	

	public static HttpResult aError(HttpResultData hr) {
		return new HttpResult(hr, status.ERROR);
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return GsonProvider.getGson().toJson(this);
	}
}
