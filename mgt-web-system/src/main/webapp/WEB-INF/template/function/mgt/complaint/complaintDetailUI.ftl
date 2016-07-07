<!DOCTYPE html>
<html>
	<head>
		<title>投诉处理</title>
		[#include "/common/commonHead.ftl" /]
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" src="${base}/scripts/lib/plugins/js/jquery.PrintArea.js"></script>
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		
	</head>
	<body class="toolbar-fixed-top">
		<table width="720" id="detail_return_1" class="return_list" cellpadding="0" cellspacing="0" style="display:block;">
		[#if product?exists && priceComplaint?exists]
          <tr>
            <th colspan="1">商品信息</th>
            <td colspan="3">
            	<ul style="overflow:hidden; margin:5px;">
					<li class="left" style="width:40px;">
						<img width="40" height="40" src="${product.urlAddr}" alt="商品信息">
					</li>
					<li class="left" style="width:280px; line-height:20px;">${product.name}</li>
				</ul>
            </td>
            <th>投诉用户</th>
            <td>${priceComplaint.userName}</td>
          </tr>
          <tr>
            <th>商品价格</th>
            <td>￥${product.netPrice}</td>
            <th>我的竞价</th>
            <td><strong class="color_1">￥${priceComplaint.purPrice}</strong></td>
            <th>状态</th>
            [#if priceComplaint.fbFlg == 'Y' && complaintReply?exists && null != complaintReply]
            <td>已回复</td>
            [#else]
            <td>待回复</td>
            [/#if]
          </tr>
          <tr>
            <th colspan="1">投诉建议</th>
            <td colspan="5">${priceComplaint.content}</td>
          </tr>
          <tr>
	        <th colspan="1">审核回复</th>
          [#if priceComplaint.fbFlg == 'Y' && complaintReply?exists && null != complaintReply]
	        <td colspan="5">[#if 'null'!= complaintReply.CONTENT]${complaintReply.CONTENT}[/#if]</td>
	      </tr>
	      [#else]
	      	<td colspan="5">
	      	<!--<input type="hidden" name="hiddenMasPkNo" value="${priceComplaint.pkNo}" />
	      		<input type="hidden" name="hiddenVendorChannel" value="${priceComplaint.vendorChannel}" />
	      		<input type="hidden" name="hiddenStkC" value="${priceComplaint.stkC}" />
	      		<input type="hidden" name="hiddenPurPrice" value="${priceComplaint.purPrice}" />-->
		      	<form id="replyForm" action="${base}/complaint/reply.jhtml">
		      		<input type="hidden" name="masPkNo" value="${priceComplaint.pkNo}" />
		      		<input type="hidden" name="vendorChannel" value="${priceComplaint.vendorChannel}" />
		      		<input type="hidden" name="stkC" value="${priceComplaint.stkC}" />
		      		<input type="hidden" name="purPrice" value="${priceComplaint.purPrice}" />
		      		<textarea name="content" style="height:50px; width:500px; margin:5px 0;border:1px solid #ccc;"></textarea>
		      		<button class="btn btn-warning" data-toggle="jBox-call" data-fn="checkForm">
						保存 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
		      	<form>
	      	</td>
	      [/#if]
		[/#if]
        </table>
        <script>
        
        function checkForm(){
        	var content = $("#replyForm textarea").val();
        	if("" == content) {
        		myAlert("审核回复内容不能为空！");
        		return;
        	}
        	mgt_util.submitForm('#replyForm');
		}
        
      
      
        </script>
        <div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
	</body>

</html>