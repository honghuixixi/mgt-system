<!DOCTYPE html>
<html>
	<head>
		<title>限时抢购修改页面</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<style>
		.new_select select{width:auto;display:inline-block;}
		.page-content .form-control{width:auto;}
		.yyzx_xgBox{padding:20px 0;}
		.tjqy_table tr td{vertical-align:middle;}
		.row{margin-top:10px;}
		.a{text-decoration:none;}
		.promTimeUl-table .control-label{font-size:12px;}
		.promTimeUl-table tr td{padding:10px 0;}
		.aaa td{background:red;}
		</style>
		<script type="text/javascript">
			$().ready(function() {
  				var $areaId = $("input[name='areaIds']");
  				// 菜单类型选择
				$areaId.lSelect({
					url: "${base}/common/areao.jhtml"
				});
							
    			//点击checkbox事件
				$("#payOnlineFlg").click(function(){
					if(this.checked){
						$("input[name='payOnlineFlg']").val("Y");
					}else{
						$("input[name='payOnlineFlg']").val("N");
					}
				});	
				
				//选择补贴方式事件
				$("#allowanceType").change(function(){
					if(this.value=="R"){
						//显示%符号+输入框
						$("#jinebox").append('<input type="text" id="allowanceValue" name="allowanceValue" onblur="checkPercentNumber(this);" class="form-control required" / style="width:85px;"> <a  id="percent" class="a">%</a>');
						$("#bitian").removeAttr("style");;
					}else{
						//去掉%输入框
						$("#allowanceValue").remove();
						$("#percent").remove();
						$("#bitian").hide();
					}
				});	
			});
			
			//校验字符长度
			function checkLength(obj){
			    //输入的字节数
			 	var inputNum = $(obj).val().replace(/[^\x00-\xff]/g, "**").length; //得到输入的字节数
				if(Number(inputNum)>128){
					top.$.jBox.tip('活动名称过长！');
					obj.value='';
				}				
			}
						
			//校验数值
			function checkNumber(obj){
				var numb = $(obj).val();
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(numb)){
					top.$.jBox.tip('请输入正确数字！');
					obj.value='';
				}
				if((obj.value).length>10){
					top.$.jBox.tip('输入的数值过大！');
					obj.value='';
				}	
				if((obj.value)<=0){
					top.$.jBox.tip('请输入大于0的订单金额！');
					obj.value='';
				}								
			}
						
			//校验比率值在0-100+数值
			function checkPercentNumber(obj){
				var percent = $(obj).val();
				var old = $(obj).attr("oldVal");
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(percent)){
					top.$.jBox.tip('请输入正确数字！');
					obj.value=old;
				}
				if(Number(percent)>100){
					top.$.jBox.tip('只能输入0-100间的比率值！');
					obj.value=old;
				}
				if(Number(percent)<0){
					top.$.jBox.tip('只能输入0-100间的比率值！');
					obj.value=old;
				}
				if(Number(percent)<0.000001){
					top.$.jBox.tip('只能输入大于0.000001比率值！');
					obj.value='';
				}				
			}
			
			//校验开始时间
			function checkTimeFrom(obj){
				var timeTo = $("#timeTo").val();
				var curr = $(obj).val();
				
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(curr)){
					top.$.jBox.tip('只能输入正确数值！');
					obj.value='';
				}
				if(!(/^(0|\-?[1-9]\d*0{2})$/).test(curr)){
					top.$.jBox.tip('只能输入100的倍数的数值！');
					obj.value='';
				}
				if(Number(curr)>Number(2400)){
					top.$.jBox.tip('只能输入小于等于2400的数值！');
					obj.value='';
				}
				//比较大小
				if(timeTo!=''){
					if(Number(curr)>Number(timeTo)){
						top.$.jBox.tip('开始时间不得大于结束时间！');
						obj.value='';
					}
				}
			}		

			//校验结束时间
			function checkTimeTo(obj){
				var timeFrom = $("#timeFrom").val();
				var curr = $(obj).val();
				
				if(!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(curr)){
					top.$.jBox.tip('只能输入正确数值！');
					obj.value='';
				}
				if(!(/^(0|\-?[1-9]\d*0{2})$/).test(curr)){
					top.$.jBox.tip('只能输入100的整倍数的数值！');
					obj.value='';
				}
				if(Number(curr)>Number(2400)){
					top.$.jBox.tip('只能输入小于等于2400的数值！');
					obj.value='';
				}				
				//比较大小
				if(timeFrom!=''){
					if(Number(curr)<Number(timeFrom)){
						top.$.jBox.tip('结束时间不得小于开始时间！');
						obj.value='';
					}
				}
			}		
					 	
			//提交表单		 		
			function checkForm(){
				var areaIDs = [];
				$("input[name='areaIds']").each(function(i, o){
    				areaIDs[i] = $(o).val();
				});		
				if(areaIDs ==undefined){
					top.$.jBox.tip('请至少指定一个区域！');
					return false;
				}
				//校验添加的区域在当前用户区域内（主要是区域没选完全，只到2 级或3 级的情况）
				if(areaIDs !=undefined && areaIDs.length>0){
			 		$.ajax({
						url:'${base}/common/checkArea.jhtml',
						sync:false,
						type : 'post',
						dataType : "json",
						data :{
							'AreaIds':JSON.stringify(areaIDs),
						},
							error : function(data) {
							alert("网络异常");
							return false;
						},
						success : function(data) {
							if(data.message.type == "error"){
								top.$.jBox.tip('存在超出当前用户区域权限的区域！');
								$.each(data.illegalAreaIds,function(n, areaIds) {
									$("input[name='areaIds']").each(function(i, o){
    									if($(o).val()==areaIds){
    										 $(this).parents(".bbb").addClass('aaa');
    									}else{
    									 	$(this).parents(".bbb").removeClass('aaa');
    									}
									});		
								});	
								return false;
							}else if(data.message.type == "success"){
							    $(".bbb").removeClass('aaa');
								mgt_util.submitForm('#form');
							}else{
								top.$.jBox.tip('系统错误，请联系管理员！');
								return false;
							}
						}
					});					
				}				
			}
			
			//添加一行
			function editPack(){
		         $("#packTab").append(makeThStr());
		         var i =packTab.rows.length-1;
				//加载选择区域菜单
		         	var $areaId = $('#areaIds'+i);
				  		// 菜单类型选择
						$areaId.lSelect({
							url: "${base}/common/areao.jhtml"
						});
			}
			
			//拼td字符串
			function makeThStr(){
				var i =packTab.rows.length;
				var th = "<tr class='bbb'><td height='40' width='15%' align='center'><i class='tjqy_tableIcon"+i+"'></i></td><td width='70%'><div class='form-group'><input type='hidden' id='areaIds"+i+"' name='areaIds' /></div></td><td width='15%'><label class='control-label'><a href='#' stkc='' class='del'>删除</a></label></td></tr>";
				return th;
			}
			
			//删除一行
				$("a.del").live("click",function(){
					var tr = $(this).parent().parent().parent();
					var len = tr.parent().children("tr").length;
					tr.remove();
				});		
    </script>
	</head>
	
	<body style="padding:20px 20px 0 20px;">
		<form class="form-horizontal" id="form" action="${base}/prom/savePromTime.jhtml" method="POST">
			<input type="hidden" name="userNo" id="userNo" value="${user.userNo}" />
			<input type="hidden" name="payOnlineFlg" value="${prom.payOnlineFlg}"/>
			<input type="hidden" name="id" value="${prom.pkNo}"/>
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
					<i class="fa-save align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div style="clear:both;"></div>
			<table class="promTimeUl-table" width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="15%" align="right"><label for="masCode" class="control-label">促销方式：</label></td>
				<td width="35%">
					<select name="masCode" class="form-control required" style="width:150px;">
						[#if prom!=null && prom.masCode=='WEBPROMD']
							<option value="WEBPROMD" selected>限时抢购</option>
						[/#if]	
					</select>
					<span class="help-inline">*</span>
				</td>
				<td width="15%" align="right"><label for="refNo" class="control-label">活动名称：</label></td>
				<td width="35%">
					<input type="text" id="refNo" name="refNo" class="form-control required" onblur="checkLength(this);" value="${prom.refNo}" style="width:200px;" /> 
					<span class="help-inline">*</span>
				</td>
			  </tr>
			  <tr>
				<td align="right"><label for="beginDate" class="control-label">活动有效期：</label></td>
				<td>
					<input type="text" id="beginDate" name="beginDate" class="form-control required" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width:100px;" value="${prom.beginDate?string("yyyy-MM-dd")}" style="width:150px;"/> 
					<input type="text" id="endDate" name="endDate" class="form-control required"   onClick="WdatePicker({minDate:'#F{$dp.$D(\'beginDate\')}',dateFmt:'yyyy-MM-dd'})" style="width:100px;" value="${prom.endDate?string("yyyy-MM-dd")}" style="width:150px;"/>
					<span class="help-inline">*</span>
				</td>
				<td align="right"><label for="timeFrom" class="control-label">时间段：</label></td>
				<td>
					<input type="text" id="timeFrom" name="timeFrom" onblur="checkTimeFrom(this);" class="form-control required" style="width:100px;" value="${prom.timeFrom}"/>
					<input type="text" id="timeTo" name="timeTo" onblur="checkTimeTo(this);" class="form-control required" style="width:100px;" value="${prom.timeTo}"/>
					<span class="help-inline">*</span>
				</td>
			  </tr>
			  <tr>
				<td align="right"><label for="minAmtNeed" class="control-label">订单金额限制  >=</label></td>
				<td>
					<input style="width:200px;" type="text" id="minAmtNeed" name="minAmtNeed" onblur="checkNumber(this);" class="form-control required" value="${prom.minAmtNeed}"/>
					<span class="help-inline">*</span>
				</td>
				<td colspan="2">
						[#if prom!=null && prom.payOnlineFlg=='Y']
							<input type="checkbox" class="search_cBox_btn" id="payOnlineFlg" checked="checked"/>
						[#else]	
							<input type="checkbox" class="search_cBox_btn" id="payOnlineFlg"/> 
						[/#if]				
					<label class="control-label">抢购活动必须使用在线支付</label>
				</td>
			  </tr>
			  <tr>
				<td align="right"><label for="allowanceType" class="control-label">平台补贴方式：</label></td>
				<td colspan="3">
					<select name="allowanceType" id="allowanceType" class="form-control required" style="width:110px;">
							[#if prom!=null && prom.allowanceType=='V']
								<option value="V" selected>差额补贴</option>
								<option value="R">百分比补贴</option>
							[#else]	
								<option value="V">差额补贴</option>
								<option value="R" selected>百分比补贴</option>
							[/#if]	
					</select>
					<span id="jinebox">
							[#if prom!=null && prom.allowanceType=='R']
								<input type="text" id="allowanceValue" name="allowanceValue" oldVal="${prom.allowanceValue}" value="${prom.allowanceValue}" onblur="checkPercentNumber(this);" class="form-control required" / style="width:85px;"> 
								<a  id="percent" class="a">%</a>
							[/#if]					
					</span>
					[#if prom!=null && prom.allowanceType=='R']
						<span id="bitian" class="help-inline">*</span>
					[#else]
						<span id="bitian" class="help-inline" style="display:none">*</span>
					[/#if]
				</td>
			  </tr>
			  <tr>
				<td align="right"><label for="spNote" class="control-label">活动说明：</label></td>
				<td colspan="3">
					<textarea class="form-control" style="width: 531px; height: 80px;" name="spNote" id="spNote" maxlength=300>${prom.spNote}</textarea>
				</td>
			  </tr>
			</table>

			
			<div class="yyzx_xgBox">
				<label for="area" class="control-label" style="width:100%;text-align:left;padding-bottom:10px;">抢购活动的区域范围：</label>
				<div class="page-content">
					<div class="tjqy_btnBox"><button type="button" class="btn btn-info search_cBox_btn" id='' onclick="editPack();"> 添加分配区域</button></div>
					<table id="packTab" class="tjqy_table" width="90%" border="0" cellspacing="0" cellpadding="0">
						<thead>
							<tr>
								<th align="center" width="15%">&nbsp;</th>
								<th align="center" width="70%" style="padding-right:200px;">分配区域</th>
								<th align="center" width="15%" style="padding-right:55px;">操作</th>
							</tr>
						</thead>
						<tbody>
							[#if promAreas?exists]
		        			[#list promAreas as promAreas]
		            			<tr class="bbb">
		            			<td width="15%" align="center"><i class="tjqy_tableIcon1"></i></td>
		                			<td width="70%" align="left;">
		                				<input type='hidden' name="areaIds" id ="areaIds"  treePath="${promAreas.treePath}" value="${promAreas.areaId}"/>
									</td>
									<td width='15%'><label class='control-label'><a href='#' class='del'>删除</a></label></td>
								</tr>
		        			 [/#list]
		        			 [/#if]
						</tbody>
					</table>
				</div>
			</div>
		</form>
	</body>
</html>