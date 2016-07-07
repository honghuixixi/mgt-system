<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>审核商品信息</title> [#include "/common/commonHead.ftl" /] [#include
"/common/confirm.ftl" /]
<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
<script type="text/javascript" language="javascript"
	src="${base}/scripts/lib/plugins/Lodop/LodopFuncs.js"></script>
<link href="${base}/styles/css/base.css" type="text/css"
	rel="stylesheet" />
<link href="${base}/styles/css/catestyle.css" type="text/css"
	rel="stylesheet" />
<link href="${base}/styles/css/indexcss.css" type="text/css"
	rel="stylesheet" />
<link href="${base}/styles/css/popup.css" rel="stylesheet"
	type="text/css" />
<style type="text/css">
ul {
	margin: 0;
	padding: 24px 10px 0 80px;
	list-style: none;
}

li {
	display: inline;
	margin: 0;
	padding: 0;
}
</style>
</head>
<body class="toolbar-fixed-top">

	[#list records as records]
	<form class="form-horizontal newCss" id="queryForm">
		<div class="page-content">
			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="name" class="col-sm-4 control-label"> 商品名称： </label>
						<div class="col-sm-7">${records.NAME}</div>
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label for="url" class="col-sm-4 control-label"> 商品主键： </label>
						<div class="col-sm-7">${records.STK_C}</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="name" class="col-sm-4 control-label"> 系统商品类别：
						</label>
						<div class="col-sm-7">
							<span id="catId1">${records.CAT_NAME}</span>
						</div>
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label for="url" class="col-sm-4 control-label"> 自定义商品类别：
						</label>
						<div class="col-sm-7">${records.CAT_C}</div>
					</div>
				</div>
			</div>


			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="name" class="col-sm-4 control-label"> 原图地址： </label>
						<div class="col-sm-7">
							<div id="path2"></div>
							<input type="hidden" id="sourcePath"
								value="${records.SOURCE_PATH}" />
						</div>
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label for="url" class="col-sm-4 control-label"> 大图地址： </label>
						<div class="col-sm-7">
							<div id="path1"></div>
							<input type="hidden" id="largePath" value="${records.LARGE_PATH}" />
							<input type="hidden" id="serverUrl" value="${records.SERVER_URL}" />
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="name" class="col-sm-4 control-label"> 商品单位： </label>
						<div class="col-sm-7">${records.UOM}</div>
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label for="url" class="col-sm-4 control-label"> 商品进价： </label>
						<div class="col-sm-7">${records.PUR_PRICE}</div>
					</div>
				</div>
			</div>


			<div class="row">
				<div class="col-xs-5">
					<div class="form-group">
						<label for="name" class="col-sm-4 control-label"> 折扣： </label>
						<div class="col-sm-7">${records.POS_DISC_NUM}</div>
					</div>
				</div>
				<div class="col-xs-5">
					<div class="form-group">
						<label for="url" class="col-sm-4 control-label"> 零售净价： </label>
						<div class="col-sm-7">${records.POS_NET_PRICE}</div>
					</div>
				</div>
			</div>




		</div>

		<div class="marTop">

			<button type=button class="btn btn-info edit"
				style="margin-right:150px;margin-left:150px;"
				onclick='editStatus("${records.UUID}","Y")'>审核成功</button>
			<button type=button class="btn btn-info edit"
				onclick='editStatus("${records.UUID}","N")'>审核失败</button>

		</div>
	</form>
	</div>
	[/#list]


</body>
<SCRIPT type="text/javascript">
	    function editStatus(obj,status){
			$.jBox.confirm("确认修改吗?", "提示", function(v){
			if(v == 'ok'){
				  if (mgt_util.validate(queryForm)){
			 	$.ajax({
				  	url : '${base}/PutawayCheck/updateCheckStatus.jhtml',
					method:'post',
					dataType:'json',
					data : 'id=' + obj+'&status='+status,
					sync:false,
					error : function(data) {
					alert("网络异常");
					return false;},
					success : function(data) {
					if(data.code==001){		
						top.$.jBox.tip('保存成功！', 'success');
						top.$.jBox.refresh = true;
						mgt_util.closejBox('jbox-win');
						}
						else{
						top.$.jBox.tip('保存失败！平台商品库维护未审核通过', 'error');
								return false;
						}
					}
				});	
			}}});
}
	   
	    $(document).ready(function(){
	    	/* var data=$("#catId").val();
	    	if(data!=null){
				var ared="";
				 $.ajax({
				 	url:'${base}/category/getCatAll.jhtml',
					async: false,
					type : 'post',
					dataType : "json",
					data :{catId:data},
					success : function(datas) {
						ared= datas.data;
						document.getElementById("catId1").innerHTML=ared;
					}
				});
				
			} */
	    	
	    	 var server=$("#serverUrl").val();
	  	     var sourcePath=$("#largePath").val();
	    	 var sourcePath1=$("#sourcePath").val();
	    	 var path1="path1";
	    	 var path2="path2";
	    	 getImage(sourcePath,path1,server);
	    	 getImage(sourcePath1,path2,server);

	    });

	    function getImage(sourcePath1,path2,server){
	    	 if(sourcePath1!=null){
			    	var str= new Array();   
			    	  var str=sourcePath1.split(",");
			    	  if(str.length>0){
			    		  var ul = document.getElementById(path2);
			    	  for(var i=0;i<str.length;i++){
			    　　　             	  var li = document.createElement("li");
			    　　　             	  var img = document.createElement("img");
			    　　　             	  img.setAttribute("width", "100");
			    　　　             	  img.setAttribute("height", "100");
			    　　　             	    　img.src = server+"/"+str[i];
			    　　　             	    　li.appendChild(img);
			    　　　             	    　ul.appendChild(li);
			    		 }
			    		  
			    	  }
			    }
	    }
	    
	</SCRIPT>
</html>