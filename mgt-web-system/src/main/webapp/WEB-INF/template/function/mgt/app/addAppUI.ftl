<!DOCTYPE html>
<html>
	<head>
		<title>菜单新增</title>
		[#include "/common/commonHead.ftl" /]
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
		<form class="form-horizontal" id="form" action="${base}/app/addApp.jhtml" enctype="multipart/form-data"method="POST">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" data-toggle="jBox-call" data-fn="checkForm">保存
				    <i class="fa-save align-top bigger-125 fa-on-right"></i>
			    </button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 	        <div class="page-content">
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">

							<label for="picUrl" class="col-sm-4 control-label">
							上传文件:
							</label>
							
		      					<div class="col-sm-7">
									<input type="file"  class="form-control input-sm"  name="picUrl" id="picUrl"   />
							</div>
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="appName" class="col-sm-4 control-label">
								名字：
							</label>
							<div class="col-sm-7">
		      					<input type="text" id="appName" name="appName" class="form-control"/>
							</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="forceFlg" class="col-sm-4 control-label">
								强制更新：
							</label>
							<div class="col-sm-7">
		      					<input type="radio" name="forceFlg" value="Y" checked=checked/>是
								<input type="radio" name="forceFlg" value="N"  />否
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="verLog" class="col-sm-4 control-label">
								备注：
							</label>
							<div class="col-sm-7">
		      					<textarea id="note" name="verLog"  class="form-control " style="width: 531px; height: 164px;" maxlength=300></textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		</form>
	</body>
</html>
   <script>
    
    function checkForm(){
    	if (mgt_util.validate(form)){
    		$('#form').ajaxSubmit({
    			success: function (html, status) {
    						top.$.jBox.tip(html.msg, 'success');
    						top.$.jBox.refresh = true;
    						mgt_util.closejBox('jbox-win');
    					},error : function(data){
    						top.$.jBox.tip('系统异常！', 'error');
    						top.$.jBox.refresh = true;
    						mgt_util.closejBox('jbox-win');
    						return;
    					}
    		});
    	}
    	
	}
    </script>