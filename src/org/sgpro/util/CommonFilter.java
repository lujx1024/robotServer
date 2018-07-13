package org.sgpro.util;

import java.io.Serializable;

public interface CommonFilter<TargetType> extends Serializable {

	public boolean accept(TargetType target);
}
