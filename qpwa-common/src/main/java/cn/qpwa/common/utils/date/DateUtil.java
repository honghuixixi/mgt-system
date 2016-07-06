package cn.qpwa.common.utils.date;

import org.apache.commons.lang.StringUtils;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 提供对日期时间操作的几个日常方法.
 */
public class DateUtil {
	private static final long ONE_DAY = 24 * 3600000;

	private static final long ONE_MINUTE = 60000;

	private static String datePattern = "yyyy-MM-dd";

	private static String timePattern = "HH:mm:ss";
	
	private static String datePattern1 = "yyyy/MM/dd";

	private static SimpleDateFormat dateFormat = new SimpleDateFormat(
			datePattern);

	private static SimpleDateFormat datetimeFormat = new SimpleDateFormat(
			datePattern + " " + timePattern);
	
	private static SimpleDateFormat datetimeFormat1 = new SimpleDateFormat(
			datePattern1 + " " + timePattern);

	/**
	 * 将日期对象转换为字符串，格式为yyyy-MM-dd.
	 * 
	 * @param date
	 *            日期.
	 * @return 日期对应的日期字符串.
	 */
	public static String toDateString(Date date) {
		if (date == null) {
			return null;
		}
		return dateFormat.format(date);
	}
	
	/**
	 * 将字符串转换为日期对象，字符串必须符合yyyy-MM-dd的格式.
	 * 
	 * @param s
	 *            要转化的字符串.
	 * @return 字符串转换成的日期.如字符串为NULL或空串,返回NULL.
	 */
	public static Date toDate(String s) {
		s = StringUtils.trim(s);
		if (s.length() < 1) {
			return null;
		}
		try {
			if (s.length() <= 10) {
				return dateFormat.parse(s);
			}
			return toDate(Timestamp.valueOf(s));
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 将日期对象转换为字符串，转换后的格式为yyyy-MM-dd HH:mm:ss.
	 * 
	 * @param date
	 *            要转换的日期对象.
	 * @return 字符串,格式为yyyy-MM-dd HH:mm:ss.
	 */
	public static String toDatetimeString(Date date) {
		if (date == null) {
			return null;
		}
		return datetimeFormat.format(date);
	}
	/**
	 * 将日期对象转换为字符串，转换后的格式为yyyy/MM/dd HH:mm:ss.
	 * 
	 * @param date
	 *            要转换的日期对象.
	 * @return 字符串,格式为yyyy/MM/dd HH:mm:ss.
	 */
	public static String toDatetimeString1(Date date) {
		if (date == null) {
			return null;
		}
		return datetimeFormat1.format(date);
	}
	/**
	 * 将日期对象转换为字符串，转换后的格式为yyyy-MM-dd HH:mm:ss.
	 * 
	 * @param date
	 *            要转换的日期对象.
	 * @return 字符串,格式为yyyy-MM-dd HH:mm:ss.
	 */
	public static Date toDatetime(String date) {
		if (date == null) {
			return null;
		}
		try {
			return datetimeFormat.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
		
	}

	/**
	 * 计算两个日期间相隔的周数
	 * 
	 * @param startDate
	 *            开始日期
	 * @param endDate
	 *            结束日期
	 * @return
	 */
	public static int computeWeek(Date startDate, Date endDate) {

		int weeks = 0;

		Calendar beginCalendar = Calendar.getInstance();
		beginCalendar.setTime(startDate);

		Calendar endCalendar = Calendar.getInstance();
		endCalendar.setTime(endDate);

		while (beginCalendar.before(endCalendar)) {

			// 如果开始日期和结束日期在同年、同月且当前月的同一周时结束循环
			if (beginCalendar.get(Calendar.YEAR) == endCalendar
					.get(Calendar.YEAR)
					&& beginCalendar.get(Calendar.MONTH) == endCalendar
							.get(Calendar.MONTH)
					&& beginCalendar.get(Calendar.DAY_OF_WEEK_IN_MONTH) == endCalendar
							.get(Calendar.DAY_OF_WEEK_IN_MONTH)) {
				break;

			} else {

				beginCalendar.add(Calendar.DAY_OF_YEAR, 7);
				weeks += 1;
			}
		}

		return weeks;
	}

	/**
	 * 返回当前系统时间
	 * 
	 * @return
	 */
	public static String getCurrDateTime() {
		return toDatetimeString(new Date());

	}

	/**
	 * 获取系统当前时间，待后期可扩展到取数据库时间
	 * 
	 * @return 系统当前时间
	 */
	public static String getCurrDate() {
		return toDateString(new Date());

	}
	/**
	 * 返回当前系统时间格式 yyyy/MM/dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getCurrDateTime1() {
		return toDatetimeString1(new Date());

	}
	/**
	 * 将Timestamp转换为日期.
	 * 
	 * @param timestamp
	 *            时间戳.
	 * @return 日期对象.如时间戳为NULL,返回NULL.
	 */
	public static Date toDate(Timestamp timestamp) {
		if (timestamp == null) {
			return null;
		}
		return new Date(timestamp.getTime());
	}

	/**
	 * 将日期转换为Timestamp.
	 * 
	 * @param date
	 *            日期.
	 * @return 时间戳.如日期为NULL,返回NULL.
	 */
	public static Timestamp toTimestamp(Date date) {
		if (date == null) {
			return null;
		}

		return new Timestamp(date.getTime());
	}

	/**
	 * 将时间戳对象转化成字符串.
	 * 
	 * @param t
	 *            时间戳对象.
	 * @return 时间戳对应的字符串.如时间戳对象为NULL,返回NULL.
	 */
	public static String toDateString(Timestamp t) {
		if (t == null) {
			return null;
		}
		return toDateString(toDate(t));
	}

	/**
	 * 将Timestamp转换为日期时间字符串.
	 * 
	 * @param t
	 *            时间戳对象.
	 * @return Timestamp对应的日期时间字符串.如时间戳对象为NULL,返回NULL.
	 */
	public static String toDatetimeString(Timestamp t) {
		if (t == null) {
			return null;
		}
		return toDatetimeString(toDate(t));
	}

	/**
	 * 将日期字符串转换为Timestamp对象.
	 * 
	 * @param s
	 *            日期字符串.
	 * @return 日期时间字符串对应的Timestamp.如字符串对象为NULL,返回NULL.
	 */

	public static Timestamp toTimestamp(String s) {
		return toTimestamp(toDate(s));
	}

	/**
	 * 返回年份，如2004.
	 * */
	public static int getYear(Date d) {

		Calendar c = Calendar.getInstance();
		c.setTime(d);
		return c.get(Calendar.YEAR);
	}

	public static int getYear() {
		return getYear(new Date());
	}

	/**
	 * 返回月份，为1－－ － 12内.
	 * */
	public static int getMonth(Date d) {
		Calendar c = Calendar.getInstance();
		c.setTime(d);
		return c.get(Calendar.MONTH) + 1;
	}

	public static int getMonth() {
		return getMonth(new Date());
	}

	/**
	 * 返回小时
	 * @param d
	 * @return
	 */
	public static int getHour(Date d){
		Calendar c = Calendar.getInstance();
		c.setTime(d);
		return c.get(Calendar.HOUR_OF_DAY);
	}
	
	public static int getHour(){
		return getHour(new Date());
	}
	
	/**
	 * 取得季度
	 * 
	 * @param d
	 *            日期类型
	 * @return
	 */
	public static final int getQuarter(Date d) {
		return getQuarter(getMonth(d));
	}

	/**
	 * 取得当前的季度
	 * 
	 * @return
	 */
	public static final int getQuarter() {
		return getQuarter(getMonth());
	}

	/**
	 * 传递月份,取得季度
	 * 
	 * @param num
	 * @return
	 */
	public static final int getQuarter(int num) {
		num = num % 3 == 0 ? num / 3 : (num / 3 + 1);
		return num % 4 == 0 ? 4 : num % 4;

	}

	/**
	 * 返回日期，为1－－ － 31内.
	 * */
	public static int getDay(Date d) {
		Calendar c = Calendar.getInstance();
		c.setTime(d);
		return c.get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 获得将来的日期.如果timeDiffInMillis > 0,返回将来的时间;否则，返回过去的时间
	 * 
	 * @param currDate
	 *            现在日期.
	 * @param timeDiffInMillis
	 *            毫秒级的时间差.
	 * @return 经过 timeDiffInMillis 毫秒后的日期.
	 * */
	public static Date getFutureDate(Date currDate, long timeDiffInMillis) {
		long l = currDate.getTime();

		l += timeDiffInMillis;
		return new Date(l);
	}

	/**
	 * 获得将来的日期.如果timeDiffInMillis > 0,返回将来的时间;否则，返回过去的时间.
	 * 
	 * @param currDate
	 *            现在日期.
	 * @param timeDiffInMillis
	 *            毫秒级的时间差.
	 * @return 经过 timeDiffInMillis 毫秒后的日期.
	 * */
	public static Date getFutureDate(String currDate, long timeDiffInMillis) {
		return getFutureDate(toDate(currDate), timeDiffInMillis);
	}

	/**
	 * 获得将来的日期.如果 days > 0,返回将来的时间;否则，返回过去的时间.
	 * 
	 * @param currDate
	 *            现在日期.
	 * @param days
	 *            经过的天数.
	 * @return 经过days天后的日期.
	 * */
	public static Date getFutureDate(Date currDate, int days) {
		long l = currDate.getTime();
		long l1 = (long) days * ONE_DAY;

		l += l1;
		return new Date(l);
	}

	/**
	 * 获得将来的日期.如果 days > 0,返回将来的时间;否则，返回过去的时间.
	 * 
	 * @param currDate
	 *            现在日期,字符型如2005-05-05 [14:32:10].
	 * @param days
	 *            经过的天数.
	 * @return 经过days天后的日期.
	 * */
	public static Date getFutureDate(String currDate, int days) {
		return getFutureDate(toDate(currDate), days);
	}

	/**
	 * 检查是否在核算期内.
	 * 
	 * @param currDate
	 *            当前时间.
	 * @param dateRange
	 *            核算期日期范围.
	 * @return 是否在核算期内.
	 * */
	public static boolean isDateInRange(String currDate, String[] dateRange) {
		if (currDate == null || dateRange == null || dateRange.length < 2) {
			throw new IllegalArgumentException("传入参数非法");
		}

		currDate = getDatePart(currDate);
		return (currDate.compareTo(dateRange[0]) >= 0 && currDate
				.compareTo(dateRange[1]) <= 0);
	}

	/**
	 * 只获取日期部分.获取日期时间型的日期部分.
	 * 
	 * @param currDate
	 *            日期[时间]型的字串.
	 * @return 日期部分的字串.
	 * */
	public static String getDatePart(String currDate) {
		if (currDate != null && currDate.length() > 10) {
			return currDate.substring(0, 10);
		}

		return currDate;
	}

	/**
	 * 计算两天的相差天数,不足一天按一天算.
	 * 
	 * @param stopDate
	 *            结束日期.
	 * @param startDate
	 *            开始日期.
	 * @return 相差天数 = 结束日期 - 开始日期.
	 * */
	public static int getDateDiff(String stopDate, String startDate) {
		long t2 = toDate(stopDate).getTime();
		long t1 = toDate(startDate).getTime();

		int diff = (int) ((t2 - t1) / ONE_DAY); // 相差天数
		// 如有剩余时间，不足一天算一天
		diff += (t2 > (t1 + diff * ONE_DAY) ? 1 : 0);
		return diff;
	}

	/**
	 * 计算两天的相差分钟,不足一分钟按一分钟算.
	 * 
	 * @param stopDate
	 *            结束日期.
	 * @param startDate
	 *            开始日期.
	 * @return 相差分钟数 = 结束日期 - 开始日期.
	 * */
	public static int getMinutesDiff(String stopDate, String startDate) {
		long t2 = toDate(stopDate).getTime();
		long t1 = toDate(startDate).getTime();

		int diff = (int) ((t2 - t1) / ONE_MINUTE); // 相差分钟数
		// 如有剩余时间，不足一天算一天
		diff += (t2 > (t1 + diff * ONE_MINUTE) ? 1 : 0);
		return diff;
	}

	/**
	 * 判断两个日期是否在同一周
	 */
	public static boolean isSameWeekDates(Date date1, Date date2) {
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal1.setFirstDayOfWeek(Calendar.MONDAY);
		cal2.setFirstDayOfWeek(Calendar.MONDAY);
		cal1.setTime(date1);
		cal2.setTime(date2);
		int subYear = cal1.get(Calendar.YEAR) - cal2.get(Calendar.YEAR);
		if (0 == subYear) {
			if (cal1.get(Calendar.WEEK_OF_YEAR) == cal2
					.get(Calendar.WEEK_OF_YEAR))
				return true;
		} else if (1 == subYear && 11 == cal2.get(Calendar.MONTH)) {
			// 如果12月的最后一周横跨来年第一周的话则最后一周即算做来年的第一周
			if (cal1.get(Calendar.WEEK_OF_YEAR) == cal2
					.get(Calendar.WEEK_OF_YEAR))
				return true;
		} else if (-1 == subYear && 11 == cal1.get(Calendar.MONTH)) {
			if (cal1.get(Calendar.WEEK_OF_YEAR) == cal2
					.get(Calendar.WEEK_OF_YEAR))
				return true;
		}
		return false;
	}

	/**
	 * 
	 * 按年获取周序号
	 * 
	 * @param currDate
	 * @return
	 */
	public static int getSeqWeekByYear(Date currDate) {
		Calendar c = Calendar.getInstance();
		c.setTime(currDate);
		c.setFirstDayOfWeek(Calendar.MONDAY);
		int weekNo = c.get(Calendar.WEEK_OF_YEAR);

		Calendar lastDate = Calendar.getInstance();

		if (weekNo == 1) {
			// 获取周五时间
			lastDate.setTime(DateUtil.toDate(getFriday(c.getTime())));
			if (c.get(Calendar.YEAR) != lastDate.get(Calendar.YEAR)) {
				lastDate.setTime(DateUtil.toDate(getMonday(c.getTime())));
				lastDate.add(Calendar.DATE, -1);
				lastDate.setFirstDayOfWeek(Calendar.MONDAY);
				weekNo = lastDate.get(Calendar.WEEK_OF_YEAR) + 1;
			}
		}
		return weekNo;
	}

	/**
	 * 
	 * 按月获取周序号
	 * 
	 * @param currDate
	 * @return
	 */
	public static int getSeqWeekByMonth(Date currDate) {
		Calendar c = Calendar.getInstance();
		c.setTime(currDate);
		c.setFirstDayOfWeek(Calendar.MONDAY);

		return c.get(Calendar.WEEK_OF_MONTH);
	}

	/**
	 * 
	 * 获取周一的日期
	 * 
	 * @param date
	 * @return
	 */
	public static String getMonday(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
	}
	/**
	 * 
	 * 获取周一的日期
	 * 
	 * @param date
	 * @return
	 */
	public static String getMonday(String date) {
		Calendar c = Calendar.getInstance();
		c.setTime(toDate(date));
		c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
	}
	/**
	 * 获得周五的日期
	 */
	public static String getFriday(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.DAY_OF_WEEK, Calendar.FRIDAY);
		return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
	}

	// 当前日期前几天或者后几天的日期
	public static String afterNDay(int n) {
		Calendar c = Calendar.getInstance();
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		c.setTime(new Date());
		c.add(Calendar.DATE, n);
		Date d2 = c.getTime();
		String s = df.format(d2);
		return s;
	}

	/**
	 * 判断某年是否为闰年
	 * 
	 * @return boolean
	 * 
	 */
	public static boolean isLeapYear(int yearNum) {
		boolean isLeep = false;
		/** 判断是否为闰年，赋值给一标识符flag */
		if ((yearNum % 4 == 0) && (yearNum % 100 != 0)) {
			isLeep = true;
		} else if (yearNum % 400 == 0) {
			isLeep = true;
		} else {
			isLeep = false;
		}
		return isLeep;
	}

	/**
	 * 计算某年某周的开始日期
	 * 
	 * @return interger
	 * 
	 */
	public static String getYearWeekFirstDay(int yearNum, int weekNum) {

		Calendar cal = Calendar.getInstance();
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		cal.set(Calendar.YEAR, yearNum);
		cal.set(Calendar.WEEK_OF_YEAR, weekNum);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		// 分别取得当前日期的年、月、日
		String tempYear = Integer.toString(yearNum);
		String tempMonth = Integer.toString(cal.get(Calendar.MONTH) + 1);
		String tempDay = Integer.toString(cal.get(Calendar.DATE));
		String tempDate = tempYear + "-" + tempMonth + "-" + tempDay;
		return SetDateFormat(tempDate, "yyyy-MM-dd");
	}

	/**
	 * @see 取得指定时间的给定格式()
	 * @return String
	 * 
	 */
	public static String SetDateFormat(String myDate, String strFormat) {

		try {
			SimpleDateFormat sdf = new SimpleDateFormat(strFormat);
			String sDate = sdf.format(sdf.parse(myDate));
			return sDate;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 计算某年某周的结束日期
	 * 
	 * @return interger
	 * 
	 */
	public String getYearWeekEndDay(int yearNum, int weekNum) {

		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, yearNum);
		cal.set(Calendar.WEEK_OF_YEAR, weekNum + 1);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		// 分别取得当前日期的年、月、日
		String tempYear = Integer.toString(yearNum);
		String tempMonth = Integer.toString(cal.get(Calendar.MONTH) + 1);
		String tempDay = Integer.toString(cal.get(Calendar.DATE));
		String tempDate = tempYear + "-" + tempMonth + "-" + tempDay;
		return SetDateFormat(tempDate, "yyyy-MM-dd");
	}

	/**
	 * 计算某年某月的开始日期
	 * 
	 * @return interger
	 * 
	 */
	public String getYearMonthFirstDay(int yearNum, int monthNum) {

		// 分别取得当前日期的年、月、日
		String tempYear = Integer.toString(yearNum);
		String tempMonth = Integer.toString(monthNum);
		String tempDay = "1";
		String tempDate = tempYear + "-" + tempMonth + "-" + tempDay;
		return SetDateFormat(tempDate, "yyyy-MM-dd");
	}

	/**
	 * 计算某年某月的结束日期
	 * 
	 * @return interger
	 * 
	 */
	public static String getYearMonthEndDay(int yearNum, int monthNum) {

		// 分别取得当前日期的年、月、日
		String tempYear = Integer.toString(yearNum);
		String tempMonth = Integer.toString(monthNum);
		String tempDay = "31";
		if (tempMonth.equals("1") || tempMonth.equals("3")
				|| tempMonth.equals("5") || tempMonth.equals("7")
				|| tempMonth.equals("8") || tempMonth.equals("10")
				|| tempMonth.equals("12")) {
			tempDay = "31";
		}
		if (tempMonth.equals("4") || tempMonth.equals("6")
				|| tempMonth.equals("9") || tempMonth.equals("11")) {
			tempDay = "30";
		}
		if (tempMonth.equals("2")) {
			if (isLeapYear(yearNum)) {
				tempDay = "29";
			} else {
				tempDay = "28";
			}
		}

		String tempDate = tempYear + "-" + tempMonth + "-" + tempDay;
		return tempDate;

	}

	/**
	 * 根据参数，获取相对日期
	 * 
	 * @param date
	 * @param flag
	 * @param intervals
	 * @return
	 */
	public static Date getRelativeDate(Date date, char flag, int intervals) {
		Date currDate = null;
		if (date != null) {
			Calendar newDate;
			(newDate = Calendar.getInstance()).setTime(date);
			switch (flag) {
			case 'y':
				newDate.add(Calendar.YEAR, intervals);
				break;
			case 'M':
				newDate.add(Calendar.MONTH, intervals);
				break;
			case 'd':
				newDate.add(Calendar.DATE, intervals);
				break;
			case 'w':
				newDate.add(Calendar.WEEK_OF_YEAR, intervals);
				break;
			case 'h':
				newDate.add(Calendar.HOUR, intervals);
				break;
			case 'm':
				newDate.add(Calendar.MINUTE, intervals);
				break;
			case 's':
				newDate.add(Calendar.SECOND, intervals);
				break;
			case 'S':
				newDate.add(Calendar.MILLISECOND, intervals);
			}
			currDate = newDate.getTime();
		}
		return currDate;
	}
	/**
	 * 获取当前日期
	 * 
	 * @return
	 */
	public static Date getCurrDay() {
		return new Date();
	}
	/**
	 * 获取下一周的第一天
	 * @return
	 */
	public static String getAfterWeekFirst(){
		return  getMonday(afterNDay(7));
	}
	/**
	 * 获取下一月的第一天
	 * @param date
	 * @param afterNum
	 * @return
	 */
	public static String getAfterMonthFirst(String date,int afterNum){
		 Calendar cal = new GregorianCalendar(); 
		 cal.setTime(toDate(date)); 
		 cal.add(Calendar.MONTH, afterNum);
		 cal.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天 
        return dateFormat.format(cal.getTime());
	}
	/**
	 * 获取周日
	 * @param date
	 * @param afterNum
	 * @return
	 */
	public static String getSundayOfWeek(String date) { 
		Calendar cal = new GregorianCalendar(); 
		cal.setFirstDayOfWeek(Calendar.MONDAY); 
		cal.setTime(toDate(date)); 
		cal.set(Calendar.DAY_OF_WEEK, cal.getFirstDayOfWeek() + 6); 
		return  dateFormat.format(cal.getTime());  
	} 
	/**
	 * 获取下一季度的第一天
	 * @param date
	 * @param afterNum
	 * @return
	 */
	public static String getAfterQuarterFirst(String date,int afterNum){
		Calendar cal = new GregorianCalendar(); 
		cal.setTime(toDate(date)); 
		int currentMonth = cal.get(Calendar.MONTH) + 1;
		cal.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天 
		if (currentMonth >= 1 && currentMonth <= 3)
			cal.set(Calendar.MONTH, 0);
		else if (currentMonth >= 4 && currentMonth <= 6)
			cal.set(Calendar.MONTH, 3);
		else if (currentMonth >= 7 && currentMonth <= 9)
			cal.set(Calendar.MONTH, 6);
		else if (currentMonth >= 10 && currentMonth <= 12)
			cal.set(Calendar.MONTH, 9);
		cal.add(Calendar.MONTH, afterNum*3);
        return  dateFormat.format(cal.getTime());  
	}
	public static void main(String[] args){
		//System.out.println(getAfterWeekFirst());
		
	    /*String[] months = DateUtil.getEveryMonthBetween("2015-03-21", "2016-03-22");
		for (String month : months) {
			System.out.println(month);
		}*/
		String[] weeks = DateUtil.getEveryWeekBetween("2013-09-01", "2016-03-22");
		for (String week : weeks) {
			System.out.println(week);
		}
	}

	public static String toDateFormate(Date date){
		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
		String time = sf.format(date);
		return time+"000000";
	}
	
	 /**
	  * 计算两个日期间隔天数
	 * @param smdate
	 * @param bdate
	 * @return
	 * @throws ParseException
	 */
	public static int daysBetween(Date smdate,Date bdate) throws ParseException    
	    {    
	        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");  
	        smdate=sdf.parse(sdf.format(smdate));  
	        bdate=sdf.parse(sdf.format(bdate));  
	        Calendar cal = Calendar.getInstance();    
	        cal.setTime(smdate);    
	        long time1 = cal.getTimeInMillis();                 
	        cal.setTime(bdate);    
	        long time2 = cal.getTimeInMillis();         
	        long between_days=(time2-time1)/(1000*3600*24);  
	            
	       return Integer.parseInt(String.valueOf(between_days));           
	    } 
	
	/**
	  * 计算两个日期间隔天数
	 * @param smdate(yyyy-MM-dd)
	 * @param bdate(yyyy-MM-dd)
	 * @return
	 * @throws ParseException
	 */
	public static int daysBetween(String smdate, String bdate) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date smdate1 = sdf.parse(smdate);
		Date bdate1 = sdf.parse(bdate);
		return daysBetween(smdate1, bdate1);
	}
	
	/**
	 * 判断时间粒度是天或时
	 * 小于等于1天按时统计，大于1天按天统计
	 * @param startDate
	 * @param endDate
	 * @return day-天，hour-时
	 */
	public static String getStaTimeType(String startDate, String endDate){
		String staTimeType = "day";
		try {
			int day = DateUtil.daysBetween(startDate, endDate);
			if(day == 0){
				staTimeType = "hour";
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return staTimeType;
	}
	
	public  static String getNowWeekBegin() {
		Calendar cal =Calendar.getInstance();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY); //获取本周一的日期
	    return df.format(cal.getTime());
	
	}
	
    public static String beforNumDay(Date date, int day) {
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.add(Calendar.DAY_OF_YEAR, day);
        return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
    }
    
    public static String getNowMonthBegin() {
    	   Calendar c = Calendar.getInstance();   
		   c.add(Calendar.MONTH, 0);
		   c.set(Calendar.DAY_OF_MONTH,1);
		   return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
    }
	
    /**
     * 获取两个日期之间所有的日期
     * @param startTime 开始时间   2016-03-20
     * @param endTime   截至日期   2016-03-22
     * @return ['2016-03-20','2016-03-21','2016-03-22']
     * @author honghui
     * @date   2016-03-21
     */
    public static String[] getEveryDayBetween(String startTime,String endTime){
    	Vector<GregorianCalendar> v=new Vector<GregorianCalendar>();  
        GregorianCalendar gc1=new GregorianCalendar(),gc2=new GregorianCalendar();  
        try {
        	gc1.setTime(dateFormat.parse(startTime)); 
			gc2.setTime(dateFormat.parse(endTime));
		} catch (ParseException e) {
			e.printStackTrace();
		}  
        do{  
            GregorianCalendar gc3=(GregorianCalendar)gc1.clone();  
            v.add(gc3);  
            gc1.add(Calendar.DAY_OF_MONTH, 1);               
        }while(!gc1.after(gc2));  
        GregorianCalendar[] calendars = v.toArray(new GregorianCalendar[v.size()]);
        String[] allDates = new String[calendars.length];
        for (int i=0; i < calendars.length;i++) {
        	String curdate = calendars[i].get(Calendar.YEAR)+"-";  
            if((calendars[i].get(Calendar.MONTH)+1)<10){  
                curdate = curdate+"0" +(calendars[i].get(Calendar.MONTH)+1)+"-";  
            }else {  
                curdate = curdate+(calendars[i].get(Calendar.MONTH)+1)+"-";  
            }  
            if(calendars[i].get(Calendar.DAY_OF_MONTH)<10){  
                curdate = curdate+"0"+calendars[i].get(Calendar.DAY_OF_MONTH);  
            }else{  
                curdate =curdate+ calendars[i].get(Calendar.DAY_OF_MONTH);  
            }
            allDates[i] = curdate;
		}
        return allDates;
    }
    
    /**
     * 获取两个日期之间所有的月份
     * @param startTime 开始时间   2016-02-20
     * @param endTime   截至日期   2016-03-22
     * @return ['2016-02','2016-03']
     * @author honghui
     * @date   2016-03-22
     */
    public static String[] getEveryMonthBetween(String startTime,String endTime){
    	List<String> months = new ArrayList<String>();
    	SimpleDateFormat monthDateFormat = new SimpleDateFormat("yyyy-MM");//格式化为年月
        Calendar start = Calendar.getInstance();
        Calendar end = Calendar.getInstance();
        try {
			start.setTime(monthDateFormat.parse(startTime));
			end.setTime(monthDateFormat.parse(endTime));
		} catch (ParseException e) {
			e.printStackTrace();
		}
        start.set(start.get(Calendar.YEAR), start.get(Calendar.MONTH), 1);
        end.set(end.get(Calendar.YEAR), end.get(Calendar.MONTH), 2);
        Calendar curr = start;
        while (curr.before(end)) {
        	months.add(monthDateFormat.format(curr.getTime()));
        	curr.add(Calendar.MONTH, 1);
        }
        return (String[])months.toArray(new String[months.size()]);
    }
    
    /**
     * 获取所有小时,若是当天，则只返回到当前时间点
     * @param dayType （today|yesterday）
     * @return
     */
    public static String[] getEveryHourBetween(String date){
    	int hour = 0;
    	if(DateUtil.getCurrDate().equals(date)){
    		hour = DateUtil.getHour() + 1;
    	}else {
    		hour = 24;
    	}
    	String[] hours = new String[hour];
    	for(int i = 0; i < hour; i++){
    		if(i < 10){
    			hours[i] = "0" + Integer.toString(i);
    		}else{
    			hours[i] = Integer.toString(i);
    		}
    	}
    	return hours;
    }
    
    
    /**
     * 获取两个日期之间所有的周  时间段处于同一年中
     * @param startTime 开始时间   2016-02-20
     * @param endTime   截至日期   2016-03-22
     * @return ['2016-02','2016-03']
     * @author honghui
     * @date   2016-03-22
     */
    public static List<String> getEveryWeekBetweenOneYear(String startTime, String endTime) { 	
    	List<String> weeks = new ArrayList<String>();
    	try { 		
    		Calendar s_c = Calendar.getInstance(); 	    
    		Calendar e_c = Calendar.getInstance(); 	    
    		Date s_time = dateFormat.parse(startTime); 	       
    		Date e_time = dateFormat.parse(endTime); 	      
    		s_c.setTime(s_time); 	    
    		e_c.setTime(e_time); 	    
    		int year = s_c.get(Calendar.YEAR); 
    		int currentWeekOfYear = s_c.get(Calendar.WEEK_OF_YEAR); 	
    		int currentWeekOfYear_e = e_c.get(Calendar.WEEK_OF_YEAR); 	   
    		if (currentWeekOfYear_e == 1) { 	
    			currentWeekOfYear_e = 53; 	   
    		} 	         	
    		int j = 12; 	       
    		for (int i=0; i < currentWeekOfYear_e; i++) { 	        
    			int dayOfWeek = e_c.get(Calendar.DAY_OF_WEEK) - 2; 	
    			e_c.add(Calendar.DATE, - dayOfWeek);       //得到本周的第一天 	              
    			//String s_date = sdf.format(e_c.getTime()); 	          
    			e_c.add(Calendar.DATE, 6);                 //得到本周的最后一天 	              	  
    			//String e_date = sdf.format(e_c.getTime()); 	         
    			e_c.add(Calendar.DATE, -j);                //减去增加的日期 	         
    			//只取两个日期之间的周 	            
    			if(currentWeekOfYear == currentWeekOfYear_e - i + 2){ 	         
    				break; 	            
    			} 	 
    			String week = (currentWeekOfYear_e - i) < 10?("0"+(currentWeekOfYear_e - i)):String.valueOf((currentWeekOfYear_e - i));
    			weeks.add(year+"-"+week);
    			//String s = year + "年的第" + (currentWeekOfYear_e - i) + "周" + "(" + s_date + "至" + e_date + ")";                
    		} 	         		
    	} catch (Exception e) { 		
    		e.printStackTrace(); 	
    	} 
    	//倒序输出
    	List<String> wks = new ArrayList<String>();
    	for (int i = weeks.size()-1; i >= 0;i--) {
			wks.add(weeks.get(i));
		}
    	return wks;
    }
    
    /**
     * 获取两个日期之间所有的周  
     * @param startTime 开始时间   2016-02-20
     * @param endTime   截至日期   2016-03-22
     * @return ['2016-02','2016-03']
     * @author honghui
     * @date   2016-03-22
     */
    public static String[] getEveryWeekBetween(String startTime, String endTime) { 	
    	List<String> weeks = new ArrayList<String>();
    	try { 		
    		Calendar s_c = Calendar.getInstance(); 	    
    		Calendar e_c = Calendar.getInstance(); 	    
    		Date s_time = dateFormat.parse(startTime); 	       
    		Date e_time = dateFormat.parse(endTime); 	      
    		s_c.setTime(s_time); 	    
    		e_c.setTime(e_time); 	    
    		int year = s_c.get(Calendar.YEAR); 
    		int endYear = e_c.get(Calendar.YEAR);
    		//时间段跨年
    		if(endYear > year){
    			do{
    				String[] currentList = DateUtil.getEveryWeekBetween(startTime, DateUtil.getYearEndDay(year));
    				weeks.addAll(Arrays.asList(currentList));
    				startTime = DateUtil.getYearFirstDay(year+1);
    				year++;
    			}while(endYear > year);
    			weeks.addAll(DateUtil.getEveryWeekBetweenOneYear(startTime, endTime));
    		}else{
    			weeks.addAll(DateUtil.getEveryWeekBetweenOneYear(startTime, endTime));
    		}
    	} catch (Exception e) { 		
    		e.printStackTrace(); 	
    	} 
    	return (String[])weeks.toArray(new String[weeks.size()]);
    }
    
    /**
     * 获取某年最后一天日期
     * @param year 年份
     * @return 最后一天日期
     * @author honghui
     * @date   2016-03-22
     */
    public static String getYearEndDay(int year){
    	Calendar calendar = Calendar.getInstance();  
        calendar.clear();  
        calendar.set(Calendar.YEAR, year);  
        calendar.roll(Calendar.DAY_OF_YEAR, -1);  
        Date currYearLast = calendar.getTime();  
        return dateFormat.format(currYearLast);
    }
    
    /**
     * 获取某年第一天日期
     * @param year 年份
     * @return 第一天日期
     * @author honghui
     * @date   2016-03-22
     */
    public static String getYearFirstDay(int year){
    	 Calendar calendar = Calendar.getInstance();  
         calendar.clear();  
         calendar.set(Calendar.YEAR, year);  
         Date currYearFirst = calendar.getTime();  
         return dateFormat.format(currYearFirst);
    }
    
}
