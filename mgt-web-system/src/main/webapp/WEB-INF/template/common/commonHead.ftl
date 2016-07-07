<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/base.css" />
	<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/main.css" />
	<link href="${base}/scripts/lib/plugins/jqgrid/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="${base}/scripts/lib/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<link rel="stylesheet" href="${base}/styles/function/mgt/mgt_core.css" type="text/css">
	<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/global.css" />
	<link rel="stylesheet"  href="${base}/styles/function/mgt/jquery.autocomplete.css" type="text/css"></link>
   	<style>
	body {
		*margin: 0;
		*padding: 0;
	}
	</style>
	
    
	<script src="${base}/scripts/lib/jquery/js/jquery-1.8.3.min.js" ></script>
   	<!-- 包空间 -->
	<script type="text/javascript"src="${base}/scripts/lib/plugins/js/Yhxutil.js"></script>  
	<script src="${base}/scripts/lib/plugins/jquery-datepicker/jquerydatepicker.js" ></script>
	<script src="${base}/scripts/lib/plugins/js/main.js" ></script>
	<script src="${base}/scripts/lib/plugins/bootstrap/js/bootstrap.js" ></script>
	<script src="${base}/scripts/lib/plugins/bootstrap/js/bootbox.js" ></script>
	<script src="${base}/scripts/lib/plugins/jbox/jquery.jBox-2.3.min.js" ></script>
	<script src="${base}/scripts/lib/jquery/js/jquery.form.min.js" ></script>
	<script src="${base}/scripts/lib/jquery/jquery-form.js" ></script>
    <!-- jquery.jqGrid.src.js -->   
	<script src="${base}/scripts/lib/plugins/jqgrid/js/i18n/grid.locale-cn.js" type="text/javascript"></script>
	<script src="${base}/scripts/lib/plugins/jqgrid/js/jquery.jqGrid.src.js" type="text/javascript"></script>
	<!-- 公用util -->
	<script src="${base}/scripts/function/mgt/mgt_core.js" type="text/javascript"></script>
	<script src="${base}/scripts/function/mgt/mgt_constant.js" type="text/javascript"></script>
	<script src="${base}/scripts/function/mgt/mgt_util.js" type="text/javascript"></script>
	<script src="${base}/scripts/function/mgt/jquery.lSelect.js" type="text/javascript"></script>
	<!-- jquery-validate-->
	<script src="${base}/scripts/lib/plugins/jquery-validation/jquery.validate.js" type="text/javascript"></script>
	<script src="${base}/scripts/lib/plugins/jquery-validation/jquery.metadata.js" type="text/javascript"></script>
	<script src="${base}/scripts/lib/plugins/jquery-validation/jquery.validate.method.js" type="text/javascript"></script>
	<script type="text/javascript"src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
	<!-- 图片轮换-->
  	<script src="${base}/scripts/function/mgt/slides.min.jquery.js" type="text/javascript"></script>
  	<script src="${base}/scripts/function/mgt/jquery.autocomplete.min.js" type="text/javascript"></script>
	<script>
     $(document).ready(function(){
	  if('${resourceItems}'!=''){
		    var resourceList={}
		    [#list resourceItems as resourceItem]
		    	resourceList['${resourceItem.VALUE}']='${resourceItem.NAME}';
		    [/#list]
		    //alert(resourceList[0]);
			var btns=$(".form-group").find("button[id!='']");
			for(var i=0;i<btns.length;i++){
			    //alert(btns[i].id);
				if(null==resourceList[btns[i].id]){
					$(btns[i]).remove();
				}
			}

		  	//右键权限过滤	
		    var lis=$(".ul-right-group").find("li[id!='']");
		   	for(var i=0;i<lis.length;i++){
		   		if(null==resourceList[lis[i].id]){
		   			$(lis[i]).remove();
		   			}
		   	}
		}
   		
     	Date.prototype.format = function(format){
		    var o = {
		        "M+" : this.getMonth()+1, //month
		        "d+" : this.getDate(),    //day
		        "h+" : this.getHours(),   //hour
		        "m+" : this.getMinutes(), //minute
		        "s+" : this.getSeconds(), //second
		        "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
		        "S" : this.getMilliseconds() //millisecond
		    }
		    if(/(y+)/.test(format))
		    format=format.replace(RegExp.$1,(this.getFullYear()+"").substr(4 - RegExp.$1.length));
		    for(var k in o)
		    if(new RegExp("("+ k +")").test(format))
		    format = format.replace(RegExp.$1,RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
		    return format;
		};
		String.prototype.startsWith = function(str){
			return (this.match("^"+str)==str)
		}
    });
    
     function formatCurrency(num) {
					    num = num.toString().replace(/\$|\,/g,'');
					    if(isNaN(num))
					    num = "0";
					    sign = (num == (num = Math.abs(num)));
					    num = Math.floor(num*100+0.50000000001);
					    cents = num%100;
					    num = Math.floor(num/100).toString();
					    if(cents<10)
					    cents = "0" + cents;
					    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
					    num = num.substring(0,num.length-(4*i+3))+
					    num.substring(num.length-(4*i+3));
					    return (((sign)?'':'-') + num + '.' + cents);
						}
    </script>