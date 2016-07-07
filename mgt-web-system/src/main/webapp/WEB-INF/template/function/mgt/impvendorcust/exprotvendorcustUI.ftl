<!DOCTYPE html>
<html>
	<head>
		<title>商品导入-导入Excel</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/impstkmas_style.css" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
		<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
		<script language="javascript" type="text/javascript">
			$(document).ready(function(){
				$('#file').live('change',function(){
					if($(this).val() == ""){
						alert("请选择文件上传!");
					}
					$.ajaxFileUpload({
						url : "${base}/upload/excelUpload.jhtml",
						secureuri : false,
						data : {
							filePre : "feedback",
							p : new Date()
						},
						fileElementId : "file",
						dataType : "json",
						success : function(data) {
							$("#jUploadFormfile").remove();
							$("#jUploadFramefile").remove();	
							top.$.jBox.tip(data.message,'sucess');
							top.$.jBox.refresh = true;
							mgt_util.closejBox('jbox-win');
						},
						error : function(data) {
							alert("上传失败！");
						}
					});
				});
			})
		</script> 
	</head>
	<body>
		<div class="spdr_Box">
			<div class="spdr_cont1Tit">导入流程</div>
		    <div class="spdr_cont2">
		    	<span class="spdr_cont2_bg1"><i></i><br />下载模板</span><font></font><span class="spdr_cont2_bg2"><i></i><br />填写客户信息</span><font></font><span class="spdr_cont2_bg3"><i></i><br />导入EXCEL</span><font></font><span class="spdr_cont2_bg5"><i></i><br />检查</span><font></font><span class="spdr_cont2_bg6"><i></i><br />导入系统</span>
		    </div>
		    <div class="spdr_cont3"><i></i>特别提醒：<span>1. 必须按照要求填写EXCEL</span></div>
		    <div class="spdr_cont1Tit spdr_cont4">导入步骤</div>
		    <div class="spdr_cont5 clearfix">
		    	<div class="spdr_cont5_1"><span>1</span><i></i><a href="${base}/download/userinfotemplate.xlsx">EXCEL模板下载</a></div>
		        <div class="spdr_cont5_2">
		        	<span>2</span>
		            <div class="spdr_cont5_2T"><i></i>整理数据并导入</div>
		        	<div class="spdr_cont5_2C clearfix">
		            	<input class="spdr_cont5_ipt1" type="text"/>
		            	<input class="spdr_cont5_ipt2" id="import" type="button" value="浏览..." />
		                <input class="spdr_cont5_ipt3" name="file" type="file" id="file"/>
		            </div>
		            <div class="spdr_cont5_2B">说明：文件只能是EXCEL格式</div>
		        </div>
		    </div>
		</div>
	</body>
</html>
