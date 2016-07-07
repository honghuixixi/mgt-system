<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-员工信息配置</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/index.css" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>
		<style type="text/css">
			div#rMenu {position:absolute; visibility:hidden; top:5px;left:0;text-align: left;width:150px;height:70px;padding: 2px;}
			div#rMenu ul li{
				margin: 1px 0;
				padding: 0 5px;
				margin-left:-40px;
				cursor: pointer;
				list-style: none outside none;
				background-color: #DFDFDF;
			}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
				
				//默认当天时间
		    	$("#todayDiv").css({"background-color":"#C2DFF7","border-radius":"5px"});
		    	$("#startDate").val(GetDateStr(0));
				$("#endDate").val(GetDateStr(0));
				$("#dateKind").val($("#todayDiv").find("div").attr("date"));
				//时间切换
				$("#currentDataDiv .form-group ").click(function() {
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

				$(".currentDataDiv_tit").css("width",$(window).width()-192);
			    $(".time_li input").click(function() {
				    $(".form-group").each(function(){
						$(this).siblings("div").css("background-color","");
						$("#dateKind").val("");
					});
				 });
			    
				mgt_util.jqGrid('#grid-table',{
					postData:{
						dateKind:$("#dateKind").val(),
		       			startDate:$("#startDate").val(),
		       			endDate:$("#endDate").val()
					},
					url:'${base}/custVisit/statistis.jhtml',
 					colNames:['','姓名','拜访次数','位置偏差异常次数'],
 					sortable:true,
 					multiselect:false,
				   	colModel:[
				   		{name:'USER_NO',index:'USER_NO',width:0,hidden:true,key:true},
				   		{name:'NAME',width:'20'},
				   		{name:'VISIT_COUNT', width:'30',editable:true},
				   		{name:'EXCEPTION_COUNT',width:'30',align:"center",editable:true},
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
				

				$("#searchbtn").click(function(){
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			
			//grid重新加载
	        function jqGridReload(){
	        	var postData={
	        			dateKind:$("#dateKind").val(),
		       			startDate:$("#startDate").val(),
		       			endDate:$("#endDate").val()
	            	};
	        	$("#grid-table").jqGrid('setGridParam',{  
			        datatype:'json',  
			        postData:postData, //发送数据  
			        page:1  
			    }).trigger("reloadGrid"); //重新载入  
	        	$("#endDate").blur();
				$("#startDate").blur();
	        }
			
	        function expAttStatStart() {
	            var _cols = getColProperties("grid-table");
	            var _colNames=$("#grid-table").jqGrid('getGridParam','colNames');
	            var colNames = (_colNames.slice(2,_colNames.length)).toString();
	            var cols = ( _cols.split(",").slice(0, _cols.split(",").length-1)).toString();
	            var data = $("#grid-table").jqGrid('getGridParam','postData');
	            /* var ext = {cols:cols,colNames:colNames};
	        	for(var r in ext){
	        	   eval("data."+r+"=ext."+r);
	        	} */
	        	if(typeof(data.departId) == "undefined"){
	        		data.departId = "";
	        	}
	        	window.location.href = "${base}/custVisit/custVisitStatictisExport.jhtml?cols="+cols+"&colNames="+encodeURI(encodeURI(colNames))+"&startDate="+data.startDate+"&endDate="+data.endDate+
	        			"&dateKind="+data.dateKind+"&departId="+data.departId;
	            
	            /* $.ajax({
					url:'${base}/custVisit/custVisitStatictisExport.jhtml',
					sync:false,
					type : 'post',
					data :data,
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
				}); */
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
	        	<div id="currentDataDiv" action="student">
	        		<div class="currentDataDiv_tit" style="margin-left:192px;font-size:5;">拜访统计：</div> 
		            <div class="form_divBox" style="display:block;padding-left:195px;">
		            	<form class="form form-inline queryForm"  id="query-form">    
			                 <div class="form-group" style="margin-right:10px;padding-left:10px;padding-top:0px;">
			           		   <button type="button" class="search_cBox_btn btn btn-info" id="order_search"  onclick="expAttStatStart()"> 导出 </button>
			               	 </div>
			           		 <div id="todayDiv" class="form-group" style="margin-right:5px;">
			           			 <label class="control-label" style="width:35px;">今日</label>
			                     <div name="Today" date="Today"></div>
			               	 </div>
			           		 <div class="form-group" style="margin-right:5px;">
			           			 <label class="control-label" style="width:35px;">昨日</label>
			                    <div name="Yesterday" date="Yesterday"></div>
			               	 </div>
			           		 <div class="form-group" style="margin-right:5px;">
			           			 <label class="control-label" style="width:35px;">本周</label>
			                    <div name="ThisWeek" date="ThisWeek" ></div>
			               	 </div>
			           		 <div class="form-group" style="margin-right:5px;">
			           			 <label class="control-label" style="width:35px;">本月</label>
			                    <div name="ThisMonth" date="ThisMonth"></div>
			               	 </div>
			           		 <div class="form-group" style="margin-right:5px;">
			           			 <label class="control-label" style="width:53px;">最近7日</label>
			                    <div name="LastSevenDays" date="LastSevenDays"></div>
			               	 </div>
			           		 <div class="form-group" style="margin-right:5px;">
			           			 <label class="control-label" style="width:53px;">最近30日</label>
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
	        	</div>
			</div>
			<div class="content_wrap">
		        	<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
						    <td valign="top" width="192" >
						    	<div class="aaab" style="position:absolute;top:0px;left:0;width:180px;height:48px;border-right:solid 1px #e1e1e1;"></div>
			    				<div class="zTreeDemoBackground left"  style="float:left;width:192px;position:relative;top:-80px;left:-15px;">
									<ul id="treeDemo" class="ztree" style=" margin-top:0px;"></ul>
								</div>
					    	</td>
						    <td valign="top" width="auto">
			    				<div id="pos_fixR">
									<ul class="info" >
										<table id="grid-table" ></table>
										<div id="grid-pager" class="grid-pager" align="right"></div>
									</ul>
								</div>
						    </td>
						</tr>
					</table>
			</div>
	    </div>
    </body>
	<SCRIPT type="text/javascript">
		var datas = {
			id:'ids',	name:'names'
		}
	    var param = {
	    	url:'${base}/department/deptList.jhtml',
	    	data:datas
	    }
	   Yhxutil.org.doInit(param);
	</SCRIPT>
</html>