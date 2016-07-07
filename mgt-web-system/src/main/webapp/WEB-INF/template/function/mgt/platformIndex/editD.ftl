<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>编辑首页数据页面"D"</title>
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
	<script type="text/javascript" src="${base}/scripts/lib/plugins/upload/ajaxfileupload.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/base64.js"></script>
	<script type="text/javascript" src="${base}/scripts/lib/jquery-ui/js/lang/zh_CN.js"></script>
	<style>
		.control-cont{width:100%;position:relative;height:60px;}
		.control-cont img{width:60px;height:60px;float:left;display:inline;margin-left:10px;}
	.control_fileBox{width:60px;height:60px;line-height:60px;text-align:center;float:left;}
	.grxxflie-btn{position:absolute;top:0;left:0;width:60px;height:60px;opacity:0;filter:alpha(opacity=0);z-index:2;cursor:pointer;}
	</style>
    <script  type="text/javascript">
			$(document).ready(function(){
				var lastsel2;
				var postData={masPkNo:${masPkNo},type:'${type}'}
				mgt_util.jqGrid('#grid-table1',{
					caption:'${boxName} (最多4行，图片必须为无背景的png格式，大小150像素 x150像素)', 
					postData: postData,
					url:'${base}/index/editIndexDataById.jhtml',
 					colNames:['ID','图片','商品编码','条码','商品名称','单位','价格','排序','操作'],
 					rowNum:1000,
 					multiselect:false,
 					rownumbers:true,
 					rownumWidth:10,
				   	colModel:[	 
						{name:'PK_NO',index:'PK_NO',width:1,hidden:true,key:true},
				   		{name:'BOX_IMG', width:60,formatter:function(data,row,rowObject){
						   		tmp = '';
							   	 tmp='<div class="control-cont"><div class="control_fileBox">点击上传<input class="grxxflie-btn" type="file" id="file'+rowObject.PK_NO+'" name="file'+rowObject.PK_NO+'" onchange="ajaxFileUpload('+rowObject.PK_NO+');"/></div><img src="'+rowObject.BOX_IMG+'" width="58" height="58" id="img'+rowObject.PK_NO+'" /><input type="hidden"  id="imgPath'+rowObject.PK_NO+'" name="imgPath" value="'+rowObject.BOX_IMG+'"></div>';
						   		return tmp;
							}
						},
				   		{name:'STK_C',width:30},
				   		{name:'PLU_C', width:60},
				   		{name:'STK_NAME', width:120},
				   		{name:'UOM', width:20},
				   		{name:'NET_PRICE', width:30},
				   		{name:'SORT_NO', width:20,formatter:function(data,row,rowObject){
						   		tmp = rowObject.SORT_NO;
						   		if (typeof(tmp)=="undefined" || tmp==null){  
						   			tmp = '';
						   		}
								return '<input type="text" class="filetest" id="sort'+rowObject.PK_NO+'" name="sort'+rowObject.PK_NO+'" value="'+tmp+'">';
								//return tmp;
							}
						},
				   		{name:'detail',width:30,align:'center',sortable:false}
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table1").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table1').jqGrid('getRowData',id);
							detail="<button type='input' class='btn btn-info'  id='"+id+"' data-toggle='jBox-show' onClick=delTypeD('"+id+"') >删除</button>";
							jQuery("#grid-table1").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
					}	   	
				});
				
			//点击编辑事件
			$("#editTypeD").click(function(){
				//显示确定按钮
				$("#addStk").removeAttr("style");
				$("#allow_List").removeAttr("style");
				$("#allowStk").removeAttr("style");
				if(${masPkNo}=='8'){
				var postData={keyWord:$("#keyWord").val(),areaId:'${areaId}'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/index/editWebPromItem.jhtml',
 					colNames:['','商品编码','条码','商品名称','单位','操作'],
				   	colModel:[
						{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},	 
						{name:'STK_C',index:'STK_C',width:30,hidden:false,key:true},
						{name:'PLU_C',width:60},
				   		{name:'STK_NAME',width:160},
				   		{name:'UOM', width:40},
				   		{name:'', width:40,align:"center",formatter:function(data,row,rowObject){
							return '<button type=button class="btn btn-info edit" onclick=addPromItem("'+rowObject.PK_NO+'")>添加</button>';
							}
						 } 							
				   	  ],
				   });
				}else{
				var postData={keyWord:$("#keyWord").val(),areaId:'${areaId}',flg:'New'};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/index/editStkMas.jhtml',
 					colNames:['','商品编码','条码','商品名称','单位','创建时间','操作'],
 					mutiselect:false,
				   	colModel:[
						{name:'STK_C',index:'STK_C',width:0,hidden:true,key:true},	 
						{name:'STK_C',index:'STK_C',width:30,hidden:false,key:true},
						{name:'PLU_C',width:60},
				   		{name:'NAME',width:160},
				   		{name:'UOM', width:40},
				   		{name:'CREATE_DATE',align:"center",width:100,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            if(data!=null){
                            return data;
                            }else{
                            return "";
                            }
                            }
                        },
				   		{name:'', width:40,align:"center",formatter:function(data,row,rowObject){
							return '<button type=button class="btn btn-info edit" onclick=addStkMas("'+rowObject.STK_C+'")>添加</button>';
							}
						 } 							
				   	  ],
				   });
			   }
			   });
			   
		   });


		
					
		//单条添加特价商品
		function addPromItem(pkNo,message){
		var ids=jQuery("#grid-table1").jqGrid('getDataIDs');
			if(ids.length>=4){
				top.$.jBox.tip('商品不能超过4条！');
				return false;
			}
			 $.ajax({
				url:'${base}/index/addPromItem.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
					'pkNo':pkNo,
					'masPkNo':'${masPkNo}',
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
						$('#grid-table1').trigger("reloadGrid");
					}else{
						top.$.jBox.tip('添加失败！', 'error');
			 			return false;
					}
				}
			});	
		}
		
		//单条添加新品
		function addStkMas(stkC,message){
		var ids=jQuery("#grid-table1").jqGrid('getDataIDs');
			if(ids.length>=4){
				top.$.jBox.tip('商品不能超过4条！');
				return false;
			}
			 $.ajax({
				url:'${base}/index/addStkMas.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
					'stkC':stkC,
					'masPkNo':'${masPkNo}',
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
						$('#grid-table1').trigger("reloadGrid");
					}else{
						top.$.jBox.tip('添加失败！', 'error');
			 			return false;
					}
				}
			});	
		}
								
	   //重新上传
	   function chongxin(pkNo) {
		$("#imgsrc"+pkNo).css('display', 'none');
		$("#reupload"+pkNo).hide();
		$(".file"+pkNo).css('display', 'block');
		}
		
		//删除
		function delTypeD(id){
			$.jBox.confirm("确认删除?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : "${base}/index/delMainPageBox.jhtml",
						type :'post',
						dataType : 'json',
						data : 'pkno=' + id,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
								data, function(s) {
									if (s) {
										top.$.jBox.tip(data.msg,'success');
										mgt_util.refreshGrid("#grid-table1");
									}
								});
							}
						});
					}
				})
			} 	
			
			$(".filetest").live("change",function(){
					var insortNo = $(this).val();
					$(this).removeClass("filetest");
					$(".filetest").each(function(){
					if(insortNo==Number($(this).val())){
						top.$.jBox.tip('排序编码不能重复！');
						//$("#editD").hide();
						$("#addStk").attr("disabled", true); 
					    return false;
					}else{
					$("#editD").css('display','block'); 
					$("#addStk").attr("disabled", false); 
					}
					});
					$(this).addClass("filetest");
			});

			//检查填写表单是否空	
			function checkForm(){
				//封装表单(pkNo+type+keyWord+sortNo)的集合
				var str = "";
				//var selectedIds = $("#grid-table1").jqGrid('getGridParam', 'selarrrow');
				var ids=jQuery("#grid-table1").jqGrid('getDataIDs');
				for(var i=0;i<ids.length;i++){
					var rowData = $("#grid-table1").jqGrid("getRowData", ids[i]);
					//主键
					var pkNo = rowData.PK_NO;
					//排序
					var sortNo = $("#sort"+rowData.PK_NO).val();
					//图片
					var img = $("#imgPath"+rowData.PK_NO).val();
					if(sortNo== ''){
						top.$.jBox.tip('所填项不能为空！');
						return false;
					}
					if(/^[1-4]\d?$/.test(sortNo)){
					}else{
						top.$.jBox.tip('请输入最大数值为4的正整数！');
						return false;
					}
					if(Number(sortNo) <= 0){
						top.$.jBox.tip('排序参数为正整数！');
						return false;
					}
					if(img== ''){
						alert('商品图片不能为空');
						return false;
					}
					if(i != ids.length-1){
						str =str +pkNo+","+sortNo+","+img+";";
					}else{
						str =str +pkNo+","+sortNo+","+img;
					}
				 }
				//$("#masPkNo").val(${masPkNo});
				$("#items").val(str);
				mgt_util.submitForm('#form');
			}	
		</script>
		<script  type="text/javascript">
		//图片转换后自动ajax上传数据库
		function autoUpload(){
		var str = "";
			var ids=jQuery("#grid-table1").jqGrid('getDataIDs');
			for(var i=0;i<ids.length;i++){
			var rowData = $("#grid-table1").jqGrid("getRowData", ids[i]);
			//主键
			var pkNo = rowData.PK_NO;
			//排序
			var sortNo = $("#sort"+rowData.PK_NO).val();
			//图片
			var img = $("#imgPath"+rowData.PK_NO).val();
			if(img== ''){
				alert('商品图片不能为空');
				return false;
			}
			if(i != ids.length-1){
				str =str +pkNo+","+sortNo+","+img+";";
			}else{
				str =str +pkNo+","+sortNo+","+img;
			}
			}
			$("#items").val(str);
			$.ajax({
				url:'${base}/index/editDsave.jhtml',
				sync:false,
				type : 'post',
				dataType : "json",
				data :{
					'items':str,
				},
				error : function(data) {
					alert("网络异常");
					return false;
				},
				success : function(data) {
					if(data.code==001){
						top.$.jBox.tip('上传成功！', 'success');
						$('#grid-table1').trigger("reloadGrid");
					}else{
						top.$.jBox.tip('添加失败！', 'error');
			 			return false;
					}
				}
			});	
			
			}
		//ajax 实现文件上传 
		function ajaxFileUpload(pkNo) {
			$("#file"+pkNo).attr("name","file");
			$("#file"+pkNo).attr("id","file");
			$.ajaxFileUpload({
				url : "${base}/upload/imagePngUpload.jhtml",
				secureuri : false,
				fileElementId : "file",
				dataType : "json",
				success : function(data) {
					if (data.status == "success") {
						var fllUrl = '${base}'+'/uploadImage/'+data.fullUrl;
						$("#img"+pkNo).attr("src",fllUrl);
						$("#imgPath"+pkNo).val(data.fullPath);
						$("#file").attr("name","file"+pkNo);
						$("#file").attr("id","file"+pkNo);
						$("#jUploadFormfile").remove();
						$("#jUploadFramefile").remove();
						autoUpload();
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
					top.$.jBox.tip('上传失败！', 'error');
				}
			});
		}
		</script>
    </head>
    <body>
       <div class="body-container">
			<div class="pull-left">
				<div class="btn-group" id="editD">
					<button class="btn btn-danger" id="editTypeD">
						编辑
					</button>
				</div>
			</div>
			<div style="clear:both;"></div>
		    <table id="grid-table1" >
		    </table>
		    <div id="grid-pager"></div>
		    </br>
       		<form class="form form-inline queryForm" style=" overflow:hidden;" id="query-form" >
	            <div class="pull-left">
				<div class="btn-group" id="allowStk" style="float:left;display:none" >
					<input id="keyWord" name="keyWord" type="text" class="form-control" value="" placeholder="商品名/条码/品牌/分类" style="width:150px;">
				</div>
					<button type="button" style="display:none" class="btn btn-danger" id="allow_List" data-toggle="jBox-query">搜 索 </button>
				</div>			
			</form>
       		<form class="form-horizontal" id="form" action="${base}/index/editDsave.jhtml"> 
				<input id="items" name="items" type="hidden">
				<div class="pull-right" style="margin-top:-20px;">
					<div class="btn-group">
						<button id="addStk" class="btn btn-danger" data-toggle="jBox-call"
							data-fn="checkForm">
							保存
						</button>
					</div>
				</div>
			</form>
		    <table id="grid-table" >
		    </table>
   		</div>
    </body>
</html>