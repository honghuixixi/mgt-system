<!DOCTYPE html>
<html>
	<head>
		<title>新建备货单</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="${base}/scripts/lib/jquery-ui/css/smoothness/jquery-ui-1.9.2.custom.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/jquery-ui/js/themes/default/default.css" type="text/css" rel="stylesheet"/>
		<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" name="addForm" action="${base}/warehouse/addWhIoMas.jhtml">
            <div class="navbar-fixed-top" id="toolbar">
			    <button class="btn btn-danger" data-toggle="jBox-call"  data-fn="checkForm">
				 	保存<i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>			
			<div class="page-content">
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="artTitle" class="col-sm-4 control-label">
								类型：
							</label>
							<div class="col-sm-7">
	                    		<select data-placeholder="请选择补货类型" class="form-control" name="whType" id="whType">
	                        		<option value="0"></option>
	                        		<option value="WHVNDIN" >供应商补货</option>
	                        		<option value="WHVNDOUT">供应商退货</option>
	                        		<option value='WHTRNOUT'>调拨发出</option>
	                        		<option value='WHTRNIN'>调拨接收</option>
	                    		</select>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label id="firName" class="col-sm-4 control-label">
								收货方：
							</label>
							<div class="col-sm-7">
								<input id="receiverId" name="receiverId" type="hidden">
	                    		<select data-placeholder="请选择收货方" class="form-control"  id="receiver_select">
	                    			[#list whList as whList]
	                    				<option value="${whList.WH_C}" wName="${whList.NAME}">${whList.NAME}</option>
	                    			[/#list]
	                    		</select>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label id="secName" class="col-sm-4 control-label">
								发货方：
							</label>
							<div class="col-sm-7">
	                    		<select data-placeholder="请选择发货方" class="form-control" name="deliverId" id="deliver_select">
	                    			<option value="0"></option>
	                    		</select>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
					  <div class="form-group">
						<label for="description" class="col-sm-4 control-label">
							备注：
						</label>
						<div class="col-sm-7">
					         <textarea class="form-control" style="width: 531px; height: 120px;" name="remark" id="remark" maxlength=300  placeholder="备注内容请限制在200字以内！"></textarea>
						</div>
					  </div>		 
				    </div>	
			    </div>	
				
			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
  $().ready(function() {
  	var typeValue; 
  	//更改发、收货方
	$("#whType").chosen().change(function(){
		//清除默认的select项
		$('#deliver_select').empty();
		$("#deliver_select").chosen("destroy");
		typeValue = $(this).val();
		var whC = $('#receiver_select').val();
		if(typeValue=='WHVNDIN' || typeValue=='WHTRNIN'){
			$("#firName").html("收货方:");
			$("#receiver_select").attr('data-placeholder','请选择收货方');
			$("#secName").html("发货方:");
			$("#deliver_select").attr('data-placeholder','请选择发货方');
		}else{
			$("#firName").html("发货方:");
			$("#receiver_select").attr('data-placeholder','请选择发货方');
			$("#secName").html("收货方:");
			$("#deliver_select").attr('data-placeholder','请选择收货方');
		}
		$.ajax({
			url: "${base}/warehouse/selectOptions.jhtml?typeValue="+typeValue+"&whC="+whC,
			type: "GET",
			dataType: "json",
			cache: false,
			async: false,
			success: function(data) {
				//循环添加发货地址options
				$.each(data.otheroptions, function(value, name) {
					$('#deliver_select').append("<option value='"+value+","+name+"'>"+name+"</option>"); 
				});	
				$('#deliver_select').chosen({
    				no_results_text:"没有可选项",  	
    			});	
			}
		});		
	});
	
	//更改发、收货方
	$("#receiver_select").chosen().change(function(){
		//清除默认的select项
		$('#deliver_select').empty();
		$("#deliver_select").chosen("destroy");
		var whC = $('#receiver_select').val();
		$.ajax({
			url: "${base}/warehouse/selectOptions.jhtml?typeValue="+typeValue+"&whC="+whC,
			type: "GET",
			dataType: "json",
			cache: false,
			async: false,
			success: function(data) {
				//循环添加发货地址options
				$.each(data.otheroptions, function(value, name) {
					$('#deliver_select').append("<option value='"+value+","+name+"'>"+name+"</option>"); 
				});	
				$('#deliver_select').chosen({
    				no_results_text:"没有可选项",  	
    			});	
			}
		});
	  });
	});

	//验证表单并提交form
	function checkForm(){
		var type = $("#whType").chosen().val();
		var deliv = $("#deliver_select").chosen().val();
		var rece = $("#receiver_select").chosen().val()+","+$("#receiver_select").find("option:selected").attr("wName");
		$("#receiverId").val(rece);
		var maxChars = 200;//最多字数  
			if(type=='0'||rece=='0'||deliv=='0'){
				top.$.jBox.tip('必选项不能为空！');
				return false;
			} 
			if(rece == deliv){
				top.$.jBox.tip('发货方和收货方不能为同一仓库！');
				return false;
			} 
			if ($("#remark").val().length > maxChars){
 				top.$.jBox.tip('备注内容不得超过200字！');
				return false;
			} 
		mgt_util.submitForm('#form');
	}
	
	//chosen插件初始化，绑定元素
	$(function(){
    	$('#whType').chosen({
    	});
    	$('#deliver_select').chosen({
    	});
    	$('#receiver_select').chosen({
    	});
	});
</script>