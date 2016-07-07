<!DOCTYPE html>
<html>
	<head>
		<title>商品导入-导入图片</title>
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
				$(".spdr_tabUl li").click(function(){
					$(".spdr_tabUl li").removeClass("cur");
					$(this).addClass("cur");
					$(".spdr_listBox .spdr_lsit").hide();
					$(".spdr_listBox .spdr_lsit").eq( $(this).index() ).show();
					if($(this).attr('id') == "tab_spdr1"){
						$(".tab_spdr2").hide();
						editPack('');
						$("#previewImg").attr("src","${base}/styles/images/spdr_slImg.jpg");
						$("#selectAll").removeAttr("checked");
					}
				});
				//图片压缩包上传
				$('#file').live('change',function(){
			        var fileSize = Math.ceil($("#file")[0].files[0].size / 1024 / 1024); //M
			        if(fileSize > 100){
			        	alert("您上次的图片压缩包 大小大于100M,建议上传50M左右的压缩包!");
			        	$("#file").val("");
			        	return;
			        }else{
			        	$.ajaxFileUpload({
							url : "${base}/upload/zipUpload.jhtml?privatePath="+$("#privatePath").val(),
							secureuri : false,
							data : {
								filePre : "feedback",
								p : new Date()
							},
							fileElementId : "file",
							dataType : "json",
							success : function(data) {
								if(data.status == 'error'){
									top.$.jBox.tip("上传失败！");
									$("#file").val("");
								}else{
									top.$.jBox.tip(data.message);
									$("#jUploadFormfile").remove();
									$("#jUploadFramefile").remove();
									editPack($("#privatePath").val());
									$("#file").val("");
								}
							},
							error : function(data) {
								top.$.jBox.tip("上传失败！");
								$("#file").val("");
							}
						});
			        }
				});
				
				//全选/全不选
				$("#selectAll").live("click",function(){
					var checkboxs = document.getElementsByName("images");
					if(this.checked){
						for(var i=0;i<checkboxs.length;i++){
							checkboxs[i].checked = true;
						}
					}else{
						for(var i=0;i<checkboxs.length;i++){
							checkboxs[i].checked = false;
						}
					}
				});
				
				//批量删除
				$(".spdr_lsit_lbtn").live("click",function(){
					var urls = "";
					var items = $('#imgTab input[name = "images"]:checkbox:checked');
					for (var i = 0; i < items.length; i++) {
					     urls = (urls + items.get(i).value) + (((i + 1)== items.length) ? '':','); 
					}
					if(urls != ""){
						if(confirm("确定删除图片?")){
							$.ajax({
								url:"${base}/impstkmas/batchremoveimg.jhtml",
								async:false,
								data:{urls:urls},
								type : 'post',
								success: function(data){
									if(data!='success'){
										data = eval(data);
										var tips = "已导入的商品图片";
										for(var i=0;i < data.length;i++){
											if(i==data.length-1){
												tips = tips + data[i];
											}else{
												tips = tips + data[i]+",";
											}
										}
										tips = tips + "不可删除!";
										alert(tips);
									}
									editPack($("#privatePath").val());	
								   	$("#previewImg").attr("src","${base}/styles/images/spdr_slImg.jpg");
								   	$("#selectAll").removeAttr("checked");
								}
							});
						}
						
					}else{
						alert("请选择需要删除的图片!");
					}
				});
				
				//默认加载供应商目录
				editPack('');
				//editPack('${accountName}');
			})
			
			function editPack(leve){
		        $.ajax({
					url:"${base}/impstkmas/browser.jhtml?leve="+leve+"&date="+new Date(),
					success: function(data){
						if(leve==''){
							$("#packTab").html("");
							$.each(data,function(name,value){
			         			$("#packTab").append(makeItemStr(value));
						  	});
						}else{
							$("#tabUI").append("<li class='tab_spdr2' id='tab_spdr2'><span class='spdr_tabS2'>"+leve+"</span></li>");
							$(".tab_spdr1").removeClass("cur");
							$(".tab_spdr2").addClass("cur");
							$("#spdr_lsit_1").hide();
							$("#spdr_lsit_2").show();
							
							$("#imgTab").html("");
							$.each(data,function(name,value){
			         			$("#imgTab").append(makeItemStr(value));
						  	});
						}
					}
				})
			}
			
			//拼字符串
			function makeItemStr(data){
				var item;
				if(data.isDirectory){
					item = "<a href='#' onclick=\"editPack('"+data.name+"');\"><i></i>"+data.name+"</a>";
				}else{
					item = "<dd>"+
	                            "<div class='spdr_ddL'><input name='images' type='checkbox' value='"+data.url+"'></input><input type='hidden' value="+encodeURIComponent(data.url)+"/><i></i></div>"+
	                            "<div class='spdr_ddC' onclick=\"previewImage('"+encodeURIComponent(data.url)+"');\">"+data.name+"</div>"+
	                            "<div class='spdr_ddR' onclick=\"deleteImg('"+encodeURIComponent(data.url)+"');\"></div>"+
		                    "</dd>";
				}
				return item;
			}
			
			//删除图片
			function deleteImg(path){
				if(confirm("确定删除图片?")){
					$.ajax({
						url:"${base}/impstkmas/removeimg.jhtml?path="+path+"&date="+new Date(),
						async:false,
						success: function(data){
							if(data == 'error'){
								alert("已导入商品图片不可删除!");
							}
							if(data == 'success'){
								editPack($("#privatePath").val());	
							    $("#previewImg").attr("src","${base}/styles/images/spdr_slImg.jpg");
							    $("#selectAll").removeAttr("checked");
							}
						}
					});
				}
			}
			
			//预览图片
			function previewImage(path){
				path = "${base}/uploadImage"+decodeURIComponent(path).split('uploadImage')[1];
				$("#previewImg").attr("src",decodeURIComponent(path));
			}
			
		</script> 
	</head>
	<body>
		<div class="spdr_Box">
			<div class="spdr_tpCont1">
		    	<div class="spdr_tpCont1_l">
		        	<label><i></i>特别提醒：</label>
		            <p>
		            	<span>1. 图片只支持jpg格式</span><br/>
		            	<span>2. 上传时，必须将图片压缩成zip或rar文件</span><br/>
		            	<span>3. 商品导入成功后，会自动删除文件，未导入成功的文件，请手工删除</span>
		            <p>
		        </div>
		        <div class="spdr_tpCont1_r">
		        	<input type="hidden" id="privatePath" name="privatePath" value="${accountName}"/>
		        	<div class="spdr_tpCont1_rIpt1"><i></i>上传图片</div>
		        	<input class="spdr_tpCont1_rIpt2" type="file" id="file" name="file" />
		        </div>
		    </div>
		    
		    <div class="spdr_tpCont2">
		    	<ul class="spdr_tabUl" id="tabUI">
		        	<li class="tab_spdr1 cur" id="tab_spdr1"><span class="spdr_tabS1">供应商目录</span></li>
		        </ul>
		        <div class="spdr_listBox">
		        	<div class="spdr_lsit" id="spdr_lsit_1" style="display:block;">
		            	<div class="spdr_lsit_l" id="packTab"></div>
		                <div class="spdr_lsit_r"><img src="${base}/styles/images/spdr_slImg.jpg" /></div>
		            </div>
		            <div class="spdr_lsit" id="spdr_lsit_2">
		            	<div class="spdr_lsit_l">
		                	<dl id="imgTab"></dl>
		                    <div class="spdr_lsit_lB">
		                    	<span><input id="selectAll" type="checkbox"/>全选</span>
		                    	<input class="spdr_lsit_lbtn" type="button"  value="删除"/>
		                    </div>
		                </div>
		            	<div class="spdr_lsit_r"><img id="previewImg" src="${base}/styles/images/spdr_slImg.jpg" /></div>
		            </div>
		        </div>
		    </div>
		</div>
	</body>
</html>
