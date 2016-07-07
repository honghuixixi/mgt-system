<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-员工信息配置</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
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
			var cache = 0;
			function tabHeight(aDynamicH){
				var aaa = $(".main_heightBox1").height();
				var bbb = $(window).height();
				var ccc = bbb-aaa-125;
				var ddd = bbb-40-38;
				$(".ui-jqgrid-bdiv").css("height",ccc);
				$(".aaab").css("height",ddd);
				$(".ui-jqgrid-hdiv").css("padding-right","17px");
				if( cache <= aDynamicH ){
					$(".ui-jqgrid-hdiv").css("padding-right","0");
					$(".aaab").css("width","193px");
				}else{
					$(".ui-jqgrid-hdiv").css("padding-right","17px");
					$(".aaab").css("width","176px");
				}
				
			}
			$(window).resize(function() {
			    tabHeight($(".ui-jqgrid-bdiv").height());
			});
			
			$(window).scroll(function() {
			    tabHeight($(".ui-jqgrid-bdiv").height());
			})
			$(window).click(function() {
			    tabHeight($(".ui-jqgrid-bdiv").height());
			});


			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/employee/employeeList.jhtml',
 					colNames:['','','用户编号','用户真实姓名','销售员','配送员','拣货员' ],
 					sortable:true,
					rownumWidth : 40,
					rownumbers : false,
					multiselect : false,
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'ACCOUNT_NAME',hidden:true},
				   		{name:'USER_CODE',width:80},
				   		{name:'USER_NAME',width:120,align:"center",editable:true},
				   		{name:'SALESMEN_FLG',width:80,align:"center",editable:true,formatter:function(data){
									if(data=='Y'){return data;}
								return '';
								}},
				   		{name:'LOGISTICS_PROVIDER_FLG',width:60,align:"center",editable:true,formatter:function(data){if(data=='Y'){return data;}
						return '';
						}},{name:'PICK_FLG',width:80,align:"center",editable:true,formatter:function(data){
							if(data=='Y'){return data;}
							return '';
							}}
 
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
		</script>
    </head>
    <body >
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="student">
	             <div class="form_divBox" style="display:block;padding-left:194px;padding-right:0;padding-top:40px;">   
		            <form class="form form-inline queryForm label_Tleft"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label" style="width:60px;">人员姓名</label>
		                    <input type="text" class="form-control" id="aaa" name="userName" maxlength="60" style="width:120px;"  >
		                </div>
		                   <div class="form-group">
						<input class="form-control required"  type="radio" id="empType01" name="empTypes" value="">
						<label class="control-label" for="type01" style="width: 30px;">全部</label>
						
						<input class="form-control required"  type="radio" id="empType02" name="empTypes" value="1">
						<label class="control-label" for="type02" style="width: 50px;">销售员</label>
						
						<input class="form-control required"  type="radio" id="empType03" name="empTypes" value="2">
						<label class="control-label" for="type03" style="width: 50px;">配送员</label>
						
						<input class="form-control required"  type="radio" id="empType04" name="empTypes" value="3">
						<label class="control-label" for="type04" style="width: 50px;">拣货员</label>
						
						 
		                </div>
		            </form>
	            </div>
	            <div class="search_cBox">
	               <div class="form-group">   
		                <button type="button" class="search_cBox_btn" id=""  data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </div>
	        </div>
	      </div>    

        <div class="content_wrap">
        	<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
				    <td valign="top" width="192" >
				    	<div class="aaab" style="position:absolute;top:40px;left:0;width:176px;height:48px;border-right:solid 1px #e1e1e1;"></div>
	    				<div class="zTreeDemoBackground left"  style="float:left;width:150px;position:relative;top:-38px;left:0;">
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