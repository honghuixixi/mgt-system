<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>登陆日志查询</title>
		[#include "/common/commonHead.ftl" /]		
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />		
		<script  type="text/javascript">
			var format = function(time, format){
			    var t = new Date(time);
			    var tf = function(i){return (i < 10 ? '0' : '') + i};
			    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){
			        switch(a){
			            case 'yyyy':
			                return tf(t.getFullYear());
			                break;
			            case 'MM':
			                return tf(t.getMonth() + 1);
			                break;
			            case 'mm':
			                return tf(t.getMinutes());
			                break;
			            case 'dd':
			                return tf(t.getDate());
			                break;
			            case 'HH':
			                return tf(t.getHours());
			                break;
			            case 'ss':
			                return tf(t.getSeconds());
			                break;
			        }
			    })
			}
				
			$(document).ready(function(){
				getMonth();
				var startDate = $("input[name='startDate']").val();
			    var endDate = $("input[name='endDate']").val();
			        
				mgt_util.jqGrid('#grid-table',{
					multiselect:false,
					url:'${base}/log/loginInfoList.jhtml',
					postData: {startDate:startDate,endDate:endDate},
 					colNames:['','用户ID','用户名','行动日期','行动代码','行动名称','客户端IP','机器名称','客户端信息','浏览器信息'],
 					width:'100%',
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'USER_NO',width:'5%',align:"center"},
				   		{name:'USER_NAME',width:'8%',align:"center"},
				   		{name:'ACTION_DATE',width:'13%',align:"center",formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd hh:mm:ss');
						}},
				   		{name:'ACTION_CODE',width:'6%',align:"center"},
	   		            {name:'ACTION_NAME', width:'6%',align:"center"},
	   		            {name:'IP_ADDRESS', width:'15%',align:"center"},
	   		            {name:'MACHINE_NAME', width:'13%',sortable:false},
	   		            {name:'CLIENT_INFO', width:'12%',sortable:false},
	   		            {name:'BROWSER_INFO', width:'22%',sortable:false}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				});
				

				$("#loginlog_search").live('click',function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//mgt_util.showMask('正在查询，请稍等...');
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
				
				
				// 默认查询前一个月日志
				function getMonth(){
					var date=new Date();//今天
					date.setHours(23);
					date.setMinutes(59);
					var s = format(date.getTime(), 'yyyy-MM-dd HH:mm');
					$("#endDate").val(format(date.getTime(), 'yyyy-MM-dd HH:mm'));
					date.setDate(1);//当前月的第一天
					date.setHours(0);
					date.setMinutes(0);
					$("#startDate").val(format(date.getTime(), 'yyyy-MM-dd HH:mm'));
					$("#loginlog_search").click();
				}
		
			});
		</script>
    </head>
    <body>
	       	
       <div class="body-container">
       	 <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">用户名</label>
		                    <input type="text" class="form-control" name="user_name" id="user_name" style="width:110px;" placeholder="输入用户名查询">
		                </div>
		                <!--
			                <div class="form-group">
			                    <label class="control-label">中文名</label>
			                    <input type="text" class="form-control" name="name" id="name" style="width:90px;" >
			                </div>  
		                -->
		                 <div class="form-group">
		                    <label class="control-label">行动日期</label>
		                    <input type="text" class="form-control" name="startDate" id="startDate" style="width:120px;"  onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',readOnly:true})">
		               		~
		               		<input type="text" class="form-control" name="endDate" id="endDate" style="width:120px;"   onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',minDate:'#F{$dp.$D(\'startDate\')}',readOnly:true})">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">行动名称</label>
		                    <select class="form-control" name="actionCode" id="actionCode">
		                        <option value="">全部</option>
		                        <option value="LOGIN">登录</option>
		                        <option value='LOGOUT'>退出</option>
		                    </select>
		                </div>
		                <div class="search_cBox">
		                	<div class="form-group">
				               <button type="button" class="search_cBox_btn btn btn-info" id="loginlog_search"  data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
				            </div>
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
