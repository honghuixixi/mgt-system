<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>编辑首页B类型数据</title>
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
	<link href="${base}/scripts/lib/plugins/chosen/chosen.css" type="text/css" rel="stylesheet"/>	
	<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
    <script  type="text/javascript">
   		//ajax 实现文件上传 
		function ajaxFileUpload(Id) {
			$("#file"+Id).attr("name","file");
			$("#file"+Id).attr("id","file");
			$.ajaxFileUpload({
				url : "${base}/upload/imageUpload.jhtml?type=AD",
				secureuri : false,
				fileElementId : "file",
				dataType : "json",
				success : function(data) {
					if (data.status == "success") {
						var fllUrl = '${base}'+'/uploadImage/'+data.fullUrl;
						$("#upImg_box"+Id).append('<div class="upImg_img" id="img_'+Id+'" style="display:block;"><img  id="imgSrc" src="'+fllUrl+'" width="272" height="120" /><input type="hidden" id="fullPath" name="fullPath" value="'+data.fullPath+'"><i class="close_btn"></i></div>');
						$("#file").attr("name","file"+Id);
						$("#file").attr("id","file"+Id);
						$("#jUploadFormfile").remove();
						$("#jUploadFramefile").remove();
					}
					switch(data.message){
					 //解析上传状态
						case "-1" : 
							top.$.jBox.tip('上传文件不能为空!', 'error');
						    break;
						case "1" : 
							top.$.jBox.tip('上传失败!', 'error');
						    break;
						case "2" : 
							top.$.jBox.tip('文件大小不能超过200K!', 'error');
						    break;
						case "3" : 
							top.$.jBox.tip('文件格式错误!', 'error');
						    break;
						case "4" : 
							top.$.jBox.tip('上传文件路径非法!', 'error');
						    break;
						case "5" :
							top.$.jBox.tip('上传目录没有写权限!', 'error');
						    break;
					}
				},
				error : function(data) {
					alert("上传失败！");
				}
			});
		}
		$(document).ready(function(){
			//图片删除事件
			$(".close_btn").live("click", function() {
				$(this).parents(".upImg_img").remove();
 			});
			//选择链接类型
			$("select[name='linktype']").change(function(){
				$(this).parents("table").find("#keyWord").val('');
				$(this).parents("table").find("#categroy").val('');
			});	
			
			//生成链接点击事件		
			$("a[name='born']").live("click",function(){
			   	//图片链接
   				var linkvar='';
   				var type = $(this).parents("table").find("#linktype").val();
   				var cate = $(this).parents("table").find("#categroy").val();
   				var keyW = $(this).parents("table").find("#keyWord").val();
				if(type=='custom'){
					linkvar = $("#macroUrl").val();
				}else if(type=='search'){
					if(cate==''){
						linkvar = $("#macroUrl").val()+'product/search.jhtml?keyword='+keyW;
					}else{
						linkvar = $("#macroUrl").val()+'product/search.jhtml?keyword='+keyW+'&catId='+cate;
					}
				}else if(type=='cate'){
					linkvar = $("#macroUrl").val()+'product_category/parent/'+cate+'.jhtml';
				}else if(type=='brand'){
					if(cate==''){
						linkvar = $("#macroUrl").val()+'brand/'+keyW+'.jhtml';
					}else{
						linkvar = $("#macroUrl").val()+'brand/'+keyW+'.jhtml?'+'&catId='+cate;
					}
				}else if(type=='vendor'){
					if(cate==''){
						linkvar = $("#macroUrl").val()+'vendor/'+keyW+'.jhtml';
					}else{
						linkvar = $("#macroUrl").val()+'vendor/'+keyW+'.jhtml?'+'&catId='+cate;
					}				
				}			
				$(this).parents("table").find("#hrefStr").val('');
				$(this).parents("table").find("#hrefStr").val(linkvar);
			});
			
					
			//保存按钮
			$("a[name='save']").live("click",function(){
				//图片地址
				var a = $(this).parents("table").find("#fullPath").val();
				//图片链接
				var b = $(this).parents("table").find("#hrefStr").val();
				//排序
				var c = $(this).parents("table").find("#sort").val();
				//描述
				var d = $(this).parents("table").find("#desc").val();
				//记录主键
				var e = $(this).attr("id");
				if( a == ''||b == ''||c == ''||d == ''){
					alert('必填项不能为空');
					return false;
				}
				$("#imgDiZhi").val(a);
				$("#sortNum").val(c);
				$("#descWord").val(d);
				$("#linkHref").val(b);
				$("#pkNo").val(e);
				mgt_util.submitForm('#addform');
			});
		});
		
		//新增(table 的id命名为已存在list的最大角标+1，即list的size())
		function addTable(){
			var html = '';
			var options = '';
			[#list cateList as cateList]
				options+='<option value="${cateList.catId}">${cateList.catName}</option>'
			[/#list]
			var html='<table id="table_${mainList.size()}" width="100%" border="0" cellspacing="0" cellpadding="0">'+
				'<tr>'+
			    '<td width="10%" align="center" rowspan="3"><input type="checkbox" name="boxsele" indexNo="${mainList.size()}"/></td>'+
			    '<td width="30%" rowspan="3">'+
			    	'<div class="upImg_box" id="upImg_box'+${mainList.size()}+'">'+
			    		'<input class="upImg_boxFile" type="file" name="file'+${mainList.size()}+'" id="file'+${mainList.size()}+'" onchange="ajaxFileUpload('+${mainList.size()}+');"/>'+
			    		'<div class="upImg_div">上传图片...<br /><span>格式：JPG,GIF,PNG</span></div>'+
			    	'</div>'+
			    	'<div class="upImg_fontBox">（图片建议尺寸：'+
			    		$("#ImgSize").val()+
			    	'）</div>'+
				'</td>'+
			    '<td width="20%"><span>排序</span><input id="sort" class="width60 input_icon1" type="text" value=""/></td>'+
			    '<td width="40%" colspan="2"><span>描述</span><input id="desc" class="width300 input_icon2" type="text" value=""/></td>'+
			  '</tr>'+
			  '<tr>'+
			    '<td><span>连接</span>'+
					'<select name="linktype" id="linktype">'+
						'<option value="custom" selected>自定义</option>'+
						'<option value="search">搜索</option>'+
						'<option value="cate">类别</option>'+
						'<option value="brand">品牌</option>'+
						'<option value="vendor">供应商</option>'+
					'</select>'+
			   '</td>'+
			    '<td><span>关键词</span><input id="keyWord" name= "keyWord" value="" placeholder="关键字"></input></td>'+
			    '<td>选择类别'+
					'<select class="form-control" style="width:100px;" name="categroy" id="categroy">'+
						'<option value="" selected>选择类别</option>'+
							options+
					'</select>'+
				'</td>'+
			  '</tr>'+
			  '<tr>'+
			    '<td colspan="3"><span>连接地址</span><input id="hrefStr" name="hrefStr" style="width:350px;height:30px;" type="text" value=""/>'+
			    	'<a class="editB_tabBtna" name="born">生成链接</a>'+
			    	'<a class="editB_tabBtna" name="save">保存</a>'+
			   '</td>'+
			  '</tr>'+
			'</table>'
			//只允许添加完成一条数据，再执行新增
			if($("#table_${mainList.size()}").length > 0 ){
				top.$.jBox.tip('请先保存正在编辑的数据！', 'error');
			 	return false;
			}else{
				if(${mainList.size()}==0){
					$("#table_-1").append().before(html);
				}else{
					$("#table_0").append().before(html);
				}
			}
		}
		
		//删除
		function delTable(){
			//声明选中的checkBox的主键数组
			var checkArray = []; 
			//声明选中的checkBox的角标数组
			var checkIndexArray = []; 
			$("input[name='boxsele']").each(function(i){ 
			    var isCheck = $(this).attr("checked");
   				 if('checked' == isCheck || isCheck){
        			checkArray[i] = $(this).val();
        			checkIndexArray[i] = $(this).attr("indexNo");
   				}
			});
			
			if(checkIndexArray.length==0){
				top.$.jBox.tip('请选择至少一条记录！', 'error');
				return false;
			}else{
				$.jBox.confirm("确认删除吗?", "提示", function(v){
				if(v == 'ok'){
				$.ajax({
					url:'${base}/index/delMainPageBox.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					data :'pkno='+checkArray,
					error : function(data) {
						top.$.jBox.tip('网络异常！', 'error');
						return false;
					},
					success : function(data) {
						if(data.success){
							top.$.jBox.tip('删除成功！', 'success');
							//页面删除元素
							for(var i=0;i<checkIndexArray.length;i++){
								$("#table_"+checkIndexArray[i]).remove();
							}
							 window.location.reload();
						}else{
							top.$.jBox.tip('删除失败！', 'error');
			 				return false;
						}
					}
				});	
			   }
			});
		  }
		}
	</script>
    </head>
    <body>
       <div class="body-container">
         <div style="display:none">
			[#import "/function/mgt/platformIndex/URLMacro.ftl" as urlBox]
			[@urlBox.urlPrefix url='${prodType}' /]
		 </div>
   		 <div class="editB_box">
   		 	<div class="editB_titBox">
   		 		<button type="button" class="search_cBox_btn marBtn" onclick="addTable()">新&nbsp;增</button><button type="button" class="search_cBox_btn marBtn" onclick="delTable()">删&nbsp;除</button>
   		 	</div>
   		   [#if mainList.size()==0]
				<table id="table_-1"></table>   		   
   		   [#else]	
   		   [#list mainList as mainList]
   		 	<table id="table_${mainList_index}" width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="10%" align="center" rowspan="3"><input type="checkbox" name="boxsele" indexNo="${mainList_index}" value="${mainList.PK_NO}"/></td>
			    <td width="30%" rowspan="3">
			    	<div class="upImg_box" id="upImg_box${mainList_index}">
			    		<input class="upImg_boxFile" type="file" name="file${mainList_index}" id="file${mainList_index}" onchange="ajaxFileUpload(${mainList_index});"/>
			    		<div class="upImg_div">上传图片...<br /><span>格式：JPG,GIF,PNG</span></div>
			    		[#if mainList.BOX_IMG!=null]
			    			<div class="upImg_img" style="display:block;">
			    				<img  id="imgSrc" src="${mainList.BOX_IMG}" width="272" height="120" />
			    				<input type="hidden" name="saveImg" value="${mainList.BOX_IMG}"><i class="close_btn"></i>
			    				<input type="hidden" id="fullPath" value="${mainList.BOX_IMG}">
			    			</div>
			    		[/#if]
			    	</div>
			    	<div class="upImg_fontBox">
			    		[#if prodType=='B2BWEB']
			    			（图片建议尺寸：1000*450像素）
			    		[#else]	
			    			（图片建议尺寸：600*200像素）
			    		[/#if]	
			    	</div>
				</td>
			    <td width="20%"><span>排序</span><input id="sort" class="width60 input_icon1" type="text" value="${mainList.SORT_NO}"/></td>
			    <td width="40%" colspan="2"><span>描述</span><input id="desc" class="width300 input_icon2" type="text" value="${mainList.BOX_DESC}"/></td>
			  </tr>
			  <tr>
			    <td><span>连接</span>
					<select name="linktype" id="linktype">
						<option value='custom' selected>自定义</option>
						<option value='search'>搜索</option>
						<option value='cate'>类别</option>
						<option value='brand'>品牌</option>
						<option value='vendor'>供应商</option>
					</select>
			    </td>
			    <td><span>关键词</span><input id="keyWord" name= "keyWord" value="" placeholder="关键字"></input></td>
			    <td>选择类别
					<select class="form-control" style="width:100px;" name="categroy" id="categroy">
						<option value='' selected>选择类别</option>
						[#list cateList as cateList]
							<option value='${cateList.catId}'>${cateList.catName}</option>
						[/#list]
					</select>
				</td>
			  </tr>
			  <tr>
			    <td colspan="3"><span>连接地址</span><input id="hrefStr" name="hrefStr" style="width:350px;height:30px;" type="text" value="${mainList.HREF}"/>
			    	<a class="editB_tabBtna" name="born">生成链接</a>
			    	<a class="editB_tabBtna" name="save" id="${mainList.PK_NO}">保存</a>
			    </td>
			  </tr>
			</table>
		   [/#list]
		   [/#if]
   		 </div>
   	    <form class="form-horizontal" action="${base}/index/saveTypeB.jhtml" id="addform" name="addForm">
    		<input id="imgDiZhi" name="imgDiZhi" type="hidden">
			<input id="sortNum" name="sortNum" type="hidden">
			<input id="descWord" name="descWord" type="hidden">
			<input id="linkHref" name="linkHref" type="hidden">
			<input id="pkNo" name="pkNo" type="hidden">
			<input id="boxType" name="boxType" type="hidden" value="A">
			<input id="masPkNo" name="masPkNo" value="${masPkNo}" type="hidden">
        </form>
       </div>
    </body>
</html>