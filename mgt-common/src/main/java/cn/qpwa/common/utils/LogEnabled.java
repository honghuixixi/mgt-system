package cn.qpwa.common.utils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 统一日志接口
 *
 */
public abstract interface LogEnabled {
	public static final Log log = LogFactory.getLog(LogEnabled.class);
}