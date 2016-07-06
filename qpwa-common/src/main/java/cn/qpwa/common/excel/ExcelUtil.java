package cn.qpwa.common.excel;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.*;
import org.apache.log4j.Logger;

import java.awt.*;
import java.io.File;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
public class ExcelUtil {
	    private static Logger log=Logger.getLogger(ExcelUtil.class);  
	    private String properties;  
	    private String[] cols;  
	    public String[] getCols() {  
	        return cols;  
	    }  
	    public void setCols(String[] cols) {  
	        this.cols = cols;  
	    }  
	    public void setProperties(String properties) {  
	        cols = properties.split(",");  
	        this.properties = properties;  
	    }  
	    public boolean exportExcel(String fileName, String[] title, List<Map<String, Object>> dataList, String filePath)  
	            throws Exception {  
	        try {  
	        	File dir = new File(filePath);
	        	if(!dir.isDirectory()) {
	        		dir.mkdirs();
	        	}
	        	File file = new File(filePath + File.separator + fileName);
	            //create Excel
	            WritableWorkbook wwb = Workbook.createWorkbook(file); 
	            WritableSheet sheet = wwb.createSheet(fileName, 0);  
	            Label label;  
	            Field f;  
	            WritableFont wfcNav = new WritableFont(WritableFont.ARIAL, 15, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK);
	            WritableCellFormat wcfN = new WritableCellFormat(wfcNav);
	            Color color = Color.decode("#C0C0C0");
	            wwb.setColourRGB(Colour.ORANGE, color.getRed(), color.getGreen(), color.getBlue());
	            wcfN.setBackground(Colour.ORANGE);
	            wcfN.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, Colour.BLACK);
	            wcfN.setAlignment(Alignment.CENTRE);
	            wcfN.setWrap(false);
	            if (title != null) {
	                for (int i = 0; i < title.length; i++) {
	                    label = new Label(i, 0, title[i], wcfN);
	                    sheet.setColumnView(i, 30);
	                    sheet.addCell(label);
	                }
	            }
	            if (dataList != null && dataList.size() > 0) {
	                for (int i = 0; i < dataList.size(); i++) {
	                    for (int j = 0; j < cols.length; j++) {
	                    	String value = dataList.get(i).get(cols[j])+"";
	                        if (!value.equals("") && value!=null) {
	                            label = new Label(j, i + 1, value);
	                        } else {
	                            label = new Label(j, i + 1, "");
	                        }
	                        sheet.addCell(label);
	                    }
	                }
	            }
	            wwb.write();
	            wwb.close();
	            return true;
	        } catch (Exception e) {
	            log.debug("------------Error! Sorry!------------");
	            e.printStackTrace();
	            return false;
	        }
	    }

	    public void exportExcel(String fileName, String[] title, List<Map<String, Object>> dataList,OutputStream out)
	            throws Exception {
	        try {
	            WritableWorkbook wwb = Workbook.createWorkbook(out);
	            WritableSheet sheet = wwb.createSheet(fileName, 0);
	            Label label;
	            Field f;
	            WritableFont wfcNav = new WritableFont(WritableFont.ARIAL, 15, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.BLACK);
	            WritableCellFormat wcfN = new WritableCellFormat(wfcNav);
	            Color color = Color.decode("#C0C0C0");
	            wwb.setColourRGB(Colour.ORANGE, color.getRed(), color.getGreen(), color.getBlue());
	            wcfN.setBackground(Colour.ORANGE);
	            wcfN.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, Colour.BLACK);
	            wcfN.setAlignment(Alignment.CENTRE);
	            wcfN.setWrap(false);
	            if (title != null) {  
	                for (int i = 0; i < title.length; i++) {  
	                    label = new Label(i, 0, title[i], wcfN);
	                    sheet.setColumnView(i, 30); 
	                    sheet.addCell(label);  
	                }  
	            }  
	            if (dataList != null && dataList.size() > 0) {  
	                for (int i = 0; i < dataList.size(); i++) {  
	                    for (int j = 0; j < cols.length; j++) {  
	                    	String value = dataList.get(i).get(cols[j])+"";
	                        if (!value.equals("") && value!=null && !"null".equals(value)) {  
	                            label = new Label(j, i + 1, value);  
	                        } else {  
	                            label = new Label(j, i + 1, "");  
	                        }  
	                        sheet.addCell(label);  
	                    }  
	                }  
	            }  
	            wwb.write();  
	            wwb.close(); 
	            out.flush();
				out.close();
	        } catch (Exception e) {  
	            log.debug("------------Error! Sorry!------------");  
	            e.printStackTrace();  
	        } 
	    }  
	    
	    
}

