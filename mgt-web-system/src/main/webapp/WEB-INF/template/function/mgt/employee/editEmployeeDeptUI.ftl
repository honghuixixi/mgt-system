<!DOCTYPE html>
<html>
	<head>
		<title>用户新增</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
	</head>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" method="post"
			action="${base}/employee/editEmployeeDept.jhtml">
			
			<input type="hidden" name="ids"  value="${ids}" / >
			<div class="navbar-fixed-top" id="toolbar">
				<span class="btn" >
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</span>
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
			<div class="page-content">
			 
				<div class="row">
		 
							<div class="col-xs-5" >
				        <div class="form-group">
							<label for="picUrl" class="col-sm-4 control-label">
								所属部门：
							</label>
							<div class="col-sm-7">
								<input id="citySelsss" name="citySel" type="text"  class="form-control required" readonly  onclick="Yhxutil.ztree.showMenu(this);" />
								<input id="citySelCodess" name="citySelCode" type="hidden"  />	
							</div>
					<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				 
				
		 	<div id="menuContentss" class="menuContent" style="display:none; position: absolute;z-index:100000">
					<ul id="treeDemoss" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
				</div>
		 	 
		</form>
			 
	</body>
</html>
<script>
var datas = {
	id:'ids',
	name:'names'
}
var param = {
	url:'${base}/department/deptList.jhtml',
	data:datas,
	//true 多选   false 单选
	MultiCheck:false,
	inputId:'citySelCodess',
	inputName:'citySelsss',
	MenuId:'menuContentss',
	treeId:'treeDemoss'   
}
 
Yhxutil.ztree.doInit(param);
function checkForm1(){
	if (mgt_util.validate(form)){
		$('#form').ajaxSubmit({
			success: function (html, status) {
				var html = jQuery.parseJSON(html);
					if(html.code == 'userNumberIsExist'){
	   		        	 $.jBox.tip('登录账号已经存在！');
	   		        	 return;
	   		        }else{
	   					top.$.jBox.tip('保存成功1！', 'success');
	   					top.$.jBox.refresh = true;
	   					mgt_util.closejBox('jbox-win');
	   			    }
			},error : function(data){
				top.$.jBox.tip('系统异常！', 'error');
				top.$.jBox.refresh = true;
				mgt_util.closejBox('jbox-win');
				return;
			}
		});
     }
}

function checkForm(){
	if (mgt_util.validate(form)){
		mgt_util.submitForm('#form');
	}
}
</script>