package cn.qpwa.common.utils;

import java.math.BigInteger;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

/**
 * UUID工具类
 */
public final class UUIDUtil {

	private static SecureRandom rnd;

	static {
		try {
			rnd = SecureRandom.getInstance("SHA1PRNG");
		} catch (NoSuchAlgorithmException e) {
			rnd = new SecureRandom(); // Use default if prefered provider is
										// unavailable
		}

		byte[] seed = rnd.generateSeed(64);
		rnd.setSeed(seed);
	}

	public static String generateFormattedGUID() {
		String guid = generateGUID();
		return guid.substring(0, 8) + '-' + guid.substring(8, 12) + '-' + guid.substring(12, 16) + '-'
				+ guid.substring(16, 20) + '-' + guid.substring(20);
	}

	public static String generateGUID() {
		return new BigInteger(165, rnd).toString(36).toUpperCase();
	}
}
