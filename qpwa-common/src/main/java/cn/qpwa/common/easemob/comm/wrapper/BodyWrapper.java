package cn.qpwa.common.easemob.comm.wrapper;

import com.fasterxml.jackson.databind.node.ContainerNode;

/**
 * @author honghui
 * @date   2016年4月29日
 */
public interface BodyWrapper {

	ContainerNode<?> getBody();
	Boolean validate();
	
}
