package cn.qpwa.common.web.utils;

import java.util.Random;

public class StringUtil {
	
	public static void main(String[] args){
//		System.out.println(get7RandomInt());
	}
	
	/**
	 * 获取当前的时间戳
	 * @return
	 */
	public static String getCurrentTimeMillis(){
		return String.valueOf(System.currentTimeMillis());
	}
	
	/**
	 * 产生7位随机数
	 * @return
	 */
	public static String get7RandomInt(){
		Random rand = new Random();
		long randomInt =  rand.nextInt(9000000)+999999;
		return String.valueOf(randomInt);
	}
}
