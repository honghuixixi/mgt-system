<!DOCTYPE html>
<html>
	<head>
		<title>资源新增</title>
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
		<form class="form-horizontal" id="form"
			action="${base}/category/edit.jhtml">
						<input type="hidden" id="catId" name="catId" value="${category.catId}">
						<input type="hidden" id="orgNo" name="orgNo" value="${category.orgNo}">
						<input type="hidden" id="sortNo" name="sortNo" value="${category.sortNo}">
						<input type="hidden" id="createDate" name="createDate" value="${category.createDate}">
			<div class="navbar-fixed-top" id="toolbar">
					<button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form">保存
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
							<label for="name" class="col-sm-4 control-label">
								分类名称：
							</label>
							<div class="col-sm-7">
								<input type="text" class="form-control input-sm required" name="catName" value="${category.catName}" maxlength=30>
							</div>
							<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
		            <div class="col-xs-5">
						<div class="form-group">
							<label for="status" class="col-sm-4 control-label"> 
							所属分类：
							</label>
							<div class="col-sm-7">
							    <input id="citySelsss" name="citySel" type="text" class="form-control " readonly value="${parentCategory.catName}" onclick="Yhxutil.ztree.showMenu(this);" />
								<input id="citySelCodess" name="citySelCode" type="hidden" value="${category.parentId}" />
						    </div>
					    </div>
				    </div>
				</div>
		 
 			    <div id="menuContentss" class="menuContent" style="display:none; position: absolute;z-index:100000">
		           <ul id="treeDemoss" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
		        </div>
			</div>
		</form>
	</body>
</html>
 