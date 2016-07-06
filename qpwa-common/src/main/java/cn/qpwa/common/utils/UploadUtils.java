package cn.qpwa.common.utils;

import cn.qpwa.common.utils.ImgUtil.ImgFlg;
import cn.qpwa.common.utils.file.FileAttach;
import org.apache.commons.fileupload.util.Streams;
import org.apache.commons.lang.StringUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.UUID;

public class UploadUtils {
	public String upload(FileAttach fileAttach,String imgFlg,HttpServletRequest request) {
		ServletContext servletContext = request.getSession()
				.getServletContext();
		String rootPath = servletContext.getRealPath("/");
		//lj修改，主要兼容jetty
		if(!rootPath.endsWith("\\")){
			rootPath = rootPath + File.separator;
		}	
		String pathDir = rootPath + "uploadImage"+File.separator;
		try {
			if (StringUtils.isNotBlank(imgFlg)) {
				pathDir = pathDir  + imgFlg;
			} 
			
			File filePath = new File(pathDir);

			if  (!filePath .exists()  && !filePath .isDirectory()){
				filePath.mkdirs();
			}
			
				// 获取文件名
				String fileName = fileAttach.getFileName();
				if (StringUtils.isBlank(fileName)) {
					return null;
				}
				// 获取图片的扩展名
				String extensionName = fileName.substring(fileName.lastIndexOf(".") + 1);
				// 新的图片文件名
				String newFileName = UUID.randomUUID() + "." + extensionName;
				pathDir+= (File.separator+newFileName);
				File imgFile = new File(pathDir);
				imgFile.createNewFile();
				// 完整文件名
				 OutputStream out = new  FileOutputStream(imgFile);
				 Streams.copy(fileAttach.getInputStream(), out, true);
				 String fullPath = pathDir.replace("\\", "/");
				 ImgUtil.handlerImage(fullPath, ImgFlg.PROMOTION_B2B.toString());
				 return newFileName;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
public static void main(String[] args) {
	try {
		new File("D://aaa//sdsd//sdsd"+File.separator+UUID.randomUUID() + ".jpg" ).createNewFile();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
//	System.out.println(new File("D://aaa//sdsd//sdsd"+File.separator+UUID.randomUUID() + ".jpg" ).createNewFile());
}
}
