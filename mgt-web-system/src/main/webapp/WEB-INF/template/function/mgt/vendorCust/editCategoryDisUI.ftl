<!DOCTYPE html>
<html>
	<head>
		<title>类别折扣设置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<script language="javascript" type="text/javascript">  
			//添加一行
			function editPack(){
		         var i =packTab.rows.length;
		         $("#packTab").append(makeThStr(i));
				//加载商品类别菜单
	         	var $areaId = $('#catIds'+i);
		  		// 菜单类型选择
				$areaId.lSelect({
					url: "${base}/vendorPro/category.jhtml?bcFlg=B"
				});
			}
			
			//拼td字符串
			function makeThStr(i){
				var i =packTab.rows.length;
				var th = "<tr height='50px'><td width='10%' align='center'><i class='tjqy_tableIcon"+i+"'></i></td><td width='50%'><div class='form-group'><input type='hidden' id='catIds"+i+"' name='catIds' /></div></td><td width='30%' align='center'><input type='text' class='form-control input-sm required discNum' id='discNum"+i+"' maxlength='30' name='discNum"+i+"' value=''></td><td width='10%'><label class='control-label'><a href='#' stkc='' class='del'>删除</a></label></td></tr>";
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
	
	<body>
		<div class="yyzx_xgBox">
			<form class="form form-inline" id="form"  method="post"  action="${base}/vendorCust/editCategoryDis.jhtml">
				<input type='hidden' name="catC" id ="catC" value="${catc}"/>
				<div class="navbar-fixed-top" id="toolbar">
				    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">提交
					    <i class="fa-save align-top bigger-125 fa-on-right"></i>
				    </button>
					<button class="btn btn-warning" data-toggle="jBox-close">
						关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
				
				<div class="page-content">
					<div class="tjqy_btnBox"><button type="button" class="btn btn-info search_cBox_btn" id='' onclick="editPack();"> 添加分类折扣</button></div>
					<table id="packTab" class="tjqy_table" width="90%" border="0" cellspacing="0" cellpadding="0">
						<thead>
							<tr>
								<th align="center" width="10%">&nbsp;</th>
								<th align="center" width="50%" style="padding-right:200px;">商品分类</th>
								<th align="center" width="30%" style="padding-right:55px;">折扣</th>
								<th align="center" width="10%" style="padding-right:55px;">操作</th>
							</tr>
						</thead>
						<tbody>
							[#if list?exists]
		        			[#list list as accd]
		            			<tr>
		            			<td width="10%" align="center"><i class="tjqy_tableIcon1"></i></td>
		                			<td width="50%" align="left">
		                				<input type='hidden' name="catIds" id ="catIds"  treePath=",${accd.stkCatIdL1},${accd.stkCatIdL2}," value="${accd.id.stkCatId}"/>
									</td>
									<td width="30%" align="center">
		                				<input type='text' class='form-control input-sm required discNum' name="discNum${accd_index}"  id="discNum${accd_index}" value="${100-accd.discNum}"/>
									</td>
									<td width='10%'><label class='control-label'><a href='#' class='del'>删除</a></label></td>
								</tr>
		        			 [/#list]
		        			 [/#if]
						</tbody>
					</table>
				</div>
			</form>
		</div>
	</body>
</html>
<script type="text/javascript">
	$().ready(function() {
  		var $areaId = $("input[name='catIds']");
  		// 菜单类型选择
		$areaId.lSelect({
			url: "${base}/vendorPro/category.jhtml?bcFlg=B"
		});
	});
			
	function checkForm(){
		if(mgt_util.validate($('#form'))){
			$(".discNum").attr("name","discNum");
			mgt_util.submitForm('#form');
		}
	}
</script>