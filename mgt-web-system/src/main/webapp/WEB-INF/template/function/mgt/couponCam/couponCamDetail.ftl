<!DOCTYPE html>
<html>
	<head>
		<title>详情</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>
	<style>
		.page-content{width:80%;margin:0 auto;}
		.page-content .yyzx_xqUl .yyzx_xqBox{width:33%;padding-right:0;margin-right:0;}
		#area{width:100%;}
	</style>
	<body>
	<div class="yyzx_xgBox">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-warning" data-toggle="jBox-close">
					关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>	
			
			<div class="page-content">
				<ul class="yyzx_xqUl">
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">活动标题：</label>
							<span class="yyzx_xqSpan">${couponCam.ccName}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label  for="userName" class="col-sm-4 control-label width_left2">活动状态：</label>
							[#if couponCam.statusFlg='P']
						    <div class="yyzx_xqSpan">已启用</div>
						    [#elseif couponCam.statusFlg='A']
						    <div class="yyzx_xqSpan">未启用</div>
						    [#else]
						    <div class="yyzx_xqSpan">已过期</div>
						    [/#if]
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">开始时间：</label>
							<span class="yyzx_xqSpan">${couponCam.dateFrom}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">结束时间：</label>
							<span class="yyzx_xqSpan">${couponCam.dateTo}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">规则：</label>
							[#if couponCam.issueType='R'||couponCam.issueType='O']
							<span class="yyzx_xqSpan">自动发放</span>
							[#else]
							<span class="yyzx_xqSpan">用户领取</span>
							[/#if]
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">优惠面额：</label>
							<input type="hidden" id="cpValue" value="${couponCam.cpValue}"/>
							<span class="yyzx_xqSpan">${couponCam.cpValue}</span>
						</div>
					</li>
					<li>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">每人限领：</label>
							<span class="yyzx_xqSpan">${couponCam.singleCustMaxQty}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">总张数：</label>
							<span class="yyzx_xqSpan">${couponCam.totalQty}</span>
						</div>
						<div class="form-group yyzx_xqBox">
							<label for="userName" class="col-sm-4 control-label width_left2">可使用最低消费金额：</label>
							<span class="yyzx_xqSpan">${couponCam.minAmtNeed}</span>
						</div>
					</li>
					<br/>
					[#if ccIssueRules?exists]
	 				<table id="packTab" class="tjqy_table" width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
	 					<thead>
							<tr>
								<th align="center" width="10%">&nbsp;</th>
								<th colspan="7" align="center" width="60%" style="padding-right:200px;">按订单金额规则</th>
							</tr>
						</thead>
		        			[#list ccIssueRules as ccIssueRules]
							<tr>
								<td width='10%' align='center'>${ccIssueRules_index+1}、满</td>
								<td width='10%' align='left;'>
								<div class='form-group'><div class='col-sm-8'>
								<input type='text' disabled="disabled" id='orderAmount${ccIssueRules_index+1}' name='orderAmount' class='filetest form-control required' value="${ccIssueRules.orderAmount}"/></div>
								</td>
								<td width='5%' align='center'>送</td>
								<td width='10%' align='left;'>
								<div class='form-group'><div class='col-sm-8'>
								<input type='text' disabled="disabled" id='cpQty${ccIssueRules_index+1}' name='cpQty' class='count form-control required'  value="${ccIssueRules.cpQty}"/> </div></td>
								<td width='10%' align='left'>张</td><td width='5%' align='center'>共</td>
								<td width='10%' align='left;'>
								<div class='form-group'>
								<div class='col-sm-8'>
								<input type='text' disabled="disabled"  id='refNo${ccIssueRules_index+1}' name='refNo' class='form-control required' value=""/></div></td>
								<td width='10%' align='left'>元</td>
							</tr>
		        			 [/#list]
		        			 <tbody>
							</tbody>
					</table>
    			 [/#if]
				<br/>
				[#if ccAreas?exists]
				[#if couponCam.cpProp='P']
				<div id="area" class="page-content form form-inline">
					<table id="packTabs" class="tjqy_table" width="70%" border="0" cellspacing="0" cellpadding="0">
						<thead>
							<tr>
								<th align="center" width="10%">&nbsp;</th>
								<th align="center" width="60%" style="padding-right:200px;">投放区域</th>
							</tr>
						</thead>
		        			[#list ccAreas as ccAreas]
		            			<tr>
		            			<td width="10%" align="center"><i class="tjqy_tableIcon1"></i></td>
		                			<td width="60%" align="left;">
		                				<input type='hidden' name="areaIds" id ="areaIds"  treePath="${ccAreas.TREE_PATH}" value="${ccAreas.AREA_ID}"/>
									</td>
								</tr>
		        			 [/#list]
						<tbody>
						</tbody>
					</table>
				</div>
				[/#if]
			 [/#if]
				</ul>
			</div>	

		</div>
	</body>
</html>
<script type="text/javascript">
		$().ready(function() {
				//计算按订单规则总金额
				if(document.getElementById("packTab")){
				var i =packTab.rows.length+1;
				for(var j=1;j<i;j++){
				var cpValue = $("#cpValue").val();
				var cpQty = $("#cpQty"+j).val();
				$("#refNo"+j).val(Number(cpQty)*Number(cpValue));
				}}
				
				var $areaId = $("input[name='areaIds']");
		  		// 菜单类型选择
				$areaId.lSelect({
					url: "${base}/common/area.jhtml"
				});
				$(".isArea").attr("disabled","disabled");
			});
</script>
