<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
         [#include "/common/commonHead.ftl" /]
       	<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
       <link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
	   	<script  type="text/javascript">
	 	//chosen插件初始化，绑定元素
		$(function(){
   			$("#user_no").chosen();
   			$("#detp_id").chosen();
		});	
	    $(document).ready(function(){
	    	//默认当天时间
	    	$("#todayDiv").css({"background-color":"#C2DFF7","border-radius":"5px"});
	    	$("#startDate").val(GetDateStr(0));
			$("#endDate").val(GetDateStr(0));
			$("#dateKind").val($("#todayDiv").find("div").attr("date"));
			//时间切换
			$(".currentDataDiv_tit .form-group ").click(function() {
				var $str = $(this).find("div").attr("name");
				if ($str == "Today" 
						|| $str == "Yesterday"
						|| $str == "ThisWeek"
						|| $str == "ThisMonth"
						|| $str == "LastSevenDays"
						|| $str == "LastThirty" ) {
					$(this).siblings("div").css("background-color","");
					$(this).css({"background-color":"#C2DFF7","border-radius":"5px"});
					$("#startDate").val("");
					$("#endDate").val("");
					var str = $(this).find("div").attr("date");
					$("#dateKind").val(str);
					switch($str){
						case "Today":
						  $("#startDate").val(GetDateStr(0));
						  $("#endDate").val(GetDateStr(0));
						  break;
						case "Yesterday":
							$("#startDate").val(GetDateStr(-1));
							$("#endDate").val(GetDateStr(-1));
						  break;
						case "ThisWeek":
							$("#startDate").val(getWeekStartDate());
							$("#endDate").val(GetDateStr(0));
						  break;
						case "ThisMonth":
							$("#startDate").val(getMonthStartDate());
							$("#endDate").val(GetDateStr(0));
						  break;
						case "LastSevenDays":
							$("#startDate").val(GetDateStr(-7));
							$("#endDate").val(GetDateStr(0));
						  break;
						case "LastThirty":
							$("#startDate").val(GetDateStr(-30));
							$("#endDate").val(GetDateStr(0));
						  break;
						default:
							null;
					};
					//重新加载
					jqGridReload();
				} 
		    });

		    $(".time_li input").click(function() {
			    $(".form-group").each(function(){
					$(this).siblings("div").css("background-color","");
					$("#dateKind").val("");
				});
			 });
		    
		    $("#exception").click(function(){
		    	jqGridReload();
		    });
		    $("#detp_id").live('change',function(){
		    	jqGridReload();
		    });
		    $("#user_no").live('change',function(){
		    	jqGridReload();
		    });
			
		    postRecordData();
		    
		});
	    
	    function showBox(url){
	    	 mgt_util.showjBox({
	 			width : 350,
	 			height : 350,
	 			title : '查看照片',
	 			url : url,
	 			grid : $('#grid-table')
	 		});
	    }
        
        //grid重新加载
        function jqGridReload(){
        	var postData={
           			orderby:"CREATE_DATE",
           			dateKind:$("#dateKind").val(),
           			startDate:$("#startDate").val(),
           			endDate:$("#endDate").val(),
           			user_no:$("#user_no").val(),
           			detp_id:$("#detp_id").val(),
           			exception:$('#exception').is(':checked')
            	};
        	$("#grid-table").jqGrid('setGridParam',{  
		        datatype:'json',  
		        postData:postData, //发送数据  
		        page:1  
		    }).trigger("reloadGrid"); //重新载入  
        	$("#endDate").blur();
			$("#startDate").blur();
        }
        
        //获取拜访记录数据
        function postRecordData(){
        	var postData={
       			orderby:"CREATE_DATE",
       			dateKind:$("#dateKind").val(),
       			startDate:$("#startDate").val(),
       			endDate:$("#endDate").val(),
       			user_no:$("#user_no").val(),
       			dept_id:$("#dept_id").val(),
       			exception:$('#exception').is(':checked')
        	};
        	var colNames = ['','拜访时间','拜访人部门','拜访人','拜访客户','拜访位置','位置偏差/米','拜访内容','照片查看'];
        	mgt_util.jqGrid('#grid-table',{
        		postData:postData,
        		url:'${base}/custVisit/recordList.jhtml',
        		colNames:colNames,
        		multiselect:false,
        		colModel:[
					{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
					{name:'CREATE_DATE',align:"center",index:'CREATE_DATE',width:'4',key:true},
					{name:'DEPT_NAME',align:"center",index:'DEPT_NAME',width:'7',key:true},
					{name:'VISITOR_NAME',align:"center",index:'VISITOR_NAME',width:'4',key:true},
					{name:'CUST_NAME',align:"center",index:'CUST_NAME',width:'5',key:true},
					{name:'VISIT_LOCATION',align:"center",index:'VISIT_LOCATION',width:'9',key:true},
					{name:'LOCATION_OFFSET',align:"center",index:'LOCATION_OFFSET',width:'4',key:true},
					{name:'VISIT_CONTENT',align:"center",index:'VISIT_CONTENT',width:'9',key:true},
					{name:'PIC_URL',align:"center",editable:true,width:'5',formatter:function(value,row,index){
						if(value){
							return '<button type="button" class="btn btn-info edit" onClick=showBox("'+value+'")>查看图片 </button>';
						}else{
							return "";
						}
					}}
        		],
        		gridComplete:function(){
        			//table数据高度计算
					cache=$(".ui-jqgrid-bdivFind").height();
					tabHeight($(".ui-jqgrid-bdiv").height());
        		}
        	});
        }
        
        function expAttStatStart() {
            var _cols = getColProperties("grid-table");
            var _colNames=$("#grid-table").jqGrid('getGridParam','colNames');
            var colNames = (_colNames.slice(2,_colNames.length-1)).toString();
            var cols = ( _cols.split(",").slice(0, _cols.split(",").length-2)).toString();
            window.location.href = "${base}/custVisit/custVisitExport.jhtml?cols="+cols+"&colNames="+encodeURI(encodeURI(colNames))+"&startDate="+$('#startDate').val()+
            		"&endDate="+$('#endDate').val()+"&dateKind="+$('#dateKind').val()+"&exception="+$('#exception').is(':checked');
            /* $.ajax({
				url:'${base}/custVisit/custVisitExport.jhtml',
				sync:false,
				type : 'post',
				data :{
					'startDate':$('#startDate').val(),
					'endDate':$('#endDate').val(),
					'cols':cols,
					'colNames':colNames
				},
				dataType : "json",
				error : function(data) {
					top.$.jBox.tip("网络异常，稍后执行本次操作.");
					return false;
				},
				success : function(data) {
					if (data.code == '002') {
 					 top.$.jBox.tip(data.msg);
					} 
					if (data.code == '001') {
						top.$.jBox.tip(data.msg);
				    }
				}
			});  */
        }
        function getColProperties(id) {
            var b = jQuery("#"+id)[0];
	    	var params = b.p.colModel;
	    	
	    	var cols = "";
	    	for ( var i = 2; i < params.length; i++) {
	        	cols +=  params[i].name+",";
	        }
	        return cols
        } 
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
       		<div id="currentDataDiv" action="menu" >
       			<div class="currentDataDiv_tit" style="height:55px;">
       				<form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form"> 
		                 <div class="form-group" style="margin-right:10px;padding-left:10px;padding-top:8px;">
		           		   <button type="button" class="search_cBox_btn btn btn-info" id="order_search"  onclick="expAttStatStart()"> 导出 </button>
		               	 </div>
		           		 <div id="todayDiv" class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">今日</label>
		                     <div name="Today" date="Today"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">昨日</label>
		                    <div name="Yesterday" date="Yesterday"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">本周</label>
		                    <div name="ThisWeek" date="ThisWeek" ></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">本月</label>
		                    <div name="ThisMonth" date="ThisMonth"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">最近7日</label>
		                    <div name="LastSevenDays" date="LastSevenDays"></div>
		               	 </div>
		           		 <div class="form-group" style="margin-right:5px;">
		           			 <label class="control-label">最近30日</label>
		                    <div name="LastThirty" date="LastThirty"></div>
		                   
		               	 </div>
		               	 <input type="hidden"  id="dateKind" name="dateKind" value="">
		                 <div class="form-group">
		                 	<div name="start_end" style="display:none;"></div>
		                 	<li class="time_li">
		                 		<input type="text" class="form-control" name="startDate" id="startDate" style="width:90px;" value="${startDate}">
				                <span class="control-label">~</span>
				                <input type="text" class="form-control" name="endDate" id="endDate" style="width:90px;" value="${endDate}" >
				            	<script type="text/javascript"> 
								$(function(){
							         $("#startDate").bind("click",function(){
							             WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,maxDate:'#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}',onpicked:function(){endDate.click();}});
							         });
							         $("#endDate").bind("click",function(){
							             WdatePicker({doubleCalendar:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked: jqGridReload});
							         });
								});
								</script>
				            </li>
		                 </div>
		            </form>
       			</div>
	        	<div class="form_divBox" style="display:block;overflow:inherit;">
	        		<form class="form form-inline queryForm" id="query-form"> 
	        			<label style="width:80px;">拜访人:</label>
	        			<div class="form-group" style="margin-top:11px;">
		                   <select class="form-control required" id="user_no" name="user_no" style="width:120px;">
								<option value="">全部</option>
								[#if users ??]
							        [#list users as user]
				                          <option value='${user.userNo}'>${user.name}</option>
									[/#list]
								[/#if]
							</select>
		                </div>
		                <label style="width:80px;">拜访部门:</label>
		                <div class="form-group" style="margin-top:11px;">
		                   <select class="form-control required" id="detp_id" name="detp_id" style="width:120px;">
								<option value="">全部</option>
								[#if depts ??]
						         [#list depts as dept]
			                          <option value='${dept.id}'>${dept.name}</option>
								[/#list]
							[/#if]
							</select>
		                </div>
		                <label style="width:20px;"></label>
		                <div class="form-group" style="margin-top:8px;">
		                   <input type="checkbox" id="exception" name="exception"/>异常拜访
		                </div>
	        		</form>
	        	</div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>
 



