<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统异常维护管理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
					mgt_util.jqGrid('#grid-table',{
						url:'${base}/errorLog/errorLogList.jhtml',
	 					colNames:['','错误等级','非定义','描述','状态','创建时间','处理人','解决时间','处理结果','操作'],
					   	colModel:[
					   		{name:'ERROR_CODE',index:'ERROR_CODE',width:0,hidden:true,key:true},
					   		{name:'GRADE',width:100,editable:true,formatter:function(data){
									if(data==1){
										return '一般';
									} 
									if(data==2){
										return '严重';
									}
						   	}},
						   	{name:'APP_CODE',width:100,editable:true},
						   	{name:'DESCRIPTION',width:200,editable:true},
						   	{name:'STATUS_FLG',width:100,editable:true,formatter:function(data){
								if(data==1){
									return '创建';
								} 
								if(data==2){
									return '已处理';
								}
					     	}},
					     	{name:'CREATE_DATE',width:165,formatter : function(data){
	                            if(!isNaN(data) && data){
		                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
		                            }
		                            return data;
		                    }},
					     	{name:'USER_NAME',width:150,formatter : function(data){
	                            if(data == null)
		                            return "    --";
	                            return data;
		                      }},
					     	{name:'WORK_DATE',width:200,formatter : function(data){
	                            if(!isNaN(data) && data){
		                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
		                            }
	                            if(data == null){
									return "    --";
		                         }
		                            return data;
		                      }},	
					     	{name:'WORK_RESULT',width:150,formatter : function(data){
	                            if(data == null)
		                            return "    --";
	                            return data;
		                      }},	
					     	{name:'detail',index:'ERROR_CODE',width:80,align:'center',sortable:false}			   	
					   	],
					   	gridComplete:function(){ 
							var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
							for(var i=0; i<ids.length; i++){ 
								var id=ids[i]; 
								var rowData = $('#grid-table').jqGrid('getRowData',id);
								if (rowData.STATUS_FLG == '已处理') {
									detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/errorLog/errorLogDetail.jhtml'> 查看 </button>";
									jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
								}
								if (rowData.STATUS_FLG == '创建') {
									detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' jBox-width='1212' jBox-height='560' href='${base}/errorLog/errorLogDetail.jhtml'> 处理 </button>";
									jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
								};
								//table数据高度计算
								cache=$(".ui-jqgrid-bdivFind").height();
								tabHeight($(".ui-jqgrid-bdiv").height());
								
							} 
						} 
					
					});
	
			});
		</script>
		
		
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
		       <div id="currentDataDiv" action="resource">
			       <div class="form_divBox" style="display:block">
				       <form class="form form-inline queryForm" style="width:1000px" id="query-form"> 
			       			<div class="form-group">
			                    <label class="control-label">错误等级</label>
			                    <select class="form-control" name="grade">
			                   	    <option value="">全部</option>
			                        <option value="1">一般</option>
			                        <option value="2">严重</option>
			                    </select>
			                </div>
			       			<div class="form-group">
			                    <label class="control-label">操作类型</label>
			                    <select class="form-control" name="appCode">
			                  	    <option value="">全部</option>
			                        <option value="1">订单</option>
			                        <option value="2">支付</option>
			                    </select>
			                </div>
			       			<div class="form-group">
			                    <label class="control-label">状态</label>
			                    <select class="form-control" name="statusFlg">
			                  	    <option value="">全部</option>
			                        <option value="1">创建</option>
			                        <option value="2">已处理</option>
			                    </select>
			                </div>
			                <div class="form-group">
			                    <label class="control-label">描述</label>
			                    <input type="text" class="form-control" name="description" id="description" style="width:120px;" >
			                </div>
			                <div class="search_cBox">
				                <div class="form-group">
				                 	<button type="button" class="search_cBox_btn" id='resource_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
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