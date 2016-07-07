<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>价格本管理-新增价格本</title>
        [#include "/common/commonHead.ftl" /]
       	<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/js/dateUtil.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/tabData.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.jqGrid.src.js"></script>	
       	<script type="text/javascript" src="${base}/scripts/lib/My97DatePicker/WdatePicker.js"></script>
	   <script  type="text/javascript">
	    $(document).ready(function(){
		    $("#configure_base").show();
		    $("#configure_mas").hide();
		    $("#configure_cust").hide();
	    	
			$("li.sub_status_but").on("click",function() {
				$('#grid-table').GridUnload();
				if("configureBase" == $(this).attr("id")) { 
					$("li.sub_status_but").removeClass("active");
		    		$(this).addClass("active");
		    		$("#configure_mas").hide();
		    		$("#configure_cust").hide();
		    		$("#configure_base").show();
				} 
				if("configureMas" == $(this).attr("id")) { 
					if($("#pk_no").val() != ''){
						$("li.sub_status_but").removeClass("active");
			    		$(this).addClass("active");
			    		$("#configure_mas").show();
			    		$("#configure_cust").hide();
			    		$("#cust_code_name").val("请输入客户编码或名称");
			    		$("#configure_base").hide();
			    		mgt_util.jqGrid('#grid-table',{
			    			postData:{pbMasPkNo:$("#pk_no").val()},
							url:'${base}/priceBook/getStkMasByPkNo.jhtml',
							multiselect:false,
							cellEdit:true,
							/* 
							cellsubmit:'remote',
							cellurl:"${base}/priceBookItem/edit.jhtml", 
							*/
							colNames:['','','条码','商品名称','商品品牌','商品分类','零售单位','参考价','价格','','优惠价','操作'],
							colModel:[	 
								{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
								{name:'STK_FLG',index:'STK_FLG',width:0,hidden:true,key:true},
								{name:'PLU_C',align:"center",index:'PLU_C',width:'12',key:true},
								{name:'NAME',align:"center",index:'NAME',width:'15',key:true},
								{name:'BRANDNAME',align:"center",index:'BRANDNAME',width:'7',key:true},
								{name:'CATCNAME',align:"center",index:'CATCNAME',width:'7',key:true},
								{name:'STD_UOM',align:"center",index:'STD_UOM',width:'6',key:true},
								{name:'LIST_PRICE',align:"center",index:'LIST_PRICE',width:'7',key:true},
								{name:'NET_PRICE',align:"center",width:'7',key:true},
								{name:'NEW_NET_PRICE',align:"center",hidden:true},
								{name:'NEW_NEW_NET_PRICE',align:"center",width:'7',/* editable:true,edittype:'text', */
									formatter:function(data,row,index){
										return '<input id="'+index.PK_NO+'" value="'+index.NEW_NET_PRICE+'" onblur=validateEditPriceBookItem("'+index.PK_NO+'","'+row.rowId+'",this); />';
								}},
								{name:'',align:"center",width:'7',formatter:function(data,row,index){
									return '<button type="button" class="btn btn-info del"   onClick=deletePriceBookItem("'+index.PK_NO+'")  href="${base}/priceBookItem/delete.jhtml">删除</button>';
								}}
							  ],
							  /* beforeSubmitCell : function(rowid,celname,value,iRow,iCol) {
								  var error = "0";
								  var errorMsg = "";
								  var rowData = $("#grid-table").jqGrid('getRowData',rowid);
								  if(!isNaN(value)){
									  if(parseFloat(value) > parseFloat(rowData.NET_PRICE)){
										  error = "1";
										  errorMsg = "输入的优惠价必须小于净价!";
									  }else if(value < 0){
										  error = "1";
										  errorMsg = "输入的优惠价必须大于0!";
									  }
								  }else{
									  error = "1";
									  errorMsg = "输入的优惠价必须小于净价!";
								  }
								  var val = {pkNo:rowData.PK_NO,newNetPrice:value,error:error,errorMsg:errorMsg};
								  return val; 
							  },
							  afterSubmitCell:function(serverresponse,rowid,celname,value,iRow,iCol){
								  var data = eval("("+serverresponse.responseText+")")
								  if(data.success){
									  top.$.jBox.tip('编辑成功!','success');
									  
								  }else{
									  top.$.jBox.tip(data.msg,'error');
								  }
								  $("#grid-table").jqGrid('setGridParam',{  
								        datatype:'json', 
								        postData:{
								        	pbMasPkNo:$("#pk_no").val(),
								        	keyword:$("#mas_code_name").val()=='请输入条码或商品名称'?'':$("#mas_code_name").val()
								        },
								        page:1  
								 }).trigger("reloadGrid");
							  }, */
							  gridComplete:function(){ 
								cache=$(".ui-jqgrid-bdivFind").height();
								tabHeight($(".ui-jqgrid-bdiv").height());
							  }
						});
					}else{
						top.$.jBox.tip("请先保存价格本基本信息!");
					}
				}
				if("configureCust" == $(this).attr("id")) { 
					if($("#pk_no").val() != ''){
						$("li.sub_status_but").removeClass("active");
			    		$(this).addClass("active");
			    		$("#configure_mas").hide();
			    		$("#mas_code_name").val("请输入条码或商品名称");
			    		$("#configure_cust").show();
			    		$("#configure_base").hide();
			    		mgt_util.jqGrid('#grid-table',{
			    			  postData:{pbMasPkNo:$("#pk_no").val()},
							  url:'${base}/priceBook/getStkCustByPkNo.jhtml',
							  multiselect:false,
							  colNames:['','客户编码','客户名称','类型','地区','地址','操作'],
							  colModel:[	
									{name:'PK_NO',align:"center",index:'PK_NO',width:'10',hidden:true,key:true},
									{name:'CUST_CODE',align:"center",index:'CUST_CODE',width:'10',hidden:false,key:true},
									{name:'CUST_NAME',align:"center",index:'CUST_NAME',width:'12',key:true},
									{name:'CAT_NAME',align:"center",index:'CUST_TYPE',width:'10',key:true},
									{name:'AREA_NAME',align:"center",index:'AREA_ID',width:'8',key:true},
									{name:'CRM_ADDRESS1',align:"center",index:'crmAddress1',width:'15',key:true},
									{name:'',align:"center",width:'10',formatter:function(data,row,index){
										return '<button type="button" class="btn btn-info del"   onClick=deletePriceBookCust("'+index.PK_NO+'")  href="${base}/priceBookCust/delete.jhtml">删除</button>';
									}}
							  ],
							  gridComplete:function(){ 
								cache=$(".ui-jqgrid-bdivFind").height();
								tabHeight($(".ui-jqgrid-bdiv").height());
							  }
						});
					}else{
						top.$.jBox.tip("请先保存价格本基本信息!");
					}
				}
				
				//监听输入框回车
				$('#mas_code_name').bind('keydown', function(e) {
					 var theEvent = e || window.event;    
				     var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
				     if(code == 13) { 
				    	 $("#mas_code_name").blur();
				    	 $("#configure_mas_search").click();
				     }
				 });
				//监听输入框回车
				$('#cust_code_name').bind('keydown', function(e) {
					 var theEvent = e || window.event;    
				     var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
				     if(code == 13) { 
				    	 $("#cust_code_name").blur();
				    	 $("#configure_cust_search").click();
				     }
				 });
			});
			
			//配置商品搜索
			$("#configure_mas_search").click(function(){
				$("#grid-table").jqGrid('setGridParam',{  
			        datatype:'json', 
			        postData:{
			        	pbMasPkNo:$("#pk_no").val(),
			        	keyword:$("#mas_code_name").val()=='请输入条码或商品名称'?'':$("#mas_code_name").val()
			        },
			        page:1  
			 	}).trigger("reloadGrid");
			});
			
			//配置客户搜索
			$("#configure_cust_search").click(function(){
				$("#grid-table").jqGrid('setGridParam',{  
			        datatype:'json', 
			        postData:{
			        	pbMasPkNo:$("#pk_no").val(),
			        	keyword:$("#cust_code_name").val()=='请输入客户编码或名称'?'':$("#cust_code_name").val()
			        },
			        page:1  
			 	}).trigger("reloadGrid");
			});
		})
		
	    //添加平台商品
	    function addStkMas(){
    		mgt_util.showjBox({
				width : 800,
				height : 500,
				title : '添加商品',
				url : '${base}/priceBook/addStkMasUI.jhtml?mas_pk_no='+$("#pk_no").val(),
				grid : $('#grid-table')
    		});
	    }
	    
	    //添加客户
	    function addStkCust(){
	    	mgt_util.showjBox({
				width : 800,
				height : 500,
				title : '添加客户',
				url : '${base}/priceBook/addStkCustUI.jhtml?mas_pk_no='+$("#pk_no").val(),
				grid : $('#grid-table')
    		});
	    }
	    
	    //删除价格本中的商品
	    function deletePriceBookItem(item_pk_no){
	    	$.jBox.confirm("确认删除该商品吗?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在删除数据，请稍等...');
					$.ajax({
						url : '${base}/priceBookItem/delete.jhtml',
						type :'post',
						dataType : 'json',
						data : 'id=' + item_pk_no,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								if (s) {
									top.$.jBox.tip('删除成功！','success');
									mgt_util.refreshGrid($("#grid-table"));
								}
							});
						}
					});
				}
		    });
	    }
	  
	    //验证编辑价格本商品优惠价
	    function validateEditPriceBookItem(pkNo,rowid,inputObj){
	    	var rowData = $("#grid-table").jqGrid('getRowData',rowid);
	    	var error = "0";
			var errorMsg = "";
			var rowData = $("#grid-table").jqGrid('getRowData',rowid);
			var newValue = inputObj.value;
			if(rowData.NEW_NET_PRICE == $.trim(newValue)){
				//未修改
				return;
			}else{
				if(!isNaN(newValue)){
					if(parseFloat(newValue) > parseFloat(rowData.NET_PRICE)){
						top.$.jBox.tip('输入的优惠价必须小于价格!','error');
						$("#grid-table").jqGrid('setGridParam',{}).trigger("reloadGrid");
						return;
					}else if(newValue <= 0){
						top.$.jBox.tip('输入的优惠价必须大于0!','error');
						$("#grid-table").jqGrid('setGridParam',{}).trigger("reloadGrid");
						return;
					}else if(typeof(newValue.split(".")[1]) != 'undefined' && newValue.split(".")[1].toString().length > 2){
						top.$.jBox.tip('优惠价最多输入两位小数','error');
						$("#grid-table").jqGrid('setGridParam',{}).trigger("reloadGrid");
						return;
					}
				}else{
					top.$.jBox.tip('输入的优惠价必须是数字!','error');
					$("#grid-table").jqGrid('setGridParam',{}).trigger("reloadGrid");
					return;
				}
				editPriceBookItem(pkNo,newValue);
			}
	    }
	    
	    //编辑价格本商品优惠价
	    function editPriceBookItem(pkNo,newNetPrice){
	    	$.jBox.confirm("确认修改该商品优惠价吗?", "提示", function(v){
	    		if(v == 'ok'){
	    			$.ajax({
						url : '${base}/priceBookItem/edit.jhtml',
						type :'post',
						dataType : 'json',
						data : {"pkNo":pkNo,"newNetPrice":newNetPrice},
						success : function(data) {
							if(data.success){
							  top.$.jBox.tip(data.msg,'success');
						  	}else{
							  top.$.jBox.tip(data.msg,'error');
						  	}
							$("#grid-table").jqGrid('setGridParam',{}).trigger("reloadGrid");
						}
					});
	    		}
	    	});
	    }
	   
	  	//删除价格本中的客户
	    function deletePriceBookCust(cust_pk_no){
	    	$.jBox.confirm("确认删除该客户吗?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在删除数据，请稍等...');
					$.ajax({
						url : '${base}/priceBookCust/delete.jhtml',
						type :'post',
						dataType : 'json',
						data : 'id=' + cust_pk_no,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								if (s) {
									top.$.jBox.tip('删除成功！','success');
									mgt_util.refreshGrid($("#grid-table"));
								}
							});
						}
					});
				}
		    });
	    }
        
		</script>
    </head>
    <body>
       <div class="body-container">
          <div class="main_heightBox1">
       		<div id="currentDataDiv" action="menu" >
	            <form class="form form-inline queryForm" style="overflow:hidden;" id="query-form"> 
					<div class="control-group sub_status" style="position:relative;">
						<ul class="nav nav-pills" role="tablist">
							<li role="presentation" id="configureBase" class="sub_status_but active"><a href="#"> 基本信息</a></li>					
							<li role="presentation" id="configureMas" class="sub_status_but"><a href="#"> 配置商品</a></li>	
							<li role="presentation" id="configureCust" class="sub_status_but"><a href="#"> 配置客户</a></li>					
						</ul>
					</div>
				</form>
					<!-- 基本信息 -->
					<div id="configure_base" style="display:block">
						<div class="page-content" style="margin-top:10px;">
							<form class="form form-inline queryForm" id="form">
								<input type="hidden" id="pk_no" value="${priceBookMas.pkNo}"/>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;">
										<div class="form-group" style="width:380px;">
											<label for="pbCode" class="col-sm-7 control-label" style="width:70px;">编&nbsp;号：</label>
											<div class="col-sm-7">
												<input type="text" readOnly style="width:200px;" class="form-control input-sm" id="pbCode" maxlength=65 name="pbCode" value="${priceBookMas.pbCode}" >
											</div>
											<!-- <span class="help-inline col-sm-1" style="padding-top:15px;">*</span> -->
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;">
										<div class="form-group" style="width:380px;">
										    <label for="pbName" class="col-sm-7 control-label" style="width:70px;">名&nbsp;称：</label>
											<div class="col-sm-7">
												<input type="text" style="width:200px;" class="form-control input-sm required" id="pbName" maxlength=30 name="pbName" value="${priceBookMas.pbName}" >
											</div>
											<span class="help-inline col-sm-1" style="padding-top:15px;">*</span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;display:inline-block;">
										<div class="form-group" style="width:380px;">
										    <label for="pbName" class="col-sm-7 control-label" style="width:70px;">有效期：</label>
											<div class="col-sm-7" style="display:inline-block;">
												<input type="text" id="dateFrom" name="dateFrom" maxlength=30 style="width:200px;height:30px;" value="${(priceBookMas.dateFrom?string('yyyy-MM-dd'))!''}" class="form-control input-sm required">
												<script type="text/javascript"> 
												$(function(){
											         $("#dateFrom").bind("click",function(){
											             WdatePicker({doubleCalendar:true,dateFmt:'yyyy-MM-dd',autoPickDate:true,onpicked:function(){dateTo.click();}});
											         });
											         $("#dateTo").bind("click",function(){
											             WdatePicker({doubleCalendar:true,minDate:$('#dateFrom').val(),dateFmt:'yyyy-MM-dd',autoPickDate:true});
											         });
												});
												</script>
											</div>
											<span class="help-inline col-sm-1" style="padding-top:15px;">*</span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;">
										<div class="form-group" style="width:380px;">
											<label for="dateTo" class="col-sm-7 control-label" style="width:70px;">&nbsp;&nbsp;至：</label>
										    <div class="col-sm-7">
									           <input type="text" id="dateTo" name="dateTo" maxlength=30 style="width:200px;height:30px;" value="${(priceBookMas.dateTo?string('yyyy-MM-dd'))!''}" class="form-control input-sm required">
										    </div>
										    <span class="help-inline col-sm-1" style="padding-top:15px;">*</span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;margin-top:10px;">
										<div class="form-group" style="width:100%;">
											<label for="pbNote" class="col-sm-7 control-label" style="width:70px;">描&nbsp;述：</label>
										    <div class="col-sm-7">
									            <textarea class="form-control input-sm required" style="width:313px;height:100px;" name="pbNote" id="pbNote">${priceBookMas.pbNote}</textarea>
										    </div>
										     <span class="help-inline col-sm-1" style="padding-top:15px;margin-left:45px;">*</span>
										</div>
									</div>
								</div>
								<div class="row">
								<div class="form-group" style="margin-right:10px;padding-left:115px;padding-top:35px;">
									<button class="btn btn-danger" id="submitBtn" data-toggle="jBox-call" onClick="checkForm();">保存提交 
									    <i class="fa-save align-top bigger-125 fa-on-right"></i>
								    </button>
			               	 	</div>
							</div>
							</form>
						</div>
					</div>
					<!-- 配置商品 -->
					<div id="configure_mas" style="display:none">	
			            <div class="form_divBox" style="display:block;border-bottom:solid 1px #f39801;height:50px;">
				            <form class="form form-inline queryForm" id="query-form_1"> 
				                <label class="control-label" style="width:60px;">关键词：</label>
				                <div class="form-group">
				                	<input type="text" class="form-control" id="mas_code_name" name="keyword" style="width:170px" value="请输入条码或商品名称" class="form-control" onfocus="if(value=='请输入条码或商品名称') {value=''}" onblur="if (value=='') {value='请输入条码或商品名称'}">
		                		</div>
		                		<div class="form-group">
				                 	<button type="button" class="search_cBox_btn" id="configure_mas_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
				                </div>
				            </form>
				        </div>
				        <!-- <div class="search_cBox" style="margin-bottom:42px;">
				        	<div class="form-group">
				        		<button type="button" class="search_cBox_btn btn btn-info" id="order_search"  onclick="expAttStatStart()"> 保存提交 </button>
			                </div>
				        </div>  -->
				        <div class="form_divBox" style="display:block;">
				        	<label class="control-label" style="width:60px">商品清单</label>
				        </div>
				       	<div class="search_cBox">
				        	<div class="form-group">
			                 	<button type="button" class="search_cBox_btn btn btn-info" onclick="addStkMas()" id="role_search" data-toggle="jBox-query">添加商品 </button>
			                </div>
				        </div>
           			</div>
	            	<!-- 配置客户 -->
	            	<div id="configure_cust" style="display:none">
	            		<div class="form_divBox" style="display:block;border-bottom:solid 1px #f39801;height:50px;">
				            <form class="form form-inline queryForm" id="query-form-2"> 
				                <label class="control-label" style="width:60px;">关键词：</label>
				                <div class="form-group">
				                	<input type="text" class="form-control" id="cust_code_name" name="keyword" style="width:170px" value="请输入客户编码或名称" class="form-control" onfocus="if(value=='请输入客户编码或名称') {value=''}" onblur="if (value=='') {value='请输入客户编码或名称'}">
		                		</div>
		                		<div class="form-group">
				                 	<button type="button" class="search_cBox_btn" id="configure_cust_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
				                </div>
				            </form>
				        </div>
				        <div class="form_divBox" style="display:block;">
				        	<label class="control-label" style="width:60px">客户清单</label>
				        </div>
				       	<div class="search_cBox">
				        	<div class="form-group">
			                 	<button type="button" class="search_cBox_btn btn btn-info" onclick="addStkCust()",id="role_search" data-toggle="jBox-query"> 添加客户  </button>
			                </div>
				        </div>
	            	</div>
	        </div>
	      </div>
	      <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>
<script type="text/javascript">
	function checkForm(){
		if (mgt_util.validate(form)){
			//新增价格本
			if($("#pk_no").val()=='' && $("#pbCode").val() == ''){
				$.ajax({
					url:'${base}/priceBook/findByNameFlag.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					data :{pbName:$("#pbName").val()},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						if(data.data){
							submit();
						}else{
							alert("价格本名称已存在");
							return false;
						}
					}
				});
			}else{
				//修改价格本,验证价格本名称
				$.ajax({
					url:'${base}/priceBook/findByPkNo.jhtml',
					sync:false,
					type : 'post',
					dataType : "json",
					data :{pkNo:$("#pk_no").val()},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) {
						if($("#pbName").val() != data.pbName){
							$.ajax({
								url:'${base}/priceBook/findByNameFlag.jhtml',
								sync:false,
								type : 'post',
								dataType : "json",
								data :{pbName:$("#pbName").val()},
								error : function(data) {
									alert("网络异常");
									return false;
								},
								success : function(item) {
									if(item.data){
										submit();
									}else{
										alert("价格本名称已存在");
										return false;
									}
								}
							});
						}else{
							submit();
						}
					}
				});
			}
	    }
	}
	function checkByName(){
		$.ajax({
			url:'${base}/priceBook/findByNameFlag.jhtml',
			sync:false,
			type : 'post',
			dataType : "json",
			data :{pbName:$("#pbName").val()},
			error : function(data) {
				alert("网络异常");
				return false;
			},
			success : function(data) {
				if(data.success){
					return true;
				}else{
					alert("价格本名称已存在");
					return false;
				}
			}
		});
	}
	
	function submit(){
		$("#submitBtn").attr('disabled', 'disabled');
		$.ajax({
			url:'${base}/priceBook/add.jhtml',
			sync:false,
			type : 'post',
			dataType : "json",
			data :{
				pkNo:$("#pk_no").val(),
				pbCode:$("#pbCode").val(),
				pbName:$("#pbName").val(),
				dateFrom:$("#dateFrom").val(),
				dateTo:$("#dateTo").val(),
				pbNote:$("#pbNote").val()
			},
			error : function(data) {
				alert("网络异常");
				$("#submitBtn").removeAttr('disabled');
				return false;
			},
			success : function(data) {
				if(data.success){
					$("#pk_no").val(data.data.pkNo);
					$("#pbCode").val(data.data.pbCode);
					top.$.jBox.tip(data.msg);
				}else{
					top.$.jBox.tip(data.msg);
					return false;
				}
				$("#submitBtn").removeAttr('disabled');
			}
		});
	}
</script>
