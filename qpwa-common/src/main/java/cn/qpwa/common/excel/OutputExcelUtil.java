package cn.qpwa.common.excel;

import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

public class OutputExcelUtil {

	/**
	 * 把相关数据的excel输出到对应输出流中
	 * @param fileName    输出文件名
	 * @param out         输出流
	 * @param title       excel中的标题数组
	 * @param valueName   每条记录每列对应的key
	 * @param lists       记录的数据
	 */
	public static void exportDataToExcel(String fileName, OutputStream out, String[] title, String[] valueName,
			List<Map<String, Object>> lists) {
		if (title.length != valueName.length) {
			throw new RuntimeException("input date invalid");
		}
		// 以下开始输出到EXCEL
		try {
			/** **********创建工作簿************ */
			WritableWorkbook workbook = Workbook.createWorkbook(out);
			/** **********创建工作表************ */
			WritableSheet sheet = workbook.createSheet("Sheet1", 0);
			/** **********设置纵横打印（默认为纵打）、打印纸***************** */
			jxl.SheetSettings sheetset = sheet.getSettings();
			sheetset.setProtected(false);

			/** ***************以下是EXCEL开头大标题，暂时省略********************* */
			// sheet.mergeCells(0, 0, colWidth, 0);
			// sheet.addCell(new Label(0, 0, "XX报表", wcf_center));
			/** ***************以下是EXCEL第一行列标题********************* */
			// CellView cellView = new CellView();
			// cellView.setAutosize(true);

			WritableFont NormalFont = new WritableFont(WritableFont.ARIAL, 10);
			WritableFont BoldFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);

			WritableCellFormat CENTER = new WritableCellFormat();
			WritableCellFormat LEFT = new WritableCellFormat();
			WritableCellFormat RIGHT = new WritableCellFormat();
			WritableCellFormat TITLE = new WritableCellFormat();
			CENTER.setFont(BoldFont);
			CENTER.setBorder(Border.ALL, BorderLineStyle.THIN); // 线条
			CENTER.setVerticalAlignment(VerticalAlignment.CENTRE); // 文字垂直对齐
			CENTER.setAlignment(Alignment.CENTRE); // 文字水平对齐
			CENTER.setWrap(false); // 文字是否换行

			TITLE.setFont(BoldFont);
			TITLE.setBorder(Border.ALL, BorderLineStyle.THIN); // 线条
			TITLE.setVerticalAlignment(VerticalAlignment.CENTRE); // 文字垂直对齐
			TITLE.setAlignment(Alignment.CENTRE); // 文字水平对齐
			TITLE.setWrap(false); // 文字是否换行
			TITLE.setBackground(Colour.ORANGE);

			for (int i = 0; i < title.length; i++) {
				sheet.setColumnView(0, 25);
				sheet.addCell(new Label(i, 0, title[i], TITLE));
			}
			for (int i = 0; i < lists.size(); i++) {
				Map<String, Object> jo = lists.get(i);
				for (int j = 0; j < valueName.length; j++) {
					Object a = jo.get(valueName[j]);
					if (a == null) {
						a = "";
					}
					sheet.addCell(new Label(j, i + 1, a.toString(), CENTER));
				}
			}
			/** **********将以上缓存中的内容写到EXCEL文件中******** */
			workbook.write();
			/** *********关闭文件************* */
			workbook.close();
			/** 关闭流 */
			out.flush();
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
