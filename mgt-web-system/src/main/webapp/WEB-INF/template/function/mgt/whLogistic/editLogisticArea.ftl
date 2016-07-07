<!DOCTYPE html>
<html>
	<head>
		<title>仓库/配送站区域分配</title>
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
		         $("#packTab").append(makeThStr());
		         var i =packTab.rows.length-1;
				//加载选择区域菜单
		         	var $areaId = $('#areaIds'+i);
				  		// 菜单类型选择
						$areaId.lSelect({
							url: "${base}/common/areaWhLogitic.jhtml"
						});
			}
			
			//拼td字符串
			function makeThStr(){
				var i =packTab.rows.length;
				var th = "<tr height='50px'><td width='10%' align='center'><i class='tjqy_tableIcon"+i+"'></i></td><td width='130px'><div class='form-group'><input type='hidden' id='areaIds"+i+"' name='areaIds' /></div></td><td width='30px'><label class='control-label'><a href='#' stkc='' class='del'>删除</a></label></td></tr>";
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
			<form class="form form-inline" id="form"  method="post"  action="${base}/warehouse/addDsArea.jhtml">
				<input type="hidden" name="whC" id="whC" value="${whC}" />
				<div class="navbar-fixed-top" id="toolbar">
				    <button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">提交
					    <i class="fa-save align-top bigger-125 fa-on-right"></i>
				    </button>
					<button class="btn btn-warning" data-toggle="jBox-close">
						关闭 <i class="fa-undo align-top bigger-125 fa-on-right"></i>
					</button>
				</div>
				
				<div class="page-content">
					<div class="tjqy_btnBox"><button type="button" class="btn btn-info search_cBox_btn" id='' onclick="editPack();"> 添加分配区域</button></div>
					<table id="packTab" class="tjqy_table" width="90%" border="0" cellspacing="0" cellpadding="0">
						<thead>
							<tr>
								<th align="center" width="10%">&nbsp;</th>
								<th align="center" width="80%" style="padding-right:200px;">分配区域</th>
								<th align="center" width="10%" style="padding-right:55px;">操作</th>
							</tr>
						</thead>
						<tbody>
							[#if dsAreas?exists]
		        			[#list dsAreas as dsAreas]
		            			<tr>
		            			<td width="10%" align="center"><i class="tjqy_tableIcon1"></i></td>
		                			<td width="80%" align="left;">
		                				<input type='hidden' name="areaIds" id ="areaIds"  treePath="${dsAreas.TREE_PATH}" value="${dsAreas.AREA_ID}"/>
									</td>
									<td width='30px'><label class='control-label'><a href='#' class='del'>删除</a></label></td>
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
  		var $areaId = $("input[name='areaIds']");
  		// 菜单类型选择
		$areaId.lSelect({
			url: "${base}/common/areaWhLogitic.jhtml"
		});
	});
			
	function checkForm(){
		var ids;
		$("input[name='areaIds']").each(function(){
			ids = ids+','+$(this).val();
		});
		$.ajax({
			url:'${base}/warehouse/checkaddDsArea.jhtml',
			sync:false,
			type:'post',
			dataType:'json',
			data:{
				'areaIds':ids,
			},
			error:function(data){
				alert("网络异常")
				return false;
			},
			success:function(data){
				if(data.code==1){
					top.$.jBox.tip(data.msg, 'error');
					return false;
				}else if(data.code==2){
					top.$.jBox.tip(data.msg, 'error');
					return false;
				}else if(data.code==3){
					top.$.jBox.tip(data.msg, 'error');
					return false;
				}else{
					mgt_util.submitForm('#form');
				}
			}
		});	
	}
</script>