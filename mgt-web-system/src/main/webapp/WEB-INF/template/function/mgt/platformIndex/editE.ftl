<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>编辑首页E类型数据</title>
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
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/kindeditor-min.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/plugins/chosen/chosen.jquery.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
    <script  type="text/javascript">
		$(document).ready(function(){
		    //网站前缀
   		    var strHref= $("#macroUrl").val();
   		    //编辑行的大类类别id
   		    var cateID = ${cateID};
		    //被编辑的行角标
   		    var listIndex;
		    //被编辑行的 记录主键
   		    var pkNo;
		    //被编辑行的序号
   		    var sortNo;
			
			//图片删除事件
			$(".close_btn").live("click", function() {
				$(this).parents(".upImg_img").remove();
 			});
			
			//标题  改变链接类型select事件		
			$("#titlinktype").change(function(){
				$("#titkeyWord").val('');
				$("#titcategroy").val('');
			});
			
			//左侧  改变链接类型select事件	
			$("#leftlinktype").change(function(){
				$("#leftkeyWord").val('');
				$("#leftcategroy").val('');
			});	
			
			//标题链接生成		
			$("#titborn").click(function(){
			   	//图片链接
   				var linkvar='';
				var type = $("#titlinktype").val();
				if(type=='custom'){
					linkvar = strHref;
				}else if(type=='search'){
					if($("#titcategroy").val()==''){
						linkvar = strHref+'product/search.jhtml?keyword='+$("#titkeyWord").val();
					}else{
						linkvar = strHref+'product/search.jhtml?keyword='+$("#titkeyWord").val()+'&catId='+$("#titcategroy").val();
					}
				}else if(type=='cate'){
					linkvar = strHref+'product_category/parent/'+$("#titcategroy").val()+'.jhtml';
				}			
				$("#tithrefStr").val('');
				$("#tithrefStr").val(linkvar);
			});
			
			//左侧链接生成		
			$("#leftborn").click(function(){
			   	//图片链接
   				var linkvar='';
				var type = $("#leftlinktype").val();
				if(type=='custom'){
					linkvar = strHref;
				}else if(type=='search'){
					if($("#leftcategroy").val()==''){
						linkvar = strHref+'product/search.jhtml?keyword='+$("#leftkeyWord").val();
					}else{
						linkvar = strHref+'product/search.jhtml?keyword='+$("#leftkeyWord").val()+'&catId='+$("#leftcategroy").val();
					}
				}else if(type=='cate'){
					linkvar = strHref+'product_category/parent/'+$("#leftcategroy").val()+'.jhtml';
				}			
				$("#lefthrefStr").val('');
				$("#lefthrefStr").val(linkvar);
			});
		});
		
		//ajax 实现文件上传 
		function ajaxFileUpload(Id) {
			$("#file_"+Id).attr("name","file");
			$("#file_"+Id).attr("id","file");
			$.ajaxFileUpload({
			//	url : "${base}/upload/imageUpload.jhtml",
				url : "${base}/upload/imageUpload.jhtml?type=AD",
				secureuri : false,
				fileElementId : "file",
				dataType : "json",
				success : function(data) {
					if (data.status == "success") {
						var fllUrl = '${base}'+'/uploadImage/'+data.fullUrl;
						if(Id=="tit"){
							$("#upImg_Maintain_e").append('<div class="upImg_img" id="img_'+Id+'" style="display:block;"><img src="'+fllUrl+'" width="358" height="42" /><input type="hidden" name="titImgSrc" id="titImgSrc" value="'+data.fullPath+'"><i class="close_btn"></i></div>');
						}else{
							$("#upImg_Maintain_eL").append('<div class="upImg_img" id="img_'+Id+'" style="display:block;"><img src="'+fllUrl+'" width="121" height="186" /><input type="hidden" name="leftImgSrc" id="leftImgSrc" value="'+data.fullPath+'"><i class="close_btn"></i></div>');
						}
						$("#file").attr("name","file_"+Id);
						$("#file").attr("id","file_"+Id);
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

		//点击编辑事件
		function editStkMas(tempIndex,tempPkNo,tempSortNo) {
			//被编辑的行角标
   		    listIndex=tempIndex;
		    //被编辑行的 记录主键
   		    pkNo=tempPkNo;
		    //被编辑行的序号
   		    sortNo=tempSortNo;
   		    
			//显示确定按钮
			$("#allow_List").removeAttr("style");
			$("#allowStk").removeAttr("style");
			$("#inslable").removeAttr("style");
			//清空原有值
			$("#tr"+tempIndex+"_td1").val('');
			$("#tr"+tempIndex+"_td2").val('');
			$("#tr"+tempIndex+"_td3").val('');
			$("#tr"+tempIndex+"_td4").val('');
			$("#tr"+tempIndex+"_td5").val('');
			$("#tr"+tempIndex+"_td6").val('');
			$("#tr"+tempIndex+"_td7").val('');
			var postData={keyWord:$("#keyWord").val(),areaId:'${areaId}',flg:'Floor'};
			mgt_util.jqGrid('#grid-table',{
				postData: postData,
				url:'${base}/index/editFloorItem.jhtml',
 				colNames:['商品编码','条码','商品名称','扩展名','单位','价格','规格','操作'],
 				mutiselect:false,
				colModel:[
					{name:'STK_C',index:'STK_C',width:30,hidden:false,key:true},
					{name:'PLU_C',width:60},
				   	{name:'NAME',width:160},
				   	{name:'STK_NAME_EXT',width:160},
				   	{name:'UOM', width:40},
				   	{name:'NET_PRICE', width:40},
				   	{name:'MODLE', width:40},
				   	{name:'', width:40,align:"center",formatter:function(data,row,rowObject){
						return '<button type=button class="btn btn-info edit" onclick=addFloorItem("'+rowObject.STK_C+'")>添加</button>';
						}
					} 							
				],
			});
		}
					
		//单条添加商品
		function addFloorItem(stkC){
			var rowData = $("#grid-table").jqGrid("getRowData", stkC);
			//商品信息字段
			stkC_temp = rowData.STK_C;
			pluC_temp = rowData.PLU_C;
			stkName_temp = rowData.NAME;
			extName_temp = rowData.STK_NAME_EXT;
			uom_temp = rowData.UOM;
			netPrice_temp = rowData.NET_PRICE;
			modle_temp = rowData.MODLE;
			
			//替换选中的行的列值
			$("#tr"+listIndex+"_td1").val(stkC_temp);
			$("#tr"+listIndex+"_td2").val(pluC_temp);
			$("#tr"+listIndex+"_td3").val(stkName_temp);
			$("#tr"+listIndex+"_td4").val(extName_temp);
			$("#tr"+listIndex+"_td5").val(uom_temp);
			$("#tr"+listIndex+"_td6").val(netPrice_temp);
			$("#tr"+listIndex+"_td7").val(modle_temp);
			
			//替换编辑行的数据库内容
		    $.ajax({
				url:'${base}/index/addFloorItem.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
					'stkC':stkC,
					'pkNo':pkNo,
					'masPkNo':'${masPkNo}',
					'sortNo':sortNo,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
						top.$.jBox.tip('操作成功！', 'success');
			 			return true;
					}else{
						top.$.jBox.tip('操作失败！', 'error');
			 			return false;
					}
				}
			});	
		}
					   		
		function checkForm(){
			
			//楼层标题图片链接
			var a = $("#tithrefStr").val();
			//楼层左侧图片链接
			var b = $("#lefthrefStr").val();
			//楼层标题图片地址
			var c = $("#titImgSrc").val();
			//楼层左侧图片地址
			var d = $("#leftImgSrc").val();
			//楼层类别Id
			var e = $("#catID").val();
			//楼称名称
			var f = $("#nameStr").val();
			//楼称排序序号
			var g = $("#sortNo").val();
			//网站类别
			var h = '${prodType}';
			if (mgt_util.validate(editDform)){
				if(h =='B2BWEB' && (c == ''||d == '')){
					alert('图片不能为空');
					return false;
				}
				if(h =='B2BWEB' && (a == ''||b == '')){
					alert('链接地址不能为空');
					return false;
				}
				$("#tithref").val(a);
				$("#lefthref").val(b);
				$("#titImg").val(c);
				$("#leftImg").val(d);
				$("#catId").val(e);
				$("#name").val(f);
				$("#SortNo").val(g);
			mgt_util.submitForm('#editDform');
			}
		}
   </script>
    </head>
    <body>
       <div class="body-container">
       <div class="Maintain_e">
          <!--上层广告-->
       	  <div class="Maintain_eTit">上层广告图片</div>
       	  <div class="Maintain_eTabBox">
       	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="36%"><span>选择商品大类</span>
					<select name="catID" id="catID">
						[#list cateList as cateList]
							[#if cateList.catId== cateID]
								<option value='${cateList.catId}' selected>${cateList.catName}</option>
							[#else]
								<option value='${cateList.catId}'>${cateList.catName}</option>
							[/#if]
						[/#list]
					</select>
				</td>
				<td colspan="2"><span style="padding-left:20px;">名称</span>
					<input type="text" name="nameStr" id="nameStr" value="${boxName}">
					<span style="padding-left:20px;">排序</span>
					<input type="text" name="sortNo" id="sortNo" value="${xuhao}">
				</td>
			  </tr>
			  <tr>
			    <td width="36%" rowspan="2">
					<div class="upImg_Maintain_e" id="upImg_Maintain_e">
			    		<input class="upImg_boxFile" type="file" id="file_tit" name="file_tit" onchange="ajaxFileUpload('tit');"/>
			    		<div class="upImg_div">上传图片...<br /><span>格式：JPG,GIF,PNG</span></div>
						[#if floorArea.size()!=0  && floorArea.titleImg??]
							<div class="upImg_img" id="img_tit" style="display:block;"><img src="${floorArea.titleImg.BOX_IMG}" width="358" height="42" /><input type="hidden" name="titImgSrc" id="titImgSrc" value="${floorArea.titleImg.BOX_IMG}"><i class="close_btn"></i></div>
			    		[/#if]
			    	</div>
			    	<div class="upImg_fontBox">（图片建议尺寸：1210*60像素）</div>
				</td>
			    <td width="4%" rowspan="2">&nbsp;</td>
			    <td width="60%">
					<span>连接</span>
					<select name="titlinktype" id="titlinktype">
						<option value='custom' selected>自定义</option>
						<option value='search'>搜索</option>
						<option value='cate'>类别</option>
					</select>
					<span class="padL_span">关键词</span>
					<input type="text" id="titkeyWord" name= "titkeyWord" value="" placeholder="关键字"/>
					<span class="padL_span">选择类别</span>
					<select name="titcategroy" id="titcategroy">
						<option value='' selected>选择类别</option>
						[#list cateList as cateList]
							<option value='${cateList.catId}'>${cateList.catName}</option>
						[/#list]
					</select>
				</td>
			  </tr>
			  <tr>
			    <td><span>连接地址</span>
			   	 	[#if floorArea.size()!=0 && floorArea.titleImg??]
			    		<input id="tithrefStr" name="tithrefStr" value="${floorArea.titleImg.HREF}" style="width:350px;height:30px;" type="text" />
			    	[#else]
			    		<input id="tithrefStr" name="tithrefStr" value="" style="width:350px;height:30px;" type="text" />
			    	[/#if]
			    	<a class="editB_tabBtna" id="titborn">生成链接</a></td>
			  </tr>
			</table>
       	  </div>
       	  <!--左侧广告-->
       	  <div class="Maintain_eTit">左侧广告图片</div>
       	  <div class="Maintain_eTabBox">
       	  		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="320">
				    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    		<tr>
				    			<td>
				    				<div class="upImg_Maintain_eL" id="upImg_Maintain_eL">
							    		<input class="upImg_boxFile" type="file" id="file_left" name="file_left" onchange="ajaxFileUpload('left');"/>
							    		<div class="upImg_div">上传图片...<br /><span>格式：JPG,GIF,PNG</span></div>
										[#if floorArea.size()!=0 && floorArea.leftImg??]
											<div class="upImg_img" id="img_left" style="display:block;"><img src= "${floorArea.leftImg.BOX_IMG}" width="121" height="186"/><input type="hidden" name="leftImgSrc" id="leftImgSrc" value="${floorArea.leftImg.BOX_IMG}"><i class="close_btn"></i></div>
			                			[/#if]
							    	</div>
				    			</td>
				    		</tr>
				    		<tr>
				    			<td><div class="upImg_fontBox">（图片建议尺寸：303*462像素）</div></td>
				    		</tr>
				    		<tr>
				    			<td>
				    				<span>连接</span>
									<select name="leftlinktype" id="leftlinktype">
										<option value='custom' selected>自定义</option>
										<option value='search'>搜索</option>
										<option value='cate'>类别</option>
									</select>
									<span class="padL_span">关键词</span>
									<input style="width:100px;" type="text" id="leftkeyWord" name= "leftkeyWord" value="" placeholder="关键字"/>
				    			</td>
				    		</tr>
				    		<tr>
				    			<td>
				    				<span>选择类别</span>
									<select name="leftcategroy" id="leftcategroy">
										<option value='' selected>选择类别</option>
										[#list cateList as cateList]
											<option value='${cateList.catId}'>${cateList.catName}</option>
										[/#list]
									</select>
				    			</td>
				    		</tr>
				    		<tr>
				    			<td>
				    				<span>连接地址</span>
									[#if floorArea.size()!=0 && floorArea.leftImg??]
										<input id="lefthrefStr" name="lefthrefStr" style="width:230px;height:30px;" type="text" value="${floorArea.leftImg.HREF}"/>
									[#else]	
										<input id="lefthrefStr" name="lefthrefStr" style="width:230px;height:30px;" type="text" value=""/>
									[/#if]
				    			</td>
				    		</tr>
				    		<tr>
				    			<td align="center"><a class="editB_tabBtna" id="leftborn">生成链接</a></td>
				    		</tr>
				    	</table>
					</td>
				    <td valign="top">
						<table class="Maintain_eL_tab" width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<th width="6%">序号</th>
								<th width="13%">商品编号</th>
								<th width="15%">条码</th>
								<th width="20%">商品名称</th>
								<th width="8%">扩展名</th>
								<th width="8%">单位</th>
								<th width="9%">价格</th>
								<th width="8%">规格</th>
								<th width="7%">排序</th>
								<th width="6%">操作</th>
							</tr>
							[#if floorArea.indexMas != null]
							[#list floorArea.indexMas as indexMas]
								<tr id="tr${indexMas_index}">
									<td id="tr${indexMas_index}_td0">${indexMas_index+1}</td>
									<td><input id="tr${indexMas_index}_td1" type="text" value="${indexMas.STK_C}"/></td>
									<td><input id="tr${indexMas_index}_td2" type="text" value="${indexMas.PLU_C}"/></td>
									<td><input id="tr${indexMas_index}_td3" type="text" value="${indexMas.STK_NAME}"/></td>
									<td><input id="tr${indexMas_index}_td4" type="text" value="${indexMas.STK_NAME_EXT}"/></td>
									<td><input id="tr${indexMas_index}_td5" type="text" value="${indexMas.UOM}"/></td>
									<td><input id="tr${indexMas_index}_td6" class="orange_input" type="text" value="${indexMas.NET_PRICE}"/></td>
									<td><input id="tr${indexMas_index}_td7" class="orange_input" type="text" value="${indexMas.MODLE}"/></td>
									<td id="tr${indexMas_index}_td8"><input type="text" value="${indexMas.SORT_NO}"/></td>
									<td id="tr${indexMas_index}_td9"><a onclick="editStkMas(${indexMas_index},${indexMas.PK_NO},${indexMas.SORT_NO});">编辑</a></td>
								</tr>
							[/#list]
							[#else]
							[#list 1..8 as indexMas]
								<tr id="tr${indexMas_index}">
									<td id="tr${indexMas_index}_td0">${indexMas_index+1}</td>
									<td><input id="tr${indexMas_index}_td1" type="text" value=""/></td>
									<td><input id="tr${indexMas_index}_td2" type="text" value=""/></td>
									<td><input id="tr${indexMas_index}_td3" type="text" value=""/></td>
									<td><input id="tr${indexMas_index}_td4" type="text" value=""/></td>
									<td><input id="tr${indexMas_index}_td5" type="text" value=""/></td>
									<td><input id="tr${indexMas_index}_td6" class="orange_input" type="text" value=""/></td>
									<td><input id="tr${indexMas_index}_td7" class="orange_input" type="text" value=""/></td>
									<td id="tr${indexMas_index}_td8"><input type="text" value="${indexMas_index+1}"/></td>
									<td id="tr${indexMas_index}_td9"><a onclick="editStkMas(${indexMas_index},'',${indexMas_index+1});">编辑</a></td>
								</tr>
							[/#list]							
							[/#if]
						</table>
					</td>
				  </tr>
				</table>
       	  </div>
       </div>
       	 <div style="display:none">
			[#import "/function/mgt/platformIndex/URLMacro.ftl" as urlBox]
			[@urlBox.urlPrefix url='${prodType}' /]
		 </div>
       		<form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form" >
	            <div class="pull-left">
				<div class="btn-group" id="allowStk" style="float:left;display:none" >
					<input id="keyWord" name="keyWord" type="text" class="form-control" value="" placeholder="商品名/条码/编码" style="width:150px;">
				</div>
					<button type="button" style="display:none" class="btn btn-danger" id="allow_List" data-toggle="jBox-query">搜 索 </button>
				</div>			
			</form>
			</br>
			<lable id="inslable" style="float:left;display:none">待选商品列表</lable>
			<table id="grid-table" ></table>
			<div id="grid-pager"></div>
       		<form class="form-horizontal" id="editDform" action="${base}/index/editFloor.jhtml"> 
				<input id="tithref" name="tithref" type="hidden">
				<input id="name" name="name" type="hidden">
				<input id="SortNo" name="SortNo" type="hidden">
				<input id="lefthref" name="lefthref" type="hidden">
				<input id="titImg" name="titImg" type="hidden">
				<input id="leftImg" name="leftImg" type="hidden">
				<input id="catId" name="catId" type="hidden">
				<input id="masPkNo" name="masPkNo" type="hidden" value=${masPkNo}>
				<div style="position:fixed;bottom:0px;left:5px;z-index:1000000;">
						<div class="btn-group">
							<button id="addStk" class="btn btn-danger" data-toggle="jBox-call"
								data-fn="checkForm">
								保存
							</button>
						</div>
					</div>
            </form>
        </div>
    </body>
</html>