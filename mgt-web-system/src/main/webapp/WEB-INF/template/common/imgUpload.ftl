<div class="box-revise-list maT10">
	<h3>商品图片</h3>
	<div class="revise-padBox">
		<dl class="revise-uploadDl" id="imgDiv">
			<dt id="uploadBox">上传图片...<input class="fileBtn" type="file" id="file" name="file" onchange="ajaxFileUpload();" /></dt>
			<input type="hidden" name="delImg" id="delImg">
			[#if imgList ??]
			[#list imgList as img]
				<dd class="imgclass"><img src="${img.serverUrl}${img.smallPath}" width="96" height="96" /><input type="hidden" name="saveImg" value="${img.smallPath}" pkNo="${img.pkNo}"><i class="imgDel"></i></dd>
			[/#list]
			[/#if]
		</dl>
	</div>
</div>
<script>
	$(".imgDel").live("click",function(){
		var $delImg = $(this).prev();
		if($delImg.is('input')){
			$("#imgDiv").append('<input type="hidden" name="delImg" value="'+$delImg.attr("pkNo")+'">');
		}
		$(this).parent().remove();
	});
 	//ajax 实现文件上传 
	function ajaxFileUpload() {
		$.ajaxFileUpload({
			url : "${base}/upload/imageUpload.jhtml?time="+new Date(),
			secureuri : false,
			data : {
				filePre : "feedback",
				p : new Date()
			},
			fileElementId : "file",
			dataType : "json",
			success : function(data) {
				if (data.status == "success") {
					var fllUrl = '${base}'+'/uploadImage/'+data.fullUrl;
					$("#imgDiv").append('<dd class="imgclass"><img src="'+fllUrl+'" width="96" height="96" /><i class="imgDel"></i></dd>');
					$("#imgDiv").append('<input type="hidden" name="fullPath" value="'+data.fullPath+'">');
					$("#jUploadFormfile").remove();
					$("#jUploadFramefile").remove();
				}
				switch(data.message){
				 //解析上传状态
					case "-1" : 
						alert("上传文件不能为空!");
					    break;
					case "1" : 
						alert("上传失败!");
					    break;
					case "2" : 
						alert("文件超过上传大小!");
					    break;
					case "3" : 
						alert("文件格式错误!");
					    break;
					case "4" : 
						alert("上传文件路径非法!");
					    break;
					case "5" :
						alert("上传目录没有写权限!");
					    break;
				}
			},
			error : function(data) {
				alert("上传失败！");
			}
		});
	}
﻿</script>