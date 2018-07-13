package org.sgpro.signalmaster;

import org.hibernate.exception.ConstraintViolationException;

public class Result {
	private String code;
	private String message;
	private Object userId;
	private String isSession;
	private String isLimit;
	private String sessionId;
	private Object data;
	
	
	
	public String getIsLimit() {
		return isLimit;
	}
	public void setIsLimit(String isLimit) {
		this.isLimit = isLimit;
	}
	public String getIsSession() {
		return isSession;
	}
	public void setIsSession(String isSession) {
		this.isSession = isSession;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	public Object getUserId() {
		return userId;
	}
	public void setUserId(Object userId) {
		this.userId = userId;
	}
	
	
	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public Result(String code, String message) {
		super();
		this.code = code;
		this.message = message;
	}
	
	
	public Result() {
		// TODO Auto-generated constructor stub
	}
	
	public static Result success() {  
		return new Result("0", "OK");
	}
	
	public static Result unknowException(Throwable t) {
		if (ConstraintViolationException.class.isInstance(t)) {
			return new Result("80", "该对象已被其他对象引用，无法完成删除等操作，");
		} else if (LoginExprException.class.isInstance(t)) {
			return new Result("82", t.getMessage());
		}
		
		return new Result("99", t.getMessage());
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return GsonProvider.getGson().toJson(this);
	}
}
