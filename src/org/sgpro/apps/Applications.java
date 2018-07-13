package org.sgpro.apps;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import org.sgpro.signalmaster.AutoTalk;
import org.sgpro.signalmaster.Join;
import org.sgpro.signalmaster.Leave;
import org.sgpro.signalmaster.Message;

@ApplicationPath("/services")
public class Applications extends Application {
	@Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();
        // classes.add(JacksonJsonProvider.class);
        classes.add(Join.class);
        classes.add(Leave.class);
        classes.add(Message.class);
        classes.add(AutoTalk.class);
        return classes;
    }
}
