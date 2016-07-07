<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>店铺地标审核</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE",statusFlg:"S"};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/address/landMarkMasList.jhtml',
 					colNames:['','用户名','店铺名称','地标','店铺至地标的距离','承诺配送时间','状态','申请日期','审核日期','创建日期','审核意见','操作'],
				   	colModel:[
				  	 	{name:'PK_NO',index:'PK_NO',width:10,hidden:true,key:true},
				   		{name:'USER_NAME',align:"center",width:30},
				   		{name:'NAME',align:"center",width:50},
				   		{name:'LM_CODE',align:"center",width:16},
				   		{name:'DISTANCE',align:"center",width:50},
				   		{name:'DELIVERY_NOTE',align:"center",width:50},
				   		{name:'STATUS_FLG',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='S'){
								return '已提交';
							}else if(data=='R'){
								return '已拒绝';
							}else if(data=='P'){
								return '已审核';
							}else {
								return "";
							}
	   					}},
	   					{name:'REQ_DATE',align:"center",width:40,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }
                            return data;
                            }
                        },	
				   		{name:'APPROVE_DATE',align:"center",width:40,formatter : function(data){
                            if(null!=data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }else{
                            data = '--';
                            }
                            return data;
                            }
                        },				   		
				   		{name:'CREATE_DATE',align:"center",width:40,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd");
                            }
                            return data;
                            }
                        },					   		
				   		{name:'APPROVE_DESC',align:"center",width:50,formatter : function(data){
                            if(null==data){
                            data = '无';
                            }
                            return data;
                            }
                        },				   		
				   		{name:'detail',index:'PK_NO',width:60,align:'center',sortable:false} 
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							detail = "";
							if(rowData.STATUS_FLG == '已提交'){
								detail ="<button type='button' class='btn btn-info edit' id='"+id+"'  onClick=editStatus('"+id+"','P')>审核</button> "+
									"<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/address/editRefund.jhtml'>拒绝</button>";
							}
							detail = detail + "<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/address/queryLog.jhtml'>查看日志</button> ";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				   	
				});
				
			});
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="menu" >
        		<div class="currentDataDiv_tit">     
					<button type="button" class="btn_divBtn" id="Examine" onclick="editStatus(null,'P')" > 批量审核</button>
				</div>
	            <div id="finishSt" class="">
	                <div class="form_divBox" style="display:block;">
			            <form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form"> 
							<div class="form-group" id="custCodesDiv">
								<label class="control-label" style="padding-right:5px;margin-top:10px;">查询条件：</label>
			                	<input type="text" placeholder="店铺名称/编码" class="form-control" name="keyWord" id="keyWord" style="width:120px;margin-top:10px;" >
							</div>
							<div class="form-group" id="custCodesDiv">
								<label class="control-label" style="padding-right:5px;margin-top:10px;">状态：</label>
				                	<select class="form-control required" id="statusFlg" name="statusFlg" style="width:120px;">
				                		<option value="S">已提交</option>
				                		<option value="R">已拒绝</option>
				                		<option value="P">已审核</option>
				                	</select>
							</div>
			            </form>
		            </div>
		            <div class="search_cBox">
		            	<button type="button" class="btn_divBtn" data-toggle="jBox-query" ><i class="icon-search"></i> 搜索</button>
					</div>
				</div>
	        </div> 
	      </div>    
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
    
<script>
function editStatus(pkNos,statusFlg){
	var ids;
	if(pkNos==null){
		ids= jQuery("#grid-table").jqGrid("getGridParam", "selarrrow");
		if (ids.length <= 0) {
			top.$.jBox.tip('请选择一条记录！');
			return;
		}
	}else{
		ids=pkNos
	}
	$.jBox.confirm("确认操作该数据?", "提示", function(v){
	if(v == 'ok'){
	 	$.ajax({
		    url: '${base}/address/Examine.jhtml',
			method:'post',
			dataType:'json',
      		data :{'ids': ids+'',
      			   'statusFlg':statusFlg
      		},
			sync:false,
      		error : function(data) {
	    		alert("网络异常！");
        		return false;
      		},
      		success : function(data) {
        		if(data.success==true){
        			top.$.jBox.tip('操作成功！');
        			$("#grid-table").trigger("reloadGrid");
 				}else{ 
		  			top.$.jBox.tip('操作失败！');
		 			return false;
				}
      		}
		});	
	}
  });
}
</script>
</html>