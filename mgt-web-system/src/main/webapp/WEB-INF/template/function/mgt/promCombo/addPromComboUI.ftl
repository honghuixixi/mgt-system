<!DOCTYPE html>
<html>
	<head>
		<title>套装新增页面</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
	</head>

	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/prom/addPromCombo.jhtml" method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form" >
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 	        <div class="page-content">
 	        <div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkC" class="col-sm-4 control-label">
								商品编码：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="stkC" name="stkC" class="form-control required" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<input type="button" class="search_cBox_btn" id="addMas" value="选择"/> 
						</div>
					</div>
				</div>
 	        	<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkName" class="col-sm-4 control-label">
								商品名称：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="stkName" readonly="true" name="stkName" class="form-control required" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="refNo" class="col-sm-4 control-label">
								套餐名称：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="refNo" name="refNo" class="form-control" /> 
							</div>
						</div>
					</div>
				</div>
 	        	<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="kitPrice" class="col-sm-4 control-label">
								套装价格：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="kitPrice" name="kitPrice" readonly="true" class="form-control required" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="sortNo" class="col-sm-4 control-label">
								显示顺序：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="sortNo" name="sortNo" onkeyup="if(/\D/.test(this.value)){top.$.jBox.tip('只能输入数字！');;this.value='';}" class="form-control required" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="beginDate" class="col-sm-4 control-label">
								开始时间：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="beginDate" name="beginDate" class="form-control required" onClick="var endDate=$dp.$('endDate');WdatePicker({onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'endDate\')}',dateFmt:'yyyy-MM-dd'})" style="width:181px;" /> 
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="endDate" class="col-sm-4 control-label">
								结束时间：
							</label>
							<div class="col-sm-7">
		      				<input type="text" id="endDate" name="endDate" class="form-control required"   onClick="WdatePicker({minDate:'#F{$dp.$D(\'beginDate\')}',dateFmt:'yyyy-MM-dd'})"style="width:181px;" />
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
	 			<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="spNote" class="col-sm-4 control-label">说明：</label>
						    <div class="col-sm-7">
					            <textarea class="form-control" style="width: 531px; height: 164px;" name="spNote" id="spNote" maxlength=300></textarea>
						    </div>
						</div>
					</div>
				</div>
			</div>
		</form>
       		<form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form" >
	            <div class="pull-left">
					<label id="biaoqian" style="display:none">待选商品列表：</label>
				<div class="btn-group" id="allowStk" style="float:left;display:none" >
					<input id="nameOrStkc" name="nameOrStkc" type="text" class="form-control" value="" placeholder="商品名/编码/条码" style="width:150px;">
				</div>
					<button type="button" style="display:none" class="btn_divBtn del" id="allow_List" data-toggle="jBox-query">搜 索 </button>
				</div>			
			</form>		
		</br>
		<table id="grid-table" >
		</table>
		<div id="grid-pager"></div>
	</body>
</html>
   <script type="text/javascript">
    function checkForms(){ 
    	 if (mgt_util.validate(form)){
       				top.$.jBox.open("iframe:${base}/prom/addPromCombo.jhtml?beginDate="+$('#beginDate').val()+"&endDate="+$('#endDate').val()+"&spNote="+$('#spNote').text(), "选择商品", 960, 650, {
   						border : 0,
   						persistent : true,
   						iframeScrolling : 'no',
   						buttons : {}
   					});
   					
    	 }
    }
    
    		//点击“选择”事件
			$("#addMas").click(function(){
				//显示确定按钮
				$("#addStk").removeAttr("style");
				$("#allow_List").removeAttr("style");
				$("#allowStk").removeAttr("style");
				$("#biaoqian").removeAttr("style");
				$('#gbox_grid-table').show();
				mgt_util.jqGrid('#grid-table',{
					multiselect:false,
					url:'${base}/prom/allowStkMas.jhtml',
 					colNames:['商品编码','条码','商品名称','价格','单位','规格','操作'],
				   	colModel:[
						{name:'STK_C',index:'STK_C',width:50,hidden:false,key:true},
						{name:'PLU_C',width:70},
				   		{name:'NAME',width:130},
				   		{name:'NET_PRICE',width:40},
				   		{name:'UOM', width:30},
				   		{name:'MODLE', width:35},
				   		{name:'', width:40,align:"center",formatter:function(data,row,rowObject){
							return '<button type=button class="btn btn-info edit" onclick=addWhIo("'+rowObject.STK_C+'","'+rowObject.NAME+'","'+rowObject.NET_PRICE+'")>选择</button>';
							}
						} 							
				   	],
				 });
			});	
			
		//单条添加商品
		function addWhIo(stkC,name,netPrice,message){
			$("#stkC").val(stkC);
			$("#stkName").val(name);
			$("#kitPrice").val(netPrice);
			
			$("#addStk").hide();
			$("#allow_List").hide();
			$("#allowStk").hide();
			$("#biaoqian").hide();			
			$('#gbox_grid-table').hide();
		}			
    </script>