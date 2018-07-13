package org.sgpro.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.sgpro.util.ReflectUtil.Invoker;

public interface SyncObserverModelMessageType {

	public String getName();
	public void setName(String name);
	
	public static abstract class AbsSyncObserverModelMessage implements SyncObserverModelMessageType {
		protected String name;

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}
		
		public AbsSyncObserverModelMessage(String name) {
			// TODO Auto-generated constructor stub
			setName(name);
		}
	}
	
	public static class SimpleMappingArgsMessage extends AbsSyncObserverModelMessage {

		private Map<String, Object> args;
		
		public SimpleMappingArgsMessage(String name) {
			// TODO Auto-generated constructor stub
			this(name, new HashMap<String, Object>());
		}
		
		private SimpleMappingArgsMessage(String name, Map<String, Object> args) {
			super(name);
			this.args = args;
		}

		public Map<String, Object> getArgs() {
			return args;
		}

		public boolean isEmpty() {
			return args.isEmpty();
		}

		public Set<String> keySet() {
			return args.keySet();
		}

		public Object put(String arg0, Object arg1) {
			return args.put(arg0, arg1);
		}

		public void putAll(Map<? extends String, ? extends Object> arg0) {
			args.putAll(arg0);
		}

		public Object remove(Object arg0) {
			return args.remove(arg0);
		}
		
	}
	
	public static class InvokerMessage extends AbsSyncObserverModelMessage {
		protected ReflectUtil.Invoker invoker;

		public ReflectUtil.Invoker getInvoker() {
			return invoker;
		}

		public void setInvoker(ReflectUtil.Invoker invoker) {
			this.invoker = invoker;
		}

		public InvokerMessage(String name, Invoker invoker) {
			super(name);
			this.invoker = invoker;
		}

		@Override
		public String getName() {
			// TODO Auto-generated method stub
			return invoker.toString();
		}

		@Override
		public void setName(String name) {
			// TODO Auto-generated method stub
			
		}
		
	}
	
	public static class VarArgsMessage extends AbsSyncObserverModelMessage {

		public VarArgsMessage(String name, Object...objects) {
			super(name);
			
			// TODO Auto-generated constructor stub
			setArgs(objects);
		}
		
		protected Object[] args;
		
		public void setArgs(Object... args) {
			this.args = args;
		}
		
		
		public Object[] getArgs() {
			return args;
		}
	}
}
