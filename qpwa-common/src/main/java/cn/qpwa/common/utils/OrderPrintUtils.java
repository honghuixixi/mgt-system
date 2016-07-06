package cn.qpwa.common.utils;

import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.rtf.RtfWriter2;
import com.lowagie.text.rtf.field.RtfPageNumber;
import com.lowagie.text.rtf.field.RtfTotalPageNumber;
import com.lowagie.text.rtf.headerfooter.RtfHeaderFooter;
import com.lowagie.text.rtf.style.RtfFont;

import java.awt.*;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@SuppressWarnings({ "rawtypes" })
public class OrderPrintUtils {
	public void createDocContext(String filePath, String arg,
			Map<String, Object> map) throws DocumentException, IOException {
		// 设置纸张大小
//		Float hight = Float.valueOf(arg);
//		Rectangle pf = new Rectangle(585, hight);// 宽度*高度
//		Document document = new Document(pf);
		Document document = new Document(PageSize.A4);

		// 建立一个书写器(Writer)与document对象关联，通过书写器(Writer)可以将文档写入到磁盘中
		RtfWriter2.getInstance(document, new FileOutputStream(filePath));
		document.open();
		// 设置中文字体
		BaseFont bfChinese = BaseFont.createFont(
				"c:\\windows\\fonts\\SIMHEI.TTF", BaseFont.IDENTITY_H,
				BaseFont.NOT_EMBEDDED);
		// 标题字体风格
		RtfFont titleFont = new RtfFont("宋体", 18, Font.BOLD, Color.BLACK);
		Font fontChinese = new Font(bfChinese, 12, Font.NORMAL, Color.black);
		Paragraph title = new Paragraph("联合采购送货单");
		// 设置标题格式对齐方式
		title.setAlignment(Element.ALIGN_CENTER);
		title.setFont(titleFont);
		document.add(title);

		// 设置 Table 表格，创建一个3列的表格
		Table aTable = new Table(3);// 设置表格为3列
		aTable.setWidths(new int[] { 38, 35, 27 });// 设置每列所占比例
		aTable.setWidth(100); // 占页面宽度 100%
		// 订单信息
		Cell cell = new Cell(new Phrase("单据编号："
				+ ((Map) map.get("order")).get("MAS_NO"), fontChinese));
		cell.setBorderWidth(0);// 单元格边框为0
		aTable.addCell(cell);
		cell = new Cell(new Phrase("单据日期："
				+ ((Map) map.get("order")).get("OM_CREATE_DAT"), fontChinese));
		cell.setBorderWidth(0);
		aTable.addCell(cell);
		cell = new Cell(new Phrase("订单ID："
				+ ((Map) map.get("order")).get("PK_NO"), fontChinese));
		cell.setBorderWidth(0);
		aTable.addCell(cell);
		cell = new Cell(new Phrase("供应商："
				+ ((Map) map.get("order")).get("VENDOR_CODE"), fontChinese));
		cell.setBorderWidth(0);
		cell.setColspan(3);// 设置此列 夸列 3列
		aTable.addCell(cell);
		cell = new Cell(new Phrase("客户名称："
				+ ((Map) map.get("order")).get("CUST_CODE"), fontChinese));
		cell.setBorderWidth(0);
		aTable.addCell(cell);
		String mobile = null;
		if (null == ((Map) map.get("order")).get("RECEIVER_MOBILE")) {
			cell = new Cell(new Phrase("", fontChinese));
			cell.setBorderWidth(0);
			aTable.addCell(cell);
		} else {
			mobile = ((Map) map.get("order")).get("RECEIVER_MOBILE").toString();
			cell = new Cell(new Phrase("联系电话：" + mobile, fontChinese));
			cell.setBorderWidth(0);
			aTable.addCell(cell);
		}
		String tel = null;
		if (null == ((Map) map.get("order")).get("RECEIVER_TEL")) {
			cell = new Cell(new Phrase("", fontChinese));
			cell.setBorderWidth(0);
			aTable.addCell(cell);
		} else {
			tel = ((Map) map.get("order")).get("RECEIVER_TEL").toString();
			cell = new Cell(new Phrase("固定电话：" + tel, fontChinese));
			cell.setBorderWidth(0);
			aTable.addCell(cell);
		}
		cell = new Cell(
				new Phrase("送货地址："
						+ ((Map) map.get("order")).get("RECEIVER_ADDRESS"),
						fontChinese));
		cell.setBorderWidth(0);
		cell.setColspan(3);// 设置此列 夸列 3列
		aTable.addCell(cell);
		document.add(aTable);

		// 设置Table表格,创建一个7列的表格，后台循环数据
		aTable = new Table(7);
		aTable.setWidths(new int[] { 5, 20, 40, 5, 8, 10, 12 });
		aTable.setWidth(100);
		aTable.addCell(new Cell("序号"));
		aTable.addCell(new Cell("条码/编码"));
		aTable.addCell(new Cell("商品名称"));
		aTable.addCell(new Cell("数量"));
		aTable.addCell(new Cell("单位"));
		aTable.addCell(new Cell("价格"));
		aTable.addCell(new Cell("金额小计"));

		// 定义别名方便循环使用
		List orderItem = (List) ((Map) map.get("order")).get("orderItem");
		// 格式化金额样式（2位小数）
		java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");
		double x = 0;
		double y = 0;

		for (int i = 0; i < orderItem.size(); i++) {
			aTable.addCell(new Cell(""
					+ ((Map) orderItem.get(i)).get("ITEM_NO")));
			Object obj = ((Map) orderItem.get(i)).get("PLU_C");
			if (obj == null) {
				obj = ((Map) orderItem.get(i)).get("STK_C");
			}
			aTable.addCell(new Cell("" + obj));
			aTable.addCell(new Cell(""
					+ ((Map) orderItem.get(i)).get("STK_NAME")));
			aTable.addCell(new Cell(""
					+ ((Map) orderItem.get(i)).get("UOM_QTY")));
			aTable.addCell(new Cell("" + ((Map) orderItem.get(i)).get("UOM")));
			aTable.addCell(new Cell(""
					+ df.format(((BigDecimal) ((Map) orderItem.get(i))
							.get("NET_PRICE")).doubleValue())));
			x = ((BigDecimal) ((Map) orderItem.get(i)).get("UOM_QTY"))
					.doubleValue();
			y = ((BigDecimal) ((Map) orderItem.get(i)).get("NET_PRICE"))
					.doubleValue();
			aTable.addCell(new Cell("" + df.format(x * y)));
		}
		cell = new Cell(new Phrase("" + map.get("chinesePrice"), fontChinese));
		cell.setBorderWidth(1);
		cell.setColspan(4);// 设置合并单元格
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);// 单元格居中显示
		aTable.addCell(cell);
		x = ((BigDecimal) ((Map) map.get("order")).get("AMOUNT")).doubleValue();
		y = ((BigDecimal) ((Map) map.get("order")).get("FREIGHT"))
				.doubleValue();
		cell = new Cell(new Phrase("本单小计：" + df.format(x - y)));
		cell.setBorderWidth(1);
		cell.setColspan(3);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);// 单元格居中显示
		aTable.addCell(cell);
		document.add(aTable);

		// 设置 Table 表格，创建一个3列的表格
		aTable = new Table(3);// 设置表格为3列
		int width[] = { 30, 30, 40 };// 每列的占比例
		aTable.setWidths(width);// 设置每列所占比例
		aTable.setWidth(100); // 占页面宽度 100%

		cell = new Cell(new Phrase("送货人：", fontChinese));
		cell.setBorderWidth(0);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);// 单元格居中显示
		aTable.addCell(cell);
		cell = new Cell(new Phrase("收货人：", fontChinese));
		cell.setBorderWidth(0);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		aTable.addCell(cell);
		cell = new Cell(new Phrase("制单：", fontChinese));
		cell.setBorderWidth(0);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		aTable.addCell(cell);
		document.add(aTable);

		// 设置 Table 表格，创建一个2列的表格
		aTable = new Table(2);// 设置表格为2列
		aTable.setWidths(new int[] { 50, 50 });// 设置每列所占比例
		aTable.setWidth(100); // 占页面宽度 100%
		// 订单打印时间
		cell = new Cell(new Phrase("", fontChinese));
		cell.setBorderWidth(0);
		aTable.addCell(cell);
		cell = new Cell(new Phrase("打单时间：" + map.get("date"), fontChinese));
		cell.setBorderWidth(0);
		cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
		aTable.addCell(cell);
		document.add(aTable);

		// 页眉段落
		RtfPageNumber number = new RtfPageNumber();
		Paragraph paraheader = new Paragraph();
		paraheader.add(new Phrase("第"));
		paraheader.add(number);
		paraheader.add(new Phrase("/"));
		paraheader.add(new RtfTotalPageNumber());
		paraheader.add(new Phrase("页"));
		HeaderFooter header = new RtfHeaderFooter(paraheader);
		header.setAlignment(Element.ALIGN_RIGHT);
		header.setBorder(Rectangle.NO_BORDER);
		document.setHeader(header);

		// 页眉段落
		// Paragraph paraHeader = new Paragraph("第sdsds页");
		// Font font = new Font();
		// //页脚的字体大小
		// font.setSize(12f);
		// font.setColor(new Color(0,0,0));
		// paraHeader.setFont(font);
		// paraHeader.setAlignment("right");
		// //（参数一）页脚的段落 和 （参数二）是否有页码
		// HeaderFooter header = new HeaderFooter(paraHeader, true);
		// //页脚的对齐方式（应该在footer设置而不是段落中设置）
		// paraHeader.setAlignment(1);
		// document.setHeader(header);
		document.close();
	}
}
