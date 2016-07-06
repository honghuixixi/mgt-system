package cn.qpwa.common.utils.file;

import cn.qpwa.common.utils.setting.Setting;
import cn.qpwa.common.utils.setting.SettingUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.ServletContextAware;

import javax.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


/**
 * Plugin - 本地文件存储
 * 
 * @author zhaowei
 * @version 1.0
 */
//@Component("filePlugin")
public class FilePlugin implements ServletContextAware {

	/** servletContext */
	private ServletContext servletContext;

	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}

	
	public String getName() {
		return "本地文件存储";
	}

	
	public String getVersion() {
		return "1.0";
	}

	
	public String getAuthor() {
		return "QPWA";
	}

	
	public String getSiteUrl() {
		return "http://www.qpwa.com";
	}

	
	public String getInstallUrl() {
		return null;
	}

	
	public String getUninstallUrl() {
		return null;
	}

	
	public String getSettingUrl() {
		return "file/setting.jhtml";
	}

	
	public void upload(String path, File file, String contentType) {
		Setting setting = SettingUtils.get();
		String savePath = setting.getImgSave();
		if(StringUtils.isEmpty(savePath))
		{
			savePath = servletContext.getRealPath(path);
		}
		else
		{
			savePath = savePath+path;
		}
		File destFile = new File(savePath);
		try {
			FileUtils.moveFile(file, destFile);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	
	public String getUrl(String path) {
		Setting setting = SettingUtils.get();
		if(StringUtils.isEmpty(setting.getSiteUrl()))
		{
//			return servletContext.getContextPath()+path;
		}
		return setting.getSiteUrl() + path;
	}

	
	public List<FileInfo> browser(String path) {
		Setting setting = SettingUtils.get();
		List<FileInfo> fileInfos = new ArrayList<FileInfo>();
		File directory = new File(servletContext.getRealPath(path));
		if (directory.exists() && directory.isDirectory()) {
			for (File file : directory.listFiles()) {
				FileInfo fileInfo = new FileInfo();
				fileInfo.setName(file.getName());
				fileInfo.setUrl(setting.getSiteUrl() + path + file.getName());
				fileInfo.setIsDirectory(file.isDirectory());
				fileInfo.setSize(file.length());
				fileInfo.setLastModified(new Date(file.lastModified()));
				fileInfos.add(fileInfo);
			}
		}
		return fileInfos;
	}

}