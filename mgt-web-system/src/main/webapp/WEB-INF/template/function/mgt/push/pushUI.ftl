<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>百度云推送管理</title>
		[#include "/common/commonHead.ftl" /]
        <link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" src="${base}/scripts/lib/DatePicker/WdatePicker.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/push/list.jhtml',
 					colNames:['','发送时间','消息内容','客户端','发送人数','用户范围'],
 					width:999,
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'SEND_TIME',align:"center",width:100},
				   		{name:'TITLE',align:"center",width:80},
				   		{name:'DEVICE_TYPE',align:"center",width:80},
				   		{name:'RESULT',align:"center",width:100},
				   		{name:'USER_RANGE',align:"center",width:100}
				   	]
				});
				
			});
		</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="menu">
	            <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
	                
	                <div class="form-group">
	                    <label class="control-label">用户范围</label>
	                    <select class="form-control" name="userRange">
	                        <option value="">全部</option>
	                        <option value="1">所有人</option>
	                        <option value='2'>特定用户</option>
	                    </select>
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info" id="push_search" data-toggle="jBox-query" href="${base}/complaint/list.jhtml"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info add" id="push_add" data-toggle="jBox-win" href="${base}/push/addPushUI.jhtml"> 添加 </button>
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn btn-info del"  id="push_delete" data-toggle="jBox-remove-role" href="${base}/push/delete.jhtml">删除 </button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table" >
		    </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
</html>