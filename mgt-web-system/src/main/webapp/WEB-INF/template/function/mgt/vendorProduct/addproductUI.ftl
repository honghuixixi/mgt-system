<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商品信息管理</title>
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
	<style type="text/css">
		.control-label{white-space:nowrap;}
		.finishSt_table tr td{padding:10px 0;}
		.col-sm-3{width:auto;padding-right:5px;}
	</style>
   <script  type="text/javascript">
   		//页面加载时触发jq富文本编辑框插件				
		var editor;
		KindEditor.ready(function(K) {
			editor = K.create('#kindcontent', {
				filePostName: "file",
				uploadJson: "${base}/upload/imageUpload.jhtml?type=Y",
				allowFileManager : true,
				afterChange: function() {
					this.sync();
				}
			});
		});
		
		//chosen插件初始化，绑定元素
		$(function(){
    		$("#BRAND_C").chosen();
		});	
   
		$(document).ready(function(){
			//隐藏后两步div
			$("#step1").hide();
			$(".box-revise").hide();
			
			$("#levela").click(function(){
				var val = $(this).val();
				addOption($("#levelb"),val);
				$("#catId").empty();
			});
			$("#levelb").change(function(){
				var val = $(this).val();
				addOption($("#catId"),val);
			});
			
			//商家编码是否存在
			jQuery.validator.addMethod("vendorStkCExt", function(value, element) { 
			var flg;
				$.ajax({
					url: '${base}/vendorPro/checkvendorstkc.jhtml?vendorStkC='+value,
					type: 'GET',
					cache: false,
					async: false,
					success: function(data) {
						if (data.ex == 'N') {
							flg = true;
						}else{
							flg = false ;
						}
					}
				});
				return flg;
			}, "该编码已存在");
			
			//校验条码，匹配刷新页面
			$("#PLU_C").change(function(){
				checkPlu($(this).val());
			});
							
			function checkPlu(pluC){
				$.ajax({
					url: '${base}/vendorPro/checkpluc.jhtml?pluC='+pluC+'&bcFlg=${bcFlg}',
					type: 'GET',
					cache: false,
					async: false,
					success: function(data) {
						if (data.ex == 'N') {
							$("#NAME").val("");
							$("#NAME").attr("disabled",false);
							$("#STD_UOM").val("");
							$("#VENDOR_STK_C").val("");
							$("#VENDOR_CAT_C").val("");
							$("#STD_UOM").attr("disabled",false);
							$("#BRAND_C").val("");
							$("#BRAND_C").attr("disabled",false);
							$("#BRAND_C").chosen();
							$('#xiangqing').show();
							$('#xiangqingImg').html("");
							
							var catId = $("#catId").val();
							getCat(catId);
							$('#globalFlg').val('N')
							//$("#packTab").empty();
							$("#packTab tbody").html("");
							$("#uploadBox").show();
							$(".fileBtn").show();
							$(".imgclass").remove();
						}else{
							 $('#globalFlg').val('Y')
							 $.each(data, function(value, name) {
							 if(value == 'stkList'){
							 	//$("#packTab").empty();
							 	$("#packTab tbody").html("");
							 	for(var i=0;i<name.length;i++){
							 		var stk = name[i];
							 		var mytime=new Date().getTime(); //获取当前时间
							 		var	baseStk = "<input type='radio' class='editRadio' id = 'baseStk' name='baseStk' value='"+stk.STK_C+"'><input type='hidden' name='stkC' value='"+stk.STK_C+"'>";
							 		if(stk.STK_NAME_EXT ==null){
							 			stk.STK_NAME_EXT = "";
							 		}
							 		var stkNameExt="<input type='text' class='pack form-control ' namestr='stkNameExt'  name='stkNameExt"+mytime+"' value='"+stk.STK_NAME_EXT+"'/>";
							 		
									var modle="<input type='text' class='pack form-control required' namestr='modle'  name='modle"+mytime+"' value='"+stk.MODLE+"'/>";
									var packUom="<input type='text' class='pack form-control required uomLength' namestr='packUom' value='"+stk.UOM+"' name='packUom"+mytime+"' />";
									var packCode="<input type='text' style='width:100px;' class='pack form-control required' maxlength='14' namestr='packCode' value='"+pluC+"' name='packCode"+mytime+"' />";
									var packQty="<input type='text' class='pack qtycls form-control number required' maxlength='14' value='"+stk.PACK_QTY+"' namestr='packQty'  name='packQty"+mytime+"'/>";
									var packListPrice="<input type='text' class='pack form-control number required' maxlength='14' value='"+stk.LIST_PRICE+"' namestr='packListPrice'  name='packListPrice"+mytime+"' />";
									var packPrice="<input type='text' class='pack form-control number required' maxlength='14' value='"+stk.NET_PRICE+"' namestr='packPrice'  name='packPrice"+mytime+"' />";
									var packNum="<input type='text' class='pack form-control number required' maxlength='9' value='"+stk.SUPPLY_QTY+"' namestr='packNum'  name='packNum"+mytime+"' />";
									var minStkLevel="<input type='text' class='pack form-control number ' maxlength='22' value='"+stk.MIN_STK_LEVEL+"' namestr='minStkLevel' name='minStkLevel"+mytime+"' />";
									var maxStkLevel="<input type='text' class='pack form-control number ' maxlength='22' value='"+stk.MAX_STK_LEVEL+"' namestr='maxStkLevel' name='maxStkLevel"+mytime+"' />";
									var minOrderQty="<input type='text' class='pack form-control number ' maxlength='22' value='"+stk.MIN_ORDER_QTY+"' namestr='minOrderQty' name='minOrderQty"+mytime+"' />";
									var th = "<tr height='40'><td>"+baseStk+"<input name='myId' id='myId' type='hidden' value='"+mytime+"'></td><td >"+stkNameExt+"</td><td >"+modle+"</td><td >"+packUom+"</td><td >"+packCode+"</td><td>"+packQty+"</td><td >"+packListPrice+"</td><td >"+packPrice+"</td><td >"+packNum+"</td><td >"+minStkLevel+"</td><td >"+maxStkLevel+"</td><td>"+minOrderQty+"</td><td ><label class='control-label'><a href='#' class='del' stkc='new'>删除</a></label></td></tr>";
							        $("#packTab").append(th);
							 	}
							 }else if(value == 'imgList'){
							 	$("#uploadBox").hide();
							 	$(".imgclass").remove();
							 	for(var i=0;i<name.length;i++){
							 		var img = name[i];
							 		var fllUrl = img.serverUrl+img.smallPath;
							 		$("#imgDiv").append('<dd class="imgclass"><img src="'+fllUrl+'" width="96" height="96" /></dd>');
							 		//TODO
							 	}
							 }else{
							 	var obj = $("#"+value);
								if(obj.is("label")){
									obj.html(name);
								}else if(value == 'THUMBNAIL'){//缩略图
									$("#file").hide();
									$('#imgsrc').attr("src",name);
								}else if(value == 'DESCRIPTION'){//详情
									$('#xiangqing').hide();
									$('#xiangqingImg').html(name);
								}else{
									obj.val(name);
									obj.parent().parent().children('span.help-inline').html("");
									if(value != 'PLU_C' && value != 'VENDOR_CAT_C' && value != 'VENDOR_STK_C'){
										obj.attr("disabled",true);
									}
									if(value == 'BRAND_C'){
										obj.chosen("destroy");
									}
								}
							 }
							});
						}
					}
				});
			}
			
			$(".use").live("click",function(){
				checkPlu($(this).attr("id"));
				$("#PLU_C").val($(this).attr("id"));
				$('div.body-container').hide();
				$(".box-revise").show();
				$("#PLU_C").attr("readonly",true);
				//去除plu_c校验
				$("#PLU_C").attr("minlength","1");
			});
			//加载查询列表
			mgt_util.jqGrid('#grid-table',{
				url:'${base}/globalPluMas/list.jhtml?bcFlg=${bcFlg}',
				colNames:['','条码','名称','零售单位','商品品牌','平台分类','操作'],
			   	colModel:[	
			   		{name:'PLU_C',index:'PLU_C',width:0,hidden:true,key:true}, 
					{name:'PLU_C',width:150},
			   		{name:'NAME',width:150},
			   		{name:'STD_UOM', width:100},
			   		{name:'BRAND_NAME', width:100},
			   		{name:'CAT_NAME', width:200},
			   		{name:'detail',index:'PLU_C',width:100,align:'center',sortable:false} 
			   	],
		   		gridComplete:function(){ //循环为每一行添加业务事件 
				var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
					for(var i=0; i<ids.length; i++){ 
						var id=ids[i]; 
						detail ="<button type='button' class='btn btn-info edit use' id='"+id+"'>使用 </button>";
						jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
					} 
				} 
			});
			$("#searchbtn").click(function(){
				//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
				//top.$.jBox.tip('删除成功！','success');
				$("#grid-table").jqGrid('setGridParam',{  
			        datatype:'json',  
			        postData:$("#queryForm").serializeObjectForm(), //发送数据  
			        page:1  
			    }).trigger("reloadGrid"); //重新载入  
			});

		});
		//使用向导
		function guide(){
			$('div.body-container').hide();
			addOption($("#levela"),0);
			$("#step1").show();
		}
		function setp2(){
			var catId = $("#catId").val();
			//判断大中小类是否为空
			if ($.isEmptyObject(catId)) {
				top.$.jBox.tip('请选择平台分类！');
				return false;
			}
			getCat(catId);
			$("#step1").hide();
			$(".col-sm-1").show();
			$(".box-revise").show();
		}
	
		//获取大中小类字符串
		function getCat(catId){
			$.ajax({
				url: '${base}/vendorPro/catestr.jhtml?catId='+catId,
				type: 'GET',
				cache: false,
				async: false,
				success: function(data) {
					$.each(data, function(value, name) {
						$("#CAT_NAME").val(name);
					});
					$("#catId").val(catId);  
				}
			});
		}
		//刷新类别select
		function addOption(select,parentId){
		 	select.empty();
		 	parentId = parentId+'';
		 	if(parentId != '0' && parentId.split(',').length>1){
		 		top.$.jBox.tip('分类不支持多选');
				return false;
		 	}
			$.ajax({
				url: '${base}/vendorPro/category.jhtml?parentId='+parentId+'&bcFlg=${bcFlg}',
				type: 'GET',
				cache: false,
				async: false,
				success: function(data) {
					if ($.isEmptyObject(data)) {
						return false;
					}
					$.each(data, function(value, name) {
						var option = $("<option>").val(value).text(name);
						select.append(option);
					});
				}
			});
		}
		
		function checkForm(){
			if (mgt_util.validate(addform)){
				 var rownum = $("#packTab tr").length;
				 if(rownum == '0'){
				 	top.$.jBox.tip('请添加包装单位！','error');
				 	return false;
				 }
				if($(".imgclass").length <1){
					top.$.jBox.tip('商品图片不能为空');
					return false;
				}
				 var baseStk = $('input[name="baseStk"]:checked').val();
				 if(typeof(baseStk) == 'undefined'){
				 	top.$.jBox.tip('请指定基准库存！','error');
				 	return false;
				 }
				 $("#baseStkC").val(baseStk);
				editName();
				var str ="";
				 $("input[name='stkNameExt']").each(function(i,val) {
					str = str+$(val).val()+",";
				});
				$("#stkNameExts").val(str);
				mgt_util.submitForm('#addform');
		  	}
		}
	</script>
    </head>
    <body>
       <div class="body-container">
			<div id="currentDataDiv" action="resource">
	            <form class="form form-inline queryForm" style="width:800px" id="query-form"> 
	                <div class="form-group">
	                    <input type="text" class="form-control" name="name" id="name" style="width:220px;"  placeholder="请输入条码或名称">
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="earch_cBox_btn" id='' data-toggle="jBox-query" ><i class="icon-search"></i> 搜 索 </button>
	                </div>
	                <div class="form-group">
	                 	<button type="button" class="btn_divBtn" id='' onclick="guide();"> 使用向导新增</button>
	                </div>
	            </form>
	        </div>
		    <table id="grid-table"></table>
		  	<div id="grid-pager"></div>
   		</div>
   		 <form class="form-horizontal" action="${base}/vendorPro/save.jhtml"  id="addform" name="addForm">
   		<div id="step1" style="padding:30px 30px 30px 100px;" action="resource">
   			<table>
	    		<tbody>
	    		</tr><tr height="30px">
	    			<td width="600px" colspan="3"><label class="control-label">选择平台分类 </label></td>
	    		</tr>
	    		<tr height="270px">
	    			
	    			<td width="200px">
	    				<select style="width:200px;height:270px" multiple="false" id="levela" name="levela">
						</select>
	    			</td>
	    			<td width="200px">
	    				<select style="width:200px;height:270px" multiple="false" id="levelb" name="levelb">
						</select>
	    			</td><td width="200px">
	    				<select style="width:200px;height:270px" multiple="false" id="catId" name="catId">
						</select>
	    			</td>
	    		</tr>
	    		</tr><tr height="30px">
	    			<td width="600px" colspan="3" align="right"><button type="button" class="btn btn-info btn_divBtn" id='' onclick="setp2();"> 确定</button></td>
	    		</tr>
	    	</tbody></table>
   		</div>
		<div class="box-revise">
   		 	<div class="box-revise-list">
   		 		<h3>基本资料</h3>
   		 		<div class="revise-padBox">
	   		 		<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td height="40" width="33%">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品条码</label>
	            			<input type="text" class="form-control required abcnb" maxlength="14" name="pluC" id="PLU_C" style="width:120px;">
                			<input type="hidden" name="editFlg" id="editFlg" value="N"/>
                			<input type="hidden" name="baseStkC" id="baseStkC"/>
                			<input type="hidden" name="bcFlg" id="bcFlg" value='${bcFlg}'/>
                			<input type="hidden" name="fullPath" id="fullPath" value=''/>
	            			<input type="hidden" name="stkNameExts" id="stkNameExts"/>
                			<input type="hidden" name="globalFlg" id="globalFlg" value="N"/>
						</td>
					    <td width=34%"" align="center">
					    	<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">最小零售单位</label>
	                		<input type="text" class="form-control required maxUomLength" maxlength="16" name="stdUom" id="STD_UOM" style="width:120px;">
					    </td>
					    <td width="33%" align="right">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品品牌</label>
	            				<select class="form-control required" style="width:120px;" name="brandC" id="BRAND_C" >
	                				<option value=''>请选择</option>
			                        [#list brandList as brand]
										<option value='${brand.id.brandC}'>${brand.name}</option>
									[/#list]
			                    </select>
						</td>
					  </tr>
					  <tr>
					    <td colspan="3">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="50%" height="40">
										<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品名称</label>
	                					<input type="text" class="form-control required nameLength" maxlength="170"  name="name" id="NAME" style="width:300px;">
									</td>
									<td align="right">
										<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">平台分类</label>
										<input type="text" readonly="readonly" class="form-control" id="CAT_NAME" style="width:310px;">
									</td>
								</tr>
							</table>
						</td>
					  </tr>
					  <tr>
					    <td height="40" width="33%;">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商家编码</label>
	                		<input type="text" class="form-control required char vendorStkCExt" maxlength="32" id="VENDOR_STK_C" name="vendorStkC" style="width:120px;">
						</td>
					    <td width="34%" align="center">
					    	<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;">商品分类</label>
	                		<select class="form-control required" name="vendorCatC" id="VENDOR_CAT_C" style="width:120px;">
                				<option value=''>请选择</option>
		                        [#list catList as cat]
									<option value='${cat.id.catC}'>${cat.name}</option>
								[/#list]
		                    </select>
					    </td>
					    <td width="33%" align="right">
							<label class="control-label" style="padding-right:10px;font-size:14px;color:#4a4a4a;"> FBP类型</label>
	                		<select class="form-control" name="ref6" style="width:120px;">
                				<option value=''>请选择</option>
		                        [#list ref6List as ref]
									<option value='${ref.REF_CODE}'>${ref.NAME}</option>
								[/#list]
		                    </select>
						</td>
					  </tr>
					</table>
				</div>
   		 	</div>
   		 	[#include "/common/imgUpload.ftl" /]
   		 	[#include "/function/mgt/vendorProduct/editPack.ftl" /]
	 		<div class="box-revise-list maT10">
   		 		<h3>商品详情</h3>
   		 		<div class="revise-padBox" id="stkDetail">
   		 			<div id="xiangqingImg" name="xiangqingImg"></div>
   		 			<div id="xiangqing" name="xiangqing"><textarea class="form-control" style="width:100%; height: 464px;" name="description" id="kindcontent"></textarea>
        			</div>
   		 		</div>
   		 	</div>
	 		<!--发布取消按钮-->
	 		<div class="upload-btnBox"><a class="upload-btna1" href="#" data-toggle="jBox-call"  data-fn="checkForm">发布</a><a href="#" onclick="mgt_util.closejBox('jbox-win');">取消</a></div>
	 	</div>
            </form>
        </div>
    </body>
</html>