<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>价格本管理-价格本详情</title>
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
							colNames:['','','条码','商品名称','商品品牌','商品分类','零售单位','标价','进价','优惠价'],
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
								{name:'NEW_NET_PRICE',align:"center",width:'7'}
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
							  colNames:['','客户编码','客户名称','类型','地区','地址'],
							  colModel:[	
									{name:'PK_NO',align:"center",index:'PK_NO',width:'10',hidden:true,key:true},
									{name:'CUST_CODE',align:"center",index:'CUST_CODE',width:'10',hidden:false,key:true},
									{name:'CUST_NAME',align:"center",index:'CUST_NAME',width:'12',key:true},
									{name:'CAT_NAME',align:"center",index:'CUST_TYPE',width:'10',key:true},
									{name:'AREA_NAME',align:"center",index:'AREA_ID',width:'8',key:true},
									{name:'CRM_ADDRESS1',align:"center",index:'crmAddress1',width:'15',key:true}
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
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;">
										<div class="form-group" style="width:380px;">
										    <label for="pbName" class="col-sm-7 control-label" style="width:70px;">名&nbsp;称：</label>
											<div class="col-sm-7">
												<input type="text" readOnly style="width:200px;" class="form-control input-sm required" id="pbName" maxlength=30 name="pbName" value="${priceBookMas.pbName}" >
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;display:inline-block;">
										<div class="form-group" style="width:380px;">
										    <label for="pbName" class="col-sm-7 control-label" style="width:70px;">有效期：</label>
											<div class="col-sm-7" style="display:inline-block;">
												<input type="text" readOnly id="dateFrom" name="dateFrom" maxlength=30 style="width:200px;height:30px;" value="${(priceBookMas.dateFrom?string('yyyy-MM-dd'))!''}" class="form-control input-sm required">
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;">
										<div class="form-group" style="width:380px;">
											<label for="dateTo" class="col-sm-7 control-label" style="width:70px;">&nbsp;&nbsp;至：</label>
										    <div class="col-sm-7">
									           <input type="text" readOnly id="dateTo" name="dateTo" maxlength=30 style="width:200px;height:30px;" value="${(priceBookMas.dateTo?string('yyyy-MM-dd'))!''}" class="form-control input-sm required">
										    </div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-5" style="margin-left:15px;margin-top:10px;">
										<div class="form-group" style="width:100%;">
											<label for="pbNote" class="col-sm-7 control-label" style="width:70px;">描&nbsp;述：</label>
										    <div class="col-sm-7">
									            <textarea readOnly class="form-control input-sm required" style="width:313px;height:100px;" name="pbNote" id="pbNote">${priceBookMas.pbNote}</textarea>
										    </div>
										</div>
									</div>
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
	            	</div>
	        </div>
	      </div>
	      <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>



