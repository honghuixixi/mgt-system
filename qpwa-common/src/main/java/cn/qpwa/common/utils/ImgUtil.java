package cn.qpwa.common.utils;

import org.im4java.core.ConvertCmd;
import org.im4java.core.IM4JavaException;
import org.im4java.core.IMOperation;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/** 
 * 图片压缩工具类,提供按图片的高宽、尺寸、质量、图片类型等参数压缩图片.
 * 
 * @author vinceyu
 * @date 2015-11-6
 * @versions 1.0
 */
public class ImgUtil {

	private static Map<String, ImgFlg> imgFlgMap = null;
	// window 需要下载 安装ImageMagick工具
	private static String imageMagickPath = null;

	static {
		imageMagickPath = "C:/Program Files/ImageMagick-6.9.2-Q16";
		imgFlgMap = new HashMap<String, ImgFlg>();
		for (ImgFlg img : ImgFlg.values()) {
			imgFlgMap.put(img.toString(), img);
		}
	}

	public static String FROM = "/root/software/bbccdd.jpg";
	// public static String FROM = "D:/111/IMG_20150120_085926.jpg";

	// 图片压缩后质量最大值(1-100)
	public final static Integer MAX_QUALITY = 100;
	// 图片压缩后质量默认值
	public final static Integer DEFAULT_QUALITY = 60;
	// 压缩后图片临时存放的根目录
	public static String TO_ROOT = "/data/temp/img/";
//	 public static String TO_ROOT = "d:/111/temp/";
	// 压缩后临时存放默认图片的目录，可以根据此图片再压缩其他尺寸的图片
	public static String TO_SOURCE = TO_ROOT + "source/";
	// 压缩后临时存放列表图片的目录
	public static String TO_LIST = TO_ROOT + "list/";
	// 压缩后临时存放详情页小图的目录
	public static String TO_SMALL = TO_ROOT + "small/";
	// 压缩后临时存放详情页中图的目录
	public static String TO_MEDIUM = TO_ROOT + "medium/";
	// 压缩后临时存放详情页大图的目录
	public static String TO_LARGE = TO_ROOT + "large/";
	// 同步已压缩图片的工具脚本
	public static String SHELL_FULL_NAME = "/root/scpImg.sh ";

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Logger.getLogger(ImgUtil.class.getName()).log(Level.INFO, String.valueOf(getSize(FROM)));
		// handlerImage(FROM);
		handlerImage(FROM, "promotion");
		/*
		 * try { IMOperation op = new IMOperation(); op.addImage(FROM);
		 * op.resize(400, 400); op.addImage(TO_SMALL +
		 * UUID.randomUUID().toString() + FROM.substring(FROM.lastIndexOf('.'),
		 * FROM.length())); ConvertCmd convert = new ConvertCmd();
		 * convert.setSearchPath(IMAGEMAGICK); convert.run(op); //
		 * cutImage(FROM, TO, 1198, 48, 370,320); // addImgText(""); } catch
		 * (Exception e) { e.printStackTrace(); }
		 */
	}

	@Deprecated
	public static void handlerImage() {
		// 重命名
		String imgName = UUID.randomUUID().toString()
				+ FROM.substring(FROM.lastIndexOf('.'), FROM.length());

		// 原图片压缩
		mkdir(TO_SOURCE + imgName);
		compressImage(FROM, TO_SOURCE + imgName, 800, 800);

		// list列表页图片压缩
		mkdir(TO_LIST + imgName);
		compressImage(FROM, TO_LIST + imgName, 220, 220);

		// 详情页小图片压缩
		mkdir(TO_SMALL + imgName);
		compressImage(FROM, TO_SMALL + imgName, 60, 60);

		// 详情页中图片压缩
		mkdir(TO_MEDIUM + imgName);
		compressImage(FROM, TO_MEDIUM + imgName, 300, 300);

		// 详情页大图片压缩
		mkdir(TO_LARGE + imgName);
		compressImage(FROM, TO_LARGE + imgName, 600, 600);

		try {
			executeShell(SHELL_FULL_NAME + ImgFlg.THUMBNAIL.toString() + " " + imgName + " "
					+ TO_ROOT);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据图片的完整路径,压缩为平台规定尺寸的图片(包含列表、商品详情页各尺寸图片),仅适用商品缩略图.
	 * 
	 * @param img 图片完整路径
	 */
	public static void handlerImage(String img) {

		String imgName = getImgName(img);

		// 原图片压缩
		mkdir(TO_SOURCE + imgName);
		compressImage(img, TO_SOURCE + imgName, 800, 800);

		// list列表页图片压缩
		mkdir(TO_LIST + imgName);
		compressImage(img, TO_LIST + imgName, 220, 220);

		// 详情页小图片压缩
		mkdir(TO_SMALL + imgName);
		compressImage(img, TO_SMALL + imgName, 60, 60);

		// 详情页中图片压缩
		mkdir(TO_MEDIUM + imgName);
		compressImage(img, TO_MEDIUM + imgName, 300, 300);

		// 详情页大图片压缩
		mkdir(TO_LARGE + imgName);
		compressImage(img, TO_LARGE + imgName, 600, 600);

		try {
			executeShell(SHELL_FULL_NAME + ImgFlg.THUMBNAIL.toString() + " " + imgName + " "
					+ TO_ROOT);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据图片的完整路径以及图片的自定义枚举类型值(查看内部类{@link ImgFlg})压缩图片.
	 * 
	 * @param img 图片完整路径
	 */
	public static void handlerImage(String img, String imgFlgValue) {
		handlerImage(img, imgFlgMap.get(imgFlgValue));
	}

	/**
	 * @see ImgUtil#handlerImage(String, String)
	 */
	public static void handlerImage(String img, ImgFlg imgFlg) {
		if (null == imgFlg) {
			Logger.getLogger(ImgUtil.class.getName()).log(Level.WARNING, "undefined enum type");
			return;
		}
		switch (imgFlg) {
		case THUMBNAIL:
			handlerImage(img);
			return;
		case PROMOTION:
			compressImage(img, TO_ROOT + getImgName(img), 680, 284);
			break;
		case PROMOTION_B2B:
			compressImage(img, TO_ROOT + getImgName(img), 990, 349);
			break;
		default:// DETAIL,ICON,AD(此类型图片未按新图片尺寸压缩)
			compressImage(img, TO_ROOT + getImgName(img),75);
			break;
		}

		try {
			executeShell(SHELL_FULL_NAME + imgFlg.toString() + " " + TO_ROOT + getImgName(img));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据尺寸压缩图片.
	 * @see ImgUtil#compressImage(String, String, Integer, Integer, Integer)
	 */
	public static void compressImage(String srcPath, String newPath, Integer width, Integer height) {
		compressImage(srcPath, newPath, width, height, MAX_QUALITY);
	}

	/**
	 * 根据质量按原图尺寸压缩图片.
	 * @see ImgUtil#compressImage(String, String, Integer, Integer, Integer)
	 */
	public static void compressImage(String srcPath, String newPath, Integer quality) {
		compressImage(srcPath, newPath, null, null, quality);
	}

	/**
	 * 按原图尺寸压缩图片.
	 * @see ImgUtil#compressImage(String, String, Integer, Integer, Integer)
	 */
	public static void compressImage(String srcPath, String newPath) {
		compressImage(srcPath, newPath, null, null, null);
	}

	/**
	 * 根据尺寸压缩图片,如果压缩尺寸比例与原图比例不一致,使用透明色填充.
	 * 
	 * @param srcPath 源图片完整路径
	 * @param newPath 压缩后图片的完整路径
	 * @param width 压缩后图片的宽度(宽或高为空时按原图尺寸压缩)
	 * @param height 压缩后图片的高度
	 * @param quality 压缩后图片的质量1-100
	 */
	public static void compressImage(String srcPath, String newPath, Integer width, Integer height,
			Integer quality) {
		IMOperation op = new IMOperation();
		quality = quality == null ? DEFAULT_QUALITY : quality;
		if (width != null && height != null) {
			String rawSize = width + "x" + height;
			op.addRawArgs("-thumbnail", rawSize);
			op.addRawArgs("-extent", rawSize);
		}
		op.addRawArgs("-gravity", "center");
		op.addRawArgs("-quality", quality.toString());
		op.addImage(srcPath);
		op.addImage(newPath);
		ConvertCmd convert = new ConvertCmd();
//		 convert.setSearchPath(imageMagickPath);
		try {
			convert.run(op);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (IM4JavaException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * 根据坐标裁剪图片
	 * 
	 * @param srcPath 要裁剪图片的路径
	 * @param newPath 裁剪图片后的路径
	 * @param x 起始横坐标
	 * @param y 起始纵坐标
	 * @param x1 结束横坐标
	 * @param y1 结束纵坐标
	 */
	public static void cutImage(String srcPath, String newPath, int x, int y, int x1, int y1)
			throws Exception {
		int width = x1 - x;
		int height = y1 - y;
		IMOperation op = new IMOperation();
		op.addImage(srcPath);
		/**
		 * width：  裁剪的宽度
		 * height： 裁剪的高度
		 * x：       裁剪的横坐标
		 * y：       裁剪的挫坐标
		 */
		op.crop(width, height, x, y);
		op.addImage(newPath);
		ConvertCmd convert = new ConvertCmd();
		convert.setSearchPath(imageMagickPath);
		convert.run(op);
	}

	/**
	 * 给图片加水印
	 * 
	 * @param srcPath 源图片路径
	 */
	public static void addImgText(String srcPath) throws Exception {
		IMOperation op = new IMOperation();
		op.font("宋体").gravity("southeast").pointsize(38).fill("#BCBFC8").draw("text 5,5 VVV.com");
		op.addImage(FROM);
		op.resize(500, 500);// 压缩图片
		op.addImage(TO_SOURCE);
		ConvertCmd convert = new ConvertCmd();
		convert.run(op);
	}

	/**
	 * 获得图片文件的大小
	 * 
	 *@param filePath  图片文件完整路径
	 *
	 * @return 文件大小
	 */
	private static int getSize(String imagePath) {
		int size = 0;
		FileInputStream inputStream = null;
		try {
			inputStream = new FileInputStream(imagePath);
			size = inputStream.available();
		} catch (FileNotFoundException e) {
			size = 0;
			Logger.getLogger(ImgUtil.class.getName()).log(Level.WARNING, "file not found");
		} catch (IOException e) {
			size = 0;
			Logger.getLogger(ImgUtil.class.getName()).log(Level.WARNING, "read file exception");
		} finally {
			// 关闭输入流
			if (null != inputStream) {
				try {
					inputStream.close();
				} catch (IOException e) {
					Logger.getLogger(ImgUtil.class.getName()).log(Level.WARNING,
							"close file exception");
				}
				inputStream = null;
			}
		}
		return size;
	}

	/**
	 * 检验文件路径是否存在,不存在创建.
	 * 
	 * @param path 文件路径
	 */
	private static void mkdir(String path) {
		File file = new File(path);
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
	}

	/**
	 * 获取图片名
	 * 
	 * @param img 图片完整路径名称,如:"/data/img/xxx.jpg".
	 * 
	 * @return 图片名,如:"xxx.jpg"
	 */
	private static String getImgName(String img) {
		File tempFile = new File(img.trim());
		String imgName = tempFile.getName();
		tempFile = null;
		return imgName;
	}

	/**
	 * 调用shell脚本将压缩后的图片同步到图片服务器
	 * 
	 * @param shellCommand shell脚本名字(包含参数).参数1为图片类型,参数2为图片名(图片类型非"thumbnail"，此参数值为完整路径)、参数3为图片跟路径
	 * @return
	 * @throws IOException
	 */
	private static int executeShell(String shellCommand) throws IOException {
		int success = 0;
		StringBuffer stringBuffer = new StringBuffer();
		BufferedReader bufferedReader = null;
		// 格式化日期时间，记录日志时使用
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS ");

		try {
			stringBuffer.append(dateFormat.format(new Date())).append("prepare execute Shell : ")
					.append(shellCommand).append(" \r\n");
			Process pid = null;
			String[] cmd = { "/bin/sh", "-c", shellCommand };
			// 执行Shell命令
			pid = Runtime.getRuntime().exec(cmd);
			if (pid != null) {
				stringBuffer.append("PID：").append(pid.toString()).append("\r\n");
				// bufferedReader用于读取Shell的输出内容
				bufferedReader = new BufferedReader(new InputStreamReader(pid.getInputStream()),
						1024);
				pid.waitFor();
			} else {
				stringBuffer.append(" pid null \r\n");
			}
			stringBuffer.append(dateFormat.format(new Date())).append(
					"Shell result：\r\n");
			String line = null;
			// 读取Shell的输出内容，并添加到stringBuffer中
			while (bufferedReader != null && (line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line).append("\r\n");
			}
			System.out.println(stringBuffer);
		} catch (Exception ioe) {
			stringBuffer.append("Shell Exception：\r\n").append(ioe.getMessage()).append("\r\n");
		} finally {
			if (bufferedReader != null) {
				OutputStreamWriter outputStreamWriter = null;
				OutputStream outputStream = null;
				try {
					bufferedReader.close();
					// 将Shell的执行情况输出到日志文件中
					outputStream = new FileOutputStream("/root/executeShell.log");
					outputStreamWriter = new OutputStreamWriter(outputStream, "UTF-8");
					outputStreamWriter.write(stringBuffer.toString());
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					try {
						outputStreamWriter.close();
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						outputStreamWriter = null;
					}
					try {
						outputStream.close();
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						outputStream = null;
					}
				}
			}
			success = 1;
		}
		return success;
	}

	/**
	 * 图片类型枚举类,平台图片类型:促销广告图片、商品缩略图（套）、轮播广告等.
	 */
	public enum ImgFlg {
		THUMBNAIL("thumbnail"), // 商品缩略图（列表、详情各图片）
		PROMOTION("promotion"), // 促销广告图片
		PROMOTION_B2B("promotion"), // 主站促销活动图片
		DETAIL("detail"),// 商品详情图片
		ICON("icon"),// 平台图标图片如：店铺logo等
		AD("ad"),// 平台广告图片
		APPSHOP("appshop");// 店铺拜访图片

		private String statusName;

		private ImgFlg(String statusName) {
			this.statusName = statusName;
		}

		@Override
		public String toString() {
			return String.valueOf(this.statusName);
		}
	}
}