package org.sgpro.util;

public class SyncObserverInvoker extends SyncObserverModel<SyncObserverModelMessageType.SimpleMappingArgsMessage> {

	protected void handler(org.sgpro.util.SyncObserverModelMessageType.InvokerMessage m) {
		
		try {
			if (m != null) {
				m.invoker.invok();
			}
		} catch (Throwable t) {
			throw new RuntimeException(t);
		}
	}
}
