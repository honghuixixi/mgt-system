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
		<form class="form-horizontal" id="form" action="${base}/prom/editProm.jhtml" method="POST">
			<input type="hidden"id="pkNo" name="pkNo"  value="${prom.pkNo}" >

			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger"   data-toggle="jBox-call" data-fn="checkForm1" >保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>
 
 	        <div class="page-content">
 	        <div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="endDate" class="col-sm-4 control-label">
								促销方式：
							</label>
							<div class="col-sm-7">
								<select class="form-control required" id="masCode" name="masCode"  readonly=true  >
								[#if prom.masCode=='WEBPROMA'] 
									<option value="WEBPROMA">单款打折</option>
								[#elseif prom.masCode=='WEBPROMB'] 
									<option value="WEBPROMB">买赠</option>
								[#else]
								<option value="${prom.masCode }">${prom.masCode }</option>
								[/#if]
								</select>
								</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="beginDate" class="col-sm-4 control-label">
								活动名称：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="refNo" name="refNo" class="form-control required"  value="${prom.refNo}"/> 
							</div>
						<span class="help-inline col-sm-1">*</span>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="beginDate" class="col-sm-4 control-label">
								开始时间：
							</label>
							<div class="col-sm-7">
		                    <input type="text" id="beginDate" name="beginDate" class="form-control required" value="${prom.beginDate?string("yyyy-MM-dd")}"  style="width:181px;"  readonly=true /> 
							</div>
						</div>
					</div>
					<div class="col-xs-5">
						<div class="form-group">
							<label for="endDate" class="col-sm-4 control-label">
								结束时间：
							</label>
							<div class="col-sm-7">
		      				<input type="text" id="endDate" name="endDate" class="form-control required "  value="${prom.endDate?string("yyyy-MM-dd")}"  style="width:181px;"  readonly=true  />
							</div>
						</div>
					</div>
				</div>
				<div class="row">
				
								<div class="col-xs-5">
						<div class="form-group">
							<label for="thumbnail" class="col-sm-4 control-label">
								图片：
							</label>
							<div class="col-sm-7">
									<input type="file"  class="form-control input-sm"  name="thumbnail" id="thumbnail"   />
							<img alt="" src="${prom.thumbnail }" width="60" height="60s">
							</div>
						</div>
					</div>
					</div>
				 

	 <div class="row">
					<div class="col-xs-5">
						<div class="form-group">
							<label for="spNote" class="col-sm-4 control-label">备注：</label>
						    <div class="col-sm-7">
					            <textarea class="form-control" style="width: 531px; height: 164px;" name="spNote" id="spNote" maxlength=300>${prom.spNote}</textarea>
						    </div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</body>
</html>
<script>
function checkForm1(){
	if (mgt_util.validate(form)){
		var thumbnail = $("#thumbnail");
		  if(thumbnail.val()!=null&&thumbnail.val()!=''){
        if (!/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(thumbnail.val())) {  
        	$.jBox.tip("图片类型必须是.gif,jpeg,jpg,png中的一种","error");  
            return;  
        }  
 
         else
        {
        	var file = thumbnail.get(0).files[0];
            var fileSize = 0; 

            if (file.size > 1024 * 1024)
            	{
//             	fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB'; 
			fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString();
            	if(fileSize>10){
            		$.jBox.tip("图片过大，上传文件不能超过10M","error");
            		return;
            	}
            	}
            else {
            fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB'; 
            }
//             alert( filesize);
//             alert(file.name);
//             alert(file.type);
          }
		  }
		$('#form').ajaxSubmit({
			success: function (html, status) {
					if(html.code == '001'){
	   					top.$.jBox.tip('保存成功！', 'success');
	   					top.$.jBox.refresh = true;
	   					mgt_util.closejBox('jbox-win');
	   		        }
					else if(html.code == '002'){
	   		        	 $.jBox.tip('上传图片失败！');
	   		        	 return;
	   		        }
	   		        else{
	   		        	$.jBox.tip('未知错误！');
	   		        	 return;
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
</script>