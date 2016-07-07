<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>订单金额差异处理</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/orderdifference/list.jhtml',
 					colNames:['','订单号','用户名','返回积分','返回余额','创建时间','变更余额的原因','变更积分的原因','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'ID',width:0,hidden:true,key:true},
				   		{name:'MAS_NO',width:100},
				   		{name:'USER_NAME', width:50},	
				   		{name:'PTS_AMOUNT',width:50,align:"center",editable:true},
	   		            {name:'BAL_AMOUNT', width:50},
	   		     		{name:'CREATE_DATE', width:90, formatter:function(data){
						if(data==null){return '';}
						var date=new Date(data);
						return date.format('yyyy-MM-dd hh:mm:ss');
						}},
	   		            {name:'BAL_CHG_DESC', width:120},
	   		            {name:'PTS_CHG_DESC',width:120},
	   		            {name:'', width:100,formatter:function(value,row,index){
	   		            var str =  '<button type="button" class="btn btn-info edit"     onClick=orderdifferenceHandle("'+index.PK_NO+'")   >处理差异</button>';
	   		            
						return  str;
	   		            }}
	   		            
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
				$("#searchbtn").click(function(){
					//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
					//mgt_util.showMask('正在查询，请稍等...');
					//top.$.jBox.tip('删除成功！','success');
					$("#grid-table").jqGrid('setGridParam',{  
				        datatype:'json',  
				        postData:$("#queryForm").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
			<div id="currentDataDiv" action="resource">
				<div class="form_divBox" style="display:block">
					<form class="form form-inline queryForm" id="query-form"> 
		               <div class="form-group">
		                    <label class="control-label">订单编号</label>
		                    <input type="text" class="form-control" name="masNo" id="masNo" style="width:120px;" >
		                </div>
		                  <div class="form-group">
		                    <label class="control-label">用户名</label>
		                    <input type="text" class="form-control" name="userName" id="userName" style="width:120px;" >
		                </div>
	<!-- 	                <div class="form-group"> -->
	<!-- 	                    <label class="control-label">配送员</label> -->
	<!-- 	                    <input type="text" class="form-control" name="logisticusername" id="logisticusername" style="width:120px;" > -->
	<!-- 	                </div>   -->
	<!-- 	                 <div class="form-group"> -->
	<!-- 	                    <label class="control-label">下单时间</label> -->
	<!-- 	                    <input type="text" class="form-control" name="startDate" id="startDate" style="width:100px;"  onClick="WdatePicker({readOnly:true})"> -->
	<!-- 	               		至 -->
	<!-- 	               		<input type="text" class="form-control" name="endDate" id="endDate" style="width:100px;"  onClick="WdatePicker({readOnly:true})"> -->
		               		
	<!-- 	                </div>  -->
						<div class="search_cBox">
			                <div class="form-group">
				                <button type="button" class="btn_divBtn" id="orderdifference_search"  data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
			               		<button type="button" class="btn_divBtn edit" id='orderdifference_handle'     onClick='orderdifferenceHandle()'   >批量处理差异</button>
			               		
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
<script>

function orderdifferenceHandle(obj){
	   if(null==obj){
	   obj= $("#grid-table").jqGrid("getGridParam", "selarrrow");
	   	if (obj.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
	   }
	   	   $.jBox.confirm("确认要处理订单差异金额?", "提示", function(v){
				if(v == 'ok'){
		var objVal=(obj+'');
	       $.ajax({
      url:'${base}/orderdifference/orderdifferenceHandle.jhtml',
      sync:false,
      type : 'post',
      dataType : "json",
      data :{'ids': objVal},
      error : function(data) {
	    alert("网络异常");
        return false;
      },
      success : function(data) {
      
      if(data.success==true){
      
        		  	top.$.jBox.tip('处理成功');
      }else{
      top.$.jBox.tip('处理失败！');
      }
        $("#grid-table").trigger("reloadGrid");
	 
      }
    }); 
	   
	   }});
}
</script>