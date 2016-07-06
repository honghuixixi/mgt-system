package cn.qpwa.common.utils;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.net.util.Base64;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import java.io.UnsupportedEncodingException;

public class Base64Utils {
	// 加密
	public static String getBase64(String str) {
		byte[] b = null;
		String s = null;
		try {
			b = str.getBytes("utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		if (b != null) {
			s = new BASE64Encoder().encode(b);
		}
		return s;
	}

	// 解密
	public static String getFromBase64(String s) {
		byte[] b = null;
		String result = null;
		if (s != null) {
			BASE64Decoder decoder = new BASE64Decoder();
			try {
				b = decoder.decodeBuffer(s);
				result = new String(b, "UTF-8");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	
	/**
	 * 使用apache Base64加密算法加密字符串
	 * @param plainText
	 * @return
	 */
    public static String encodeStr(String plainText){
        byte[] b=plainText.getBytes();
        Base64 base64=new Base64();
        b=base64.encode(b);
        String s=new String(b);
        return s;
    }
    
    /**
     * 使用apache base64算法解密
     * @param encodeStr
     * @return
     */
    public static String decodeStr(String encodeStr){
        byte[] b=encodeStr.getBytes();
        Base64 base64=new Base64();
        b=base64.decode(b);
        String s = null;
		try {
			s = new String(b,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
        return s;
    }
    
    private static void encode1(){
		String usid = "DUJF";
		String amt = "3.2";
		String type = "ecitic";
		String code = "6216261000000000018";
		String name = "杜建芳";
		String bnm = "中信银行杭州延安支行";
		String param = "USID="+usid+"&AMT="+amt+"&TYPE="+type+"&CODE="+code+"&NM="+name+"&BNM="+bnm;
		
		System.out.println(encodeStr(usid));
		System.out.println(encodeStr(amt));
		System.out.println(encodeStr(type));
		System.out.println(encodeStr(code));
		System.out.println(encodeStr(name));
		System.out.println(encodeStr(param));
		System.out.println(decodeStr(encodeStr(param)));
		
    }
    
    public static void encode2(){
    	String params = "USID=yybm";
		String base64 = encodeStr(params);
		System.out.println(base64);
		
		try {
			String bs = base64+"WLWSIGN";
//			System.out.println(bs);
			String sign = DigestUtils.md5Hex(bs).toUpperCase();
			System.out.println(sign);
			String utf8Sign = new String(sign.getBytes("UTF-8"));
			System.out.println(utf8Sign);
			String b2 = decodeStr(base64);
			System.out.println(b2);
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    
	public static void main(String[] args) {
		encode2();
	}
}