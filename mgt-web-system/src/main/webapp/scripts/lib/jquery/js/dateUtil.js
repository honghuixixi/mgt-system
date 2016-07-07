function GetDateStr(AddDayCount) {
	var dd = new Date();
	dd.setDate(dd.getDate()+AddDayCount);
	var y = dd.getFullYear();
	var m = dd.getMonth()+1;
	var d = dd.getDate();
	return y+"-"+m+"-"+d;
}

function GetDateStr2(AddDayCount) 
{ 
	debugger;
	var dd = new Date(); 
	dd.setDate(dd.getDate()+AddDayCount);
	var y = dd.getYear(); 
	var m = (dd.getMonth()+1)<10?"0"+(dd.getMonth()+1):(dd.getMonth()+1);
	var d = dd.getDate()<10?"0"+dd.getDate():dd.getDate(); 
	return y+"-"+m+"-"+d; 
}



//获得本周的开端日期
var now = new Date(); 
var nowDayOfWeek = now.getDay(); 
var nowDay = now.getDate(); 
var nowMonth = now.getMonth(); 
var nowYear = now.getYear(); 
nowYear += (nowYear < 2000) ? 1900 : 0; 

var lastMonthDate = new Date();
lastMonthDate.setDate(1);
lastMonthDate.setMonth(lastMonthDate.getMonth()-1);
var lastYear = lastMonthDate.getYear();
var lastMonth = lastMonthDate.getMonth(); 
function getWeekStartDate() {
	var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek + 1);
	return formatDate(weekStartDate);
} 

//格局化日期：yyyy-MM-dd
function formatDate(date) {
	var myyear = date.getFullYear();
	var mymonth = date.getMonth()+1;
	var myweekday = date.getDate();
	
	if(mymonth < 10){
	mymonth =  mymonth;
	}
	if(myweekday < 10){
	myweekday = myweekday;
	}
	return (myyear+"-"+mymonth + "-" + myweekday);
} 
//获得本月的开端日期
function getMonthStartDate(){
	var monthStartDate = new Date(nowYear, nowMonth, 1);
	return formatDate(monthStartDate);
} 
