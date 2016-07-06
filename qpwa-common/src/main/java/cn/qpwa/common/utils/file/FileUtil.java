package cn.qpwa.common.utils.file;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.CommonUtil;
import cn.qpwa.common.utils.IPUtil;
import org.apache.log4j.Logger;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

@SuppressWarnings("all")
public class FileUtil{

	private static Logger logger = Logger.getLogger(FileUtil.class);
	
	//orderByDate DESC
	public static File[] orderByDate(File[] fs) {
	    Arrays.sort(fs,new Comparator< File>(){
		       public int compare(File f1, File f2) {
		    	   long diff = f2.lastModified() - f1.lastModified();
			       if (diff > 0)
			    	   return 1;
			       else if (diff == 0)
			    	   return 0;
			       else
			    	   return -1;
		       }
	          public boolean equals(Object obj) {
	        	  return true;
	          }
	     });
	     return fs;
	  }
	//make up
	public static Page traverseFolder1(String path, Map<String,Object> param) {
		Page page = new Page();
		List<Map<String, Object>> downloadList = new ArrayList<Map<String, Object>>();
        try {
        	int fileNum = 0, folderNum = 0;
            File file = new File(path);
            if (file.exists()) {
                List<File> list = new ArrayList<File>();
                File[] files = file.listFiles();
                files = FileUtil.orderByDate(files);
                int rows =  Integer.parseInt(param.get("rows").toString());
                int pagee = Integer.parseInt(param.get("page").toString());
                int begin = rows * (pagee - 1) + 1 - 1;
                int end = rows * pagee - 1;
                for (int j=0; j<files.length; j++) {
                	if (files[j].isDirectory()) {
                		list.add(files[j]);
                		fileNum++;
                	} else {
                		if(begin <= j && j <= end) {
                			Map<String, Object> map = new HashMap<String, Object>();
                        	map.put("NAME", files[j].getName());
                        	map.put("SIZE", Math.round(files[j].length()/1000.00)+"KB");
                        	String ip = IPUtil.getLocalhostIp();
                        	String absolutePath = files[j].getAbsolutePath().replaceAll("\\\\", "/");
                        	logger.info("absolutePath--------->"+absolutePath);
                        	int start = absolutePath.indexOf("/ExcelExp");
//                        	String strPath = "http://"+IPUtil.getLocalhostIp()+":8080"+absolutePath.substring(start, files[j].getAbsolutePath().length());
                        	String mgtDomain = CommonUtil.loadProp("/config/config.properties").getProperty("qpwa.mgt.domain");
                        	String strPath = mgtDomain+absolutePath.substring(start, files[j].getAbsolutePath().length());
                        	map.put("ABSO_PATH", strPath);
                            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            Calendar date = Calendar.getInstance();
                            date.setTimeInMillis(files[j].lastModified());
                        	map.put("MODI_TIME", df.format(date.getTime()));
                        	map.put("STATUS", "T");
                        	downloadList.add(map);
                		}
                		folderNum++;
                	}
                }
                page.setTotal(folderNum);
                page.setItems(downloadList);
                
                return page;
            } else {
                logger.info("------------Error! File not exists!------------");
            }
		} catch (Exception e) {
			logger.info("------------Error! Sorry!------------");
			e.printStackTrace();
		}
        return null;

    }
	
	/**
	 * 复制文件
	 * @param s 源文件
	 * @param t 目标文件
	 * @author honghui
	 * @date   2016-04-26
	 */
	public static void fileCopy(File s,File t){
		try {
			int bytesum = 0;
			int byteread = 0;
			InputStream inStream = new FileInputStream(s); //读入原文件
			FileOutputStream fs = new FileOutputStream(t); //目标文件
			byte[] buffer = new byte[ 1444 ];
			int length;
			while ( ( byteread = inStream.read( buffer ) ) != -1 ){
				bytesum += byteread; //字节数 文件大小
			    fs.write( buffer, 0, byteread );
			}
			inStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}