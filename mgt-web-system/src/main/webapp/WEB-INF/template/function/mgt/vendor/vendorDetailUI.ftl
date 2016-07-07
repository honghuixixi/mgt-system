<!DOCTYPE html>
<html>
	<!-- 头部 -->
	<head>
		<title>角色修改</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
		<object id="LODOP" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0"> 
    		<embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0" pluginspage="install_lodop.exe"></embed>
		</object> 
		<link href="${base}/styles/css/base.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/catestyle.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/indexcss.css" type="text/css" rel="stylesheet" />
		<link href="${base}/styles/css/popup.css" rel="stylesheet" type="text/css" />
		<script text="text/javascript">
		function editPro(){
			var flg = true;
			$("tbody :input[id='qty']").each(function(i){
			    if(/\D/.test($(this).val()) || (parseInt($(this).parent().prev().text()) < parseInt($(this).val())) 
					    || $(this).val() == "" ){
					top.$.jBox.tip('请输入正确数量');
				    flg = false;
					return false;
				}
			});
			if(!flg){
				return false;
			}
			$.jBox.confirm("确认修改么？", "提示", function(v){
				if(v == 'ok'){
					  if (mgt_util.validate(queryForm)){
						 		$.ajax({
								    url: '${base}/vendor/vendorDone.jhtml',
									method:'post',
									dataType:'json',
									data:mgt_util.formObjectJson($("#queryForm")),
									sync:false,
									success : function(data) {
									if(data.code==001){		
										top.$.jBox.tip(data.msg, 'success');
										top.$.jBox.refresh = true;
										top.$.jBox.close();
									}else{
										top.$.jBox.tip(data.msg, 'error');
										return false;
									}
								}
						});	
					}
				}
			});
		}
		</script>
	</head>
	
	<!-- 身体 -->
<body class="toolbar-fixed-top">
		<div style="margin-left:628px;" >
			[#if masCode == 'WHVNDIN']
			<button  id="preview" style="height:30px;width:60px;" onclick="return editPro()"> 
				发货
			</button>
			[#elseif masCode == 'WHVNDOUT']
			<button  id="preview" style="height:30px;width:60px;" onclick="return editPro()"> 
				收货
			</button>
			[/#if]
			
		</div>
       <div class="page-content">
           <div class="safe_right"> 
               <div>
               <form id="queryForm" type="post" >
                   <table class="price_bill" cellpadding="0" cellspacing="0" >
                        <thead>
					      <tr height="25">
					        <td><strong>序号</strong></td>
					        <td hidden="true;">外键</td>
					        <td><strong>商品编码</strong></td>
					        <td><strong>条码</strong></td>
					        <td><strong>名称</strong></td>
					        <td><strong>单位</strong></td>
					        <td><strong>数量</strong></td>
					        <td><strong>实际数量</strong></td>
					      </tr>
    					</thead>
    					<tbody>
    						[#assign masCode = masCode]
    						<input id="masCode" name="masCode" hidden="true" type="text"  value="${masCode}" />
    						[#list vendor as item]
    						<tr>
    							<td width="100"><span>${item.ITEM_NO}</span></td>
    							<!-- 备货单号 -->
    							<td hidden="true" id="masPkNo">${item.MAS_PK_NO}</td>
    							<input  name="masPkNo" hidden="true" type="text"  value="${item.MAS_PK_NO}"></input>
    							<td width="100"><span>${item.STK_C}</span></td>
    							<input id="stkC" name="stkC" hidden="true" type="text"  value="${item.STK_C}"></input>
    							<td width="100"><span>${item.PLU_C}</span></td>
    							<td width="140"><span>${item.STK_NAME}</span></td>
    							<td width="100"><span>${item.UOM}</span></td>
    							<td width="100"><span>${item.STK_QTY}</span></td>
    							[#if 'WHVNDIN'=='${masCode}']
    								<td width="100"><input id="qty" name="qty" type="text" value="${item.STK_QTY}"/></td>
    							[#else]
    								<td width="100"><input id="qty" readonly= "true" name="qty" type="text" value="${item.QTY1}"/></td>
    							[/#if]
    						</tr>
    						[/#list]
    					</tbody>
                  </table>
             </form>     
		     </div>
		   </div>
	</div>
	<div class="confirmBox">[#include "/common/confirm.ftl" /]</div>
</body>
</html>