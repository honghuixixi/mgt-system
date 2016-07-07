<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>营销管理-限时抢购定义</title>
	[#include "/common/commonHead.ftl" /]
	<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
   <script  type="text/javascript">
	
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/prom/Timelist.jhtml',
 					colNames:['','活动名称','促销方式','状态','开始日期','结束日期','开始时间','结束时间','促销规则','平台补贴方式','操作'],
				   	colModel:[	 
						{name:'PK_NO',index:'ID',hidden:true,key:true},
				   		{name:'REF_NO',width:90},
				   		{name:'MAS_CODE',width:30,formatter:function(data){
							if(data=='WEBPROMA'){
								return '买赠';
							}else if(data=='WEBPROMC'){
								return '套装促销';
							}else if(data=='WEBPROMD'){
								return '限时抢购';
	   						}
	   					}},
						{name:'STATUS_FLG',width:20,formatter:function(data){
							if(data=='A'){
								return '未启用';
							}else if(data=='P'){
								return '已启用';
	   						}
	   					}},
				   		{name:'BEGIN_DATE',width:35,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
				   		{name:'END_DATE', width:35,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
				   		{name:'TIME_FROM',width:30,formatter:function(data){
								var str= (Number(data)/100)+':'+'00';
								return str;
						}},
				   		{name:'TIME_TO',width:30,formatter:function(data){
								var str= (Number(data)/100)+':'+'00';
								if(str=='23.59:00'){
									str='24:00'
								}
								return str;
						}},
						{name:'', width:100,align:"center",formatter:function(value,row,rowObject){
							if(rowObject.PAY_ONLINE_FLG=='Y'){
								return '订单金额不小于'+rowObject.MIN_AMT_NEED+',且必须在线支付';
							}else{
								return '订单金额不小于'+rowObject.MIN_AMT_NEED;
							}
						  }
						},					   					   		
						{name:'ALLOWANCE_TYPE',width:40,formatter:function(data){
							if(data=='R'){
								return '百分比补贴';
							}else if(data=='V'){
								return '差额补贴';
	   						}else{
								return data;
	   						}
	   					}},
	   					{name:'',width:20,formatter:function(value,row,index){
									if(index.STATUS_FLG=='A'){
										return '<button type=button class="btn btn-info edit" onclick=editTimeStatus("'+index.PK_NO+'","P","启用")>启用</button>';
									}
									if(index.STATUS_FLG=='P'){
										return '<button type=button class="btn btn-info edit" onclick=editTimeStatus("'+index.PK_NO+'","A","撤销") >撤销</button>';
									}
									else{
										return '';
									}
								}
						}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				});
			});
			
			//撤销
			function editTimeStatus(pkNo,statusFlg,message){
				 $.jBox.confirm("确认修改吗?", "提示", function(v){
			 			if(v == 'ok'){
							 $.ajax({
								url:'${base}/prom/editTimeStatus.jhtml',
								sync:false,
								type : 'post',
								dataType : "json",
								data :{
									'pkNo':pkNo,
									'statusFlg':statusFlg
								},
								error : function(data) {
									alert("网络异常");
									return false;
								},
								success : function(data) {
									if(data.code==001){
										top.$.jBox.tip('保存成功！', 'success');
										top.$.jBox.refresh = true;
										$('#grid-table').trigger("reloadGrid");
									}else{
										top.$.jBox.tip('保存失败！', 'error');
							 			return false;
									}
								}
							});	
						}
				});
			}
		</script>
    </head>
    <body>
       <div class="body-container">
		  <div class="main_heightBox1">
            <!-- 面包屑导航 -->
			<div id="currentDataDiv" action="resource">
			<div class="currentDataDiv_tit">
             	<button type="button" class="btn_divBtn add"  id='promTime_add' data-toggle="jBox-win"  href="${base}/prom/addPromTimeUI.jhtml">新增</button>
             	<button type="button" class="btn_divBtn edit" id='promTime_edit' data-toggle="jBox-edit-promTime"  href="${base}/prom/editPromTimeUI.jhtml">修改</button>
                <button type="button" class="btn_divBtn del"  id='promTime_del' data-toggle="jBox-remove-prom" href="${base}/prom/delete.jhtml">删除</button>
                <button type="button" class="btn_divBtn add"  id='prom_item_list' onclick="chargeListUI()" >审核</button>
                <button type="button" class="btn_divBtn add"  id='prom_stk_list' onclick="allstkMasListUI()" >所有正在参加抢购的商品</button>
			</div>
	            <!-- 搜索条 -->
	            <div class="form_divBox" style="display:block">
		            <form class="form form-inline queryForm"  id="query-form"> 
		                <div class="form-group">
		                    <label class="control-label">关键词：</label>
		                    <input type="text" class="form-control" name="nameOrMasNo" id="nameOrMasNo" placeholder="活动名称" style="width:150px;" >
							<label class="control-label">状态：</label>
							<select name="statusFlg" class="form-control">
								<option value="">全部</option>
								<option value="A">未启用</option>
								<option value="P">已启用</option>
							</select>
		                </div>
		          		<div class="search_cBox">
			                <div class="form-group">
			                 	<button type="button" class="search_cBox_btn" id='promTime_search' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
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
	//审核
	function  chargeListUI(){
		var ids = jQuery("#grid-table").jqGrid('getGridParam', 'selarrrow');
		var rowDatas =jQuery("#grid-table").jqGrid('getRowData', ids[0]); 
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			var statusFlg=rowDatas.STATUS_FLG;
			if(statusFlg!='已启用'){
				top.$.jBox.tip("该活动未开始，请先启用活动!");
				return;
			}
			//结束时间
			var timeTo=new Date(rowDatas.END_DATE+' '+rowDatas.TIME_TO+':00');
			//系统时间
			var sysdate = new Date();
			if(timeTo<sysdate){
				top.$.jBox.tip("该活动已结束!");
				return;
			}
	
			window.location.href="${base}/prom/chargeListUI.jhtml?masPkNo=" + ids[0];
	}
	
	//查看所有参加抢购的商品			
	function  allstkMasListUI(){
			window.location.href="${base}/prom/allstkMasListUI.jhtml";
	}			
</script> 