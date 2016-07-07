<!DOCTYPE html>
<html>
	<head>
		<title>拒绝申请地标</title>
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
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/address/remark.jhtml">
                	<input type="hidden" name="pkNo" id="pkNo" value="${LmReq.pkNo}" />
                	<table >
                		<tbody>
                		<tr height="30px">
                			<td colspan="4"></td>
                		</tr>
                		<tr height="30px">
                			<td width="158px"><label class="control-label">店铺登录名</label></td>
                			<td width="242px"><label class="control-label">${LmReq.userName}</label>
                			</td>
                			<td width="158px"><label class="control-label">申请审核时间 </label></td>
                			<td width="235px"><label class="control-label">${LmReq.reqDate}</label></td>
                		</tr>
                		<tr height="30px">
                			<td width="158px"><label class="control-label">地标码</label></td>
                			<td width="242px"><label class="control-label">${LmReq.lmCode}</label>
                			</td>
                			<td width="158px"><label class="control-label">承诺送货时间 </label></td>
                			<td width="235px"><label class="control-label">${LmReq.deliveryNote}</label></td>
                		</tr>
                		<tr height="30px">
                			<td width="158px"><label class="control-label">申请状态</label></td>
                			<td width="242px"><label class="control-label">
                			    [#if LmReq.statusFlg == 'A']
                				 活动的
                				[#elseif LmReq.statusFlg == 'S']
                				 已提交
                				[#elseif LmReq.statusFlg == 'C']
                				 已取消
                				[#elseif LmReq.statusFlg == 'R']
                				 已拒绝
                				[#else]
                				 已审核
                				[/#if]
                			  </label>
                			</td>
                			<td width="158px"><label class="control-label">审核人 </label></td>
                			<td width="235px"><label class="control-label">${LmReq.approver}</label></td>
                		</tr>
                		<tr height="30px">
                			<td width="158px"><label class="control-label">审核时间</label></td>
                			<td width="242px"><label class="control-label">${LmReq.approveDate}</label>
                			</td>
                			<td width="158px"><label class="control-label">创建时间 </label></td>
                			<td width="235px"><label class="control-label">${LmReq.createDate}</label></td>
                		</tr>
                		<tr height="30px">
                			<td width="158px"><label class="control-label">拒绝申请审核原因</label></td>
                		</tr>
  						<tr height="30px">
					         <textarea style="width: 531px; height: 120px;" name="remark" id="remark" maxlength=300  placeholder="备注内容请限制在200字以内！"></textarea>
						</tr>
                		<tr height="30px">
                			<td colspan="4"><button class="btn btn-danger" data-toggle="jBox-call"  data-fn="checkForm">
						 	保存<i class="fa-save align-top bigger-125 fa-on-right"></i>
					    </button></td>
                		</tr>
                	</tbody>
                </table>
		</form>
	</body>
</html>
<script type="text/javascript">

	//验证表单并提交form
	function checkForm(){
		var maxChars = 200;//最多字数  
			if ($("#remark").val().length > maxChars){
 				top.$.jBox.tip('备注内容不得超过200字！');
				return false;
			} 
			if ($("#remark").val().length = 0){
 				top.$.jBox.tip('备注内容不能为空！');
				return false;
			} 
		mgt_util.submitForm('#form');
	}
</script>