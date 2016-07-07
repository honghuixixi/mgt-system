package cn.qpwa.common.web.handler;

import java.util.List;

import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

@Component
public class AuthorityMappingRead extends ConfigurationRead {
	public AuthorityMappingRead() {
		super();
	}

	public AuthorityMappingRead(List<Resource> pFile, String name) {
		super.read(pFile, name);
	}
}