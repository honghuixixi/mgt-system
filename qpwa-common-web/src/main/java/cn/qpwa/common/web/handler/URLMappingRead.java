package cn.qpwa.common.web.handler;

import java.util.List;

import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

@Component
public class URLMappingRead extends ConfigurationRead {

	public URLMappingRead() {
		super();
	}

	public URLMappingRead(List<Resource> pFile, String name) {
		read(pFile, name);
	}
}