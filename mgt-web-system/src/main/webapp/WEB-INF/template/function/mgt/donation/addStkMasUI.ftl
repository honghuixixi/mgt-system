<!DOCTYPE html>
<html>
	<head>
		<title>赠品新增页面</title>
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
		<form class="form-horizontal" id="form"  method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" onClick="sub()" >
					保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" onClick="closes()">关闭
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
								商品数量：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="qty" name="qty" class="form-control required digits " min="1" maxlength="8"/> 
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkName" class="col-sm-4 control-label">
								条码：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="pluC" readonly="true" name="pluC" class="form-control required" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="refNo" class="col-sm-4 control-label">
								价格：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="netPrice" readonly="true" name="netPrice" class="form-control required" /> 
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="stkName" class="col-sm-4 control-label">
								单位：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="uom" readonly="true" name="uom" class="form-control required" /> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="refNo" class="col-sm-4 control-label">
								规格：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="modle" readonly="true" name="modle" class="form-control required" /> 
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
					multiselect:true,
					url:'${base}/donation/allowStkMas.jhtml',
 					colNames:['商品编码','条码','商品名称','价格','单位','规格','操作'],
				   	colModel:[
						{name:'STK_C',index:'STK_C',width:50,hidden:false,key:true},
						{name:'PLU_C',width:70},
				   		{name:'NAME',width:130},
				   		{name:'NET_PRICE',width:40},
				   		{name:'UOM', width:30},
				   		{name:'MODLE', width:35},
				   		{name:'', width:40,align:"center",formatter:function(data,row,rowObject){
							return '<button type=button class="btn btn-info edit" onclick=addWhIo("'+rowObject.STK_C+'","'+rowObject.NAME+'","'+rowObject.NET_PRICE+'","'+rowObject.UOM+'","'+rowObject.MODLE+'","'+rowObject.PLU_C+'")>选择</button>';
							}
						} 							
				   	],
				 });
			});	
			
		//单条添加商品
		function addWhIo(stkC,name,netPrice,uom,modle,pluC){
			$("#stkC").val(stkC);
			$("#stkName").val(name);
			$("#netPrice").val(netPrice);
			$("#uom").val(uom);
			$("#modle").val(modle);
			$("#pluC").val(pluC);
			
			$("#addStk").hide();
			$("#allow_List").hide();
			$("#allowStk").hide();
			$("#biaoqian").hide();			
			$('#gbox_grid-table').hide();
		}
		
		function sub(){
			if (mgt_util.validate(form)){
				window.parent.addRowData($("#stkC").val(),$("#stkName").val(),$("#netPrice").val(),$("#uom").val(),$("#modle").val(),$("#pluC").val(),$("#qty").val());
   		    	window.parent.window.jBox.close();
			}
		}
		
		function closes(){
			window.parent.window.jBox.close();
		}
					
    </script>