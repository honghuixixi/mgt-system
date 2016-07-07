<!DOCTYPE html>
<html lang="zh-cn" class="html_ofh">
    <head>
        <meta charset="utf-8" />
        <title>消息列表</title>
		[#include "/common/commonHead.ftl" /]		
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/msgTemplet/msgTempletList.jhtml',
					multiselect:false,
					colNames:['','业务代码','业务名称','模板名称','消息体模板','模板状态','操作'], 
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'BUSI_CODE',width:'8%',align:"center",sortable:false},
						{name:'BUSI_NAME',width:'10%',align:"left",sortable:false},
						{name:'TEMP_NAME',width:'15%',align:"left",sortable:false},
						{name:'CONTENT',width:'55%',align:'left',sortable:false},
						{name:'TEMP_FLAG',width:'8%',align:"center",sortable:false,formatter:function(data){
							if(data=='Y'){
								return "启用";
							}else{
								return "禁止";
							}
		   				}},
						{name:'',width:'10%',align:'center',editable:true,formatter:function(value,row,index){
							var tempFlag = '<button type="button" class="btn btn-info edit" onClick=editMsgTempletFlag("'+index.PK_NO;
							if('Y'!=index.TEMP_FLAG)
								tempFlag = tempFlag + ','+'Y'+'") href="#">启用 </button>';
							else
								tempFlag = tempFlag + ','+'N'+'") href="#">禁止 </button>';
								
							return '<button type="button" class="btn btn-info edit" onClick=editMsgTempletUI("'+index.PK_NO+'") href="#">编辑 </button>'+tempFlag;
					   	}}
				   	],
				   	gridComplete:function(){
				   		//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}
				});
				
				//搜索
				$("#temp_search").click(function(){
					$("#grid-table").jqGrid('setGridParam',{
				        datatype:'json',  
				        postData:$("#query-form").serializeObjectForm(), //发送数据  
				        page:1  
				    }).trigger("reloadGrid"); //重新载入  
				});
			});
			
		</script>
    </head>
    
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
			<div id="currentDataDiv" action="temp">
				<div class="currentDataDiv_tit">
					<div class="form-group">
		                 <button type="button" class="btn_divBtn add" id="temp_add"  data-toggle="jBox-win" href="${base}/msgTemplet/addMsgTemplet.jhtml">添加 </button>
			        </div>
				</div>
				<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm" id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">业务名称：</label>
		                    <input type="text" class="form-control" name="busiName" style="width:120px;">
		                </div>
		                <div class="form-group">
		                    <label class="control-label">模板名称：</label>
		                    <input type="text" class="form-control" name="tempName" style="width:120px;">
		                </div>
		            </form>
		         </div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="temp_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	             	</div>
	         	</div>
	        </div>
	     </div>
		    <table id="grid-table" >  </table>
		  	<div id="grid-pager"></div>
   		</div>
    </body>
<script>
function editMsgTempletUI(obj){
	mgt_util.showjBox({
		width : 800,
		height : 380,
		title : '编辑',
		url : '${base}/msgTemplet/editMsgTempletUI.jhtml?pkNo='+obj,
		grid : $('#grid-table')
	});
}

function editMsgTempletFlag(obj){
	if(''!=obj && undefined!=obj && obj.indexOf(',')> 0){
		var pkNo = obj.split(",")[0];
		var flag = obj.split(",")[1];
		if(''!=pkNo && undefined!=flag && ''!=flag && undefined!=flag){
			$.ajax({
				type: "POST",
				url:  '${base}/msgTemplet/editMsgTempletFlag.jhtml',
				async:false,
				data: {pkNo:pkNo,tempFlag:flag},
				scope:this,
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success: function(data){
					if(data){
						if(data.code=="Y"){
							$.jBox.tip('操作成功！');
							$("#grid-table").trigger("reloadGrid");
							return;
						}else{
							$.jBox.tip('操作失败！');
							return;
						}
					}
					$.jBox.tip('请刷新重试，或联系管理员！');
					return;
				}
			});
		}
	}
}

</script>
</html>
 