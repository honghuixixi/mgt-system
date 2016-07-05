package cn.qpwa.common.utils.qrcode;

import java.awt.BasicStroke;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Shape;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Hashtable;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.Result;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import cn.qpwa.common.utils.UUIDUtil;

/** 
 * 二维码工具类 
 *  
 */  
public class QRCodeUtil {

	private static final String CHARSET = "utf-8";  
    private static final String FORMAT_NAME = "JPG";  
    // 二维码尺寸 (默认) 
    public static final int QRCODE_SIZE = 100;  
    // 二维码名称 (默认) 
    public static final String QRCODE_NAME = UUIDUtil.generateFormattedGUID();  
    // LOGO宽度 (默认)
    private static final int WIDTH = 60;  
    // LOGO高度 (默认)
    private static final int HEIGHT = 60;  
    //二维码识别率(默认)H,Q,M,L容错率依次降低
    private static final ErrorCorrectionLevel ERROR_CORRECTION_LEVEL = ErrorCorrectionLevel.L;
    //logo是否压缩(默认)
    private static final boolean LOGO_NEED_COMPRESS = true;
    
   /**
    * 生成二维码图片
    * @param content
    * 			内容
    * @param imgPath
    * 			LOGO图片地址
    * @param qrcodeSize
    * 			二维码的尺寸(正方形)
    * @param errorCorrectionLevel
    * 			二维码识别率
    * @param needCompress
    * 			是否压缩（针对二维码中添加的logo图片）
    * @return BufferedImage
    * @throws Exception
    */
    private static BufferedImage createImage(String content, String imgPath, int qrcodeSize,
    		ErrorCorrectionLevel errorCorrectionLevel, boolean needCompress) throws Exception {  
        Hashtable<EncodeHintType, Object> hints = new Hashtable<EncodeHintType, Object>();  
        //设置识别率，封装成一个参数
        hints.put(EncodeHintType.ERROR_CORRECTION, errorCorrectionLevel);  
        hints.put(EncodeHintType.CHARACTER_SET, CHARSET);  
        hints.put(EncodeHintType.MARGIN, 1);  
        BitMatrix bitMatrix = new MultiFormatWriter().encode(content,  
                BarcodeFormat.QR_CODE, qrcodeSize, qrcodeSize, hints); 
        int margin = 1;  //自定义白边边框宽度
        bitMatrix = updateBit(bitMatrix, margin);  //生成新的bitMatrix
        int width = bitMatrix.getWidth();  
        int height = bitMatrix.getHeight();  
        BufferedImage image = new BufferedImage(width, height,  
                BufferedImage.TYPE_INT_RGB);  
        for (int x = 0; x < width; x++) {  
            for (int y = 0; y < height; y++) {  
                image.setRGB(x, y, bitMatrix.get(x, y) ? 0xFF000000  
                        : 0xFFFFFFFF);  
            }  
        }  
        if (imgPath == null || "".equals(imgPath)) {  
            return image;  
        }  
        // 插入图片  
        QRCodeUtil.insertImage(image, imgPath, needCompress);  
        return image;  
    } 
    
    /** 
     * 插入LOGO 
     *  
     * @param source 
     *            二维码图片 
     * @param imgPath 
     *            LOGO图片地址 
     * @param needCompress 
     *            是否压缩 
     * @throws Exception 
     */  
    private static void insertImage(BufferedImage source, String imgPath,  
            boolean needCompress) throws Exception {  
        File file = new File(imgPath);  
        if (!file.exists()) {  
            System.err.println(""+imgPath+"   该文件不存在！");  
            return;  
        }  
        File f2 = new File(imgPath); 
        Image src = ImageIO.read(f2);  
        int width = src.getWidth(null);  
        int height = src.getHeight(null);  
        if (needCompress) { // 压缩LOGO  
            if (width > WIDTH) {  
                width = WIDTH;  
            }  
            if (height > HEIGHT) {  
                height = HEIGHT;  
            }  
            Image image = src.getScaledInstance(width, height,  
                    Image.SCALE_SMOOTH);  
            BufferedImage tag = new BufferedImage(width, height,  
                    BufferedImage.TYPE_INT_RGB);  
            Graphics g = tag.getGraphics();  
            g.drawImage(image, 0, 0, null); // 绘制缩小后的图  
            g.dispose();  
            src = image;  
        }  
        // 插入LOGO  
        Graphics2D graph = source.createGraphics();  
        int x = (QRCODE_SIZE - width) / 2;  
        int y = (QRCODE_SIZE - height) / 2;  
        graph.drawImage(src, x, y, width, height, null);  
        Shape shape = new RoundRectangle2D.Float(x, y, width, width, 6, 6);  
        graph.setStroke(new BasicStroke(3f));  
        graph.draw(shape);  
        graph.dispose();  
    } 
    
    /**
     * 生成二维码
     * @param content
     * 			内容
     * @param imgPath
     * 			LOGO图片地址 
     * @param qrcodeSize
     * 			二维码的尺寸(正方形)
     * @param qrcodeDestPath
     * 			二维码的存放地址
     * @param errorCorrectionLevel
     * 			二维码识别率
     * @param needCompress
     * 			是否压缩（针对二维码中添加的logo图片）
     * @param qrcodeName
     * 			二维码名称
     * @throws Exception
     */
    public static String encode(String content, String imgPath, int qrcodeSize, String qrcodeDestPath,
    		ErrorCorrectionLevel errorCorrectionLevel, boolean needCompress, String qrcodeName) throws Exception {
    	BufferedImage image = QRCodeUtil.createImage(content, imgPath, qrcodeSize, errorCorrectionLevel, needCompress);
        mkdirs(qrcodeDestPath); 
        //二维码名称
        String file = qrcodeDestPath + "/" + qrcodeName + ".jpg"; 
        ImageIO.write(image, FORMAT_NAME, new File(file));  
        return file;
    }
    
    /**
     * 生成二维码(无内嵌LOGO) 
     * @param content
     * 			内容
     * @param qrcodeName
     * 			二维码名称
     * @param qrcodeDestPath 
     *            存储地址 
     * @throws Exception
     * @return String二维码的存放地址
     */
    public static String encode(String content, String qrcodeName, String qrcodeDestPath) throws Exception { 
    	return QRCodeUtil.encode(content, null, QRCODE_SIZE, qrcodeDestPath, ERROR_CORRECTION_LEVEL, LOGO_NEED_COMPRESS, qrcodeName);
    }
    
    /** 
     * 生成二维码 (无内嵌LOGO) 
     *  
     * @param content 
     *            内容 
     * @param qrcodeSize
     * 			    二维码的尺寸(正方形)
     * @param qrcodeDestPath 
     *            存储地址 
     * @throws Exception 
     */  
    public static void encode(String content, int qrcodeSize, String qrcodeDestPath) throws Exception {  
        QRCodeUtil.encode(content, null, qrcodeSize, qrcodeDestPath, ERROR_CORRECTION_LEVEL, LOGO_NEED_COMPRESS, QRCODE_NAME);
    } 
    
    /**
     * 生成二维码(内嵌LOGO) 
     * @param content
     * 			内容
     * @param qrcodeSize
     * 			二维码的尺寸(正方形)
     * @param qrcodeDestPath
     * 			二维码的存放地址
     * @param qrcodeName
     * 			二维码名称
     * @throws Exception
     */
    public static void encode(String content, int qrcodeSize, String qrcodeDestPath, String qrcodeName) throws Exception { 
    	QRCodeUtil.encode(content, null, qrcodeSize, qrcodeDestPath, ERROR_CORRECTION_LEVEL, LOGO_NEED_COMPRESS, qrcodeName);
    }
    
    /**
     * 生成二维码(内嵌LOGO) 
     * @param content
     * 			内容
     * @param imgPath
     * 			LOGO图片地址
     * @param qrcodeDestPath
     * 			二维码的存放地址
     * @param needCompress
     * 			是否压缩
     * @throws Exception
     */
    public static void encodeWithInLogo(String content, String imgPath, String qrcodeDestPath, boolean needCompress) throws Exception {
    	QRCodeUtil.encode(content, imgPath, QRCODE_SIZE, qrcodeDestPath, ERROR_CORRECTION_LEVEL, needCompress, QRCODE_NAME);
    }
    
    /** 
     * 生成二维码(内嵌LOGO) 
     *  
     * @param content 
     *            内容 
     * @param imgPath 
     *            LOGO地址 
     * @param destPath 
     *            存储地址 
     * @throws Exception 
     */  
    public static void encodeWithInLogo(String content, String imgPath, String destPath)  
            throws Exception {  
        QRCodeUtil.encode(content, imgPath, QRCODE_SIZE, destPath, ERROR_CORRECTION_LEVEL, true, QRCODE_NAME);  
    } 
    
    /** 
     * 解析二维码 
     *  
     * @param file 
     *            二维码图片 
     * @return 
     * @throws Exception 
     */  
    public static String decode(File file) throws Exception {  
        BufferedImage image;  
        image = ImageIO.read(file);  
        if (image == null) {  
            return null;  
        }  
        BufferedImageLuminanceSource source = new BufferedImageLuminanceSource(  
                image);  
        BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));  
        Result result;  
        Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>();  
        hints.put(DecodeHintType.CHARACTER_SET, CHARSET);  
        result = new MultiFormatReader().decode(bitmap, hints);  
        String resultStr = result.getText();  
        return resultStr;  
    }  
  
    /** 
     * 解析二维码 
     *  
     * @param path 
     * 		二维码图片地址 
     * @return 
     * @throws Exception 
     */  
    public static String decode(String path) throws Exception {  
        return QRCodeUtil.decode(new File(path));  
    } 
    
    /** 
     * 当文件夹不存在时，mkdirs会自动创建多层目录，区别于mkdir．(mkdir如果父目录不存在则会抛出异常) 
     * @param destPath 存放目录 
     */  
    public static void mkdirs(String destPath) {  
        File file =new File(destPath);      
        //当文件夹不存在时，mkdirs会自动创建多层目录，区别于mkdir．(mkdir如果父目录不存在则会抛出异常)  
        if (!file.exists() && !file.isDirectory()) {  
            file.mkdirs();  
        }  
    }
    
    /**
     * 裁剪二维码白边的宽度
     * @param matrix
     * 			二维码
     * @param margin
     * 			白边宽度
     * @return
     */
    private static BitMatrix updateBit(BitMatrix matrix, int margin){
        int tempM = margin*2;
       int[] rec = matrix.getEnclosingRectangle();   //获取二维码图案的属性
            int resWidth = rec[2] + tempM;
            int resHeight = rec[3] + tempM;
            BitMatrix resMatrix = new BitMatrix(resWidth, resHeight); // 按照自定义边框生成新的BitMatrix
            resMatrix.clear();
        for(int i= margin; i < resWidth- margin; i++){   //循环，将二维码图案绘制到新的bitMatrix中
            for(int j=margin; j < resHeight-margin; j++){
                if(matrix.get(i-margin + rec[0], j-margin + rec[1])){
                    resMatrix.set(i,j);
                }
            }
        }
         return resMatrix;
    }
    
    public static void main(String[] args) {
		try {
			encode("weixin://wxpay/bizpayurl?pr=4hIR6Sg", "wxpay", "./");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
