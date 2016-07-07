<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>物流管理-客户收货结果调整</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(function(){
				// Set starting slide to 1
				var startSlide = 1;
				// Get slide number if it exists
				if (window.location.hash) {
					startSlide = window.location.hash.replace('#','');
				}
				// Initialize Slides
				$('#slides').slides({
					preload: true,
					preloadImage: 'styles/css/base/css/images/loading.gif',
					generatePagination: true,
					play: 5000,
					pause: 2500,
					hoverPause: true,
					// Get the starting slide
					start: startSlide,
					animationComplete: function(current){
						// Set the slide number as a hash
						window.location.hash = '#' + current;
					}
				});
			});
			
			
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/guest/areaIdList.jhtml?areaId=${areaId}&pick=1&userNo=${userNo}',
					autowidth: false,  
					rowNum:2147483647,
					multiselect : false,
 					colNames:['','','','市/区','区县','是否可销售','是否可配送'],
				   	colModel:[
				   		{name:'AREA_ID',index:'AREA_ID',width:"20",key:true},
				   		{name:'AREA_ID2',width:0,hidden:true,key:true},
				   		{name:'CP_TYPE',width:0,hidden:true,key:true},
				   		{name:'AREA_NAME2',align:"center",width:"90",cellattr: addCellAttr},
				   		{name:'AREA_NAME',align:"center",width:"90",cellattr: addCellAttr},
				   		{name:'PICK',align:"center",width:"90",cellattr: addCellAttr,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue==1){
				   					return "<input type='checkbox' name='PICK' value='1' areaid='"+rowObject.AREA_ID+"'  id='P"+rowObject.AREA_ID+"' checked='false'>";
				   				}else{
				   					return "<input type='checkbox' name='PICK' value='1' areaid='"+rowObject.AREA_ID+"'  id='P"+rowObject.AREA_ID+"' >";
				   				}
				   			}
				   		},
				   		{name:'SELF_WL_FLG',align:"center",width:"90",cellattr: addCellAttr,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue==1){
				   					return "<input type='checkbox' onclick='jsClick(this)' name='SELF_WL_FLG' value='1' areaid='"+rowObject.AREA_ID+"' id='boxWL"+rowObject.AREA_ID+"' checked='false'>";
				   				}else{
				   					return "<input type='checkbox' onclick='jsClick(this)' name='SELF_WL_FLG' value='1' areaid='"+rowObject.AREA_ID+"' id='boxWL"+rowObject.AREA_ID+"' >";
				   				}
				   			}
				   		}
				   	],
				   	width:800,
				   	autowidth: false,  
				   	viewrecords: true,
                    grouping: true,
                    groupingView: {
                    	groupField: ["AREA_NAME2"],
                    	groupColumnShow: [true],
                    	groupText: ["<b>{0}</b>"],
                    	groupOrder: ["asc"],
                    	groupSummary: [false],
                    	groupCollapse: false
                	}
				});
				
				$("#grid-table").setGridParam().hideCol("AREA_ID").trigger("reloadGrid");
				//table数据高度计算
				tabHeight();
			});
			
			
			$(document).ready(function(){
			var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table3',{
					postData: postData,
					url:'${base}/guest/b2bChargeItemLists.jhtml',
					rowNum:2147483647,
 					width:838,
 					autowidth: false,  
		            shrinkToFit: true,
		            multiselect : false,
 					colNames:['','项目编码','项目名称','收款方类型','收款方','收费方式','收费比率/金额','勾选','定义收费比率/金额','说明'],
				   	colModel:[
				   		{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
				   		{name:'CODE',align:"center",width:70},
				   		{name:'NAME',align:"center",width:70},
				   		{name:'PAY_TO_TYPE',align:"center",width:70},
				   		{name:'PAY_TO_CUSTID',align:"center",width:70},
				   		{name:'CRM_TEL',align:"center",width:70},
				   		{name:'RATIO',align:"center",width:70},
				   		{name:'PICK',align:"center",width:70,
				   			formatter:function(cellvalue, options, rowObject){
				   				if($('#purchaserFlg').is(':checked')) {
				   					return "<input type='checkbox' name='PICK' value='1' uuid='"+rowObject.UUID+"' id='boxWL"+rowObject.UUID+"' checked='false' disabled='disabled'>";
				   				}else if(($('#logisticsProviderFlg').is(':checked') && rowObject.PAY_TO_TYPE=="C") || rowObject.PAY_TO_TYPE=="A"){
				   					return "<input type='checkbox' name='PICK' value='1' uuid='"+rowObject.UUID+"' id='boxWL"+rowObject.UUID+"' checked='false' disabled='disabled'>";
				   				}
				   			}
				   		},
				   		{name:'RATIO',align:"center",width:40,
				   			formatter:function(cellvalue, options, rowObject){
				   				return "<input type='test' id='U"+rowObject.UUID+"'/>"
				   			}
				   		},
				   		{name:'LOGISTICS_PROVIDER_FLG',align:"center",width:40}
				   	],
				   	width:838,
				});
				
				//table数据高度计算
				tabHeight();
			});
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table2',{
					url:'${base}/guest/wlAreaIdList.jhtml?wlAreaId=${areaIdWl}&pick=1&userNo=${userNo}',
					autowidth: false,  
					rowNum:2147483647,
					multiselect : false,
 					colNames:['','','','市/区','区县','用户','是否可配送'],
				   	colModel:[
				   		{name:'AREA_ID',index:'USER_NO',width:"20",key:true},
				   		{name:'CP_TYPE',width:0,hidden:true,key:true},
				   		{name:'AREA_ID2',width:0,hidden:true,key:true},
				   		{name:'AREA_NAME2',align:"center",width:"90",cellattr:addCellAttrs},
				   		{name:'AREA_NAME',align:"center",width:"90",cellattr:addCellAttrs},
				   		{name:'PICK',align:"center",width:"90",
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue==1){
				   					return "<input type='checkbox'    checked='false'>";
				   				}else{
				   					return "<input type='checkbox'    >";
				   				}
				   			}
				   		},
				   		{name:'PICK',align:"center",width:"90",
				   			formatter:function(cellvalue, options, rowObject){
				   				if(rowObject.CP_TYPE==1){
				   					return "<input type='checkbox' name='PICK' value='1' areaid='"+rowObject.AREA_ID+"'  id='P"+rowObject.AREA_ID+"' disabled='disabled'>";
				   				}else{
				   					if(cellvalue==1){
				   						return "<input type='checkbox' name='PICK' value='1' areaid='"+rowObject.AREA_ID+"'  id='P"+rowObject.AREA_ID+"' checked='false'>";
				   					}else{
				   						return "<input type='checkbox' name='PICK' value='1' areaid='"+rowObject.AREA_ID+"'  id='P"+rowObject.AREA_ID+"' >";
				   					}
				   				}
				   				
				   			}
				   		}
				   	],
				   	width:800,
				   	autowidth: false,  
				   	viewrecords: true,
                   	grouping: true,
                  	groupingView: {
						groupField: ["AREA_NAME2"],
                    	groupColumnShow: [true],
                    	groupText: ["<b>{0}</b>"],
                    	groupOrder: ["asc"],
                    	groupSummary: [false],
                    	groupCollapse: false
                	}
				});
				
				//table数据高度计算
				tabHeight();
				$("#grid-table2").setGridParam().hideCol("AREA_ID").trigger("reloadGrid");
				
				
				
				
				//判断div是否显示
				[#if guest.purchaserFlg=='Y'] $("#divxsqy").show();$("#divfygz").show(); [/#if]
				[#if guest.logisticsProviderFlg=='Y'] $("#divpsqy").show();$("#divfygz").show(); [/#if]
				
				
			});
			

			
			function addCellAttr(rowId, val, rawObject, cm, rdata) {
 				if (rawObject.CP_TYPE==1) {
                    return "";
                }
			}
			
			function addCellAttrs(rowId, val, rawObject, cm, rdata) {
 				if (rawObject.CP_TYPE==1) {
                    return "";
                }
			}
			
		
			
			
			
		</script>
    </head>
    
    <body>
    	 <input type="hidden" id="areaIdL1" value="${guest.areaIdL1}"/>
    	 <input type="hidden" id="userNo" value="${guest.userNo}"/>
    	<div class="userBox">
    		<div class="userBox-tit" id="divzclx">
    			<h3>注册类型：</h3>    			
    			<ul>
    				<li><input type="checkbox" name="zclx" id="salesmenFlg" [#if guest.salesmenFlg=='Y'] checked='false' [/#if] value="0"/>我是买家</li>
    				<li><input type="checkbox" name="zclx" id="purchaserFlg" [#if guest.purchaserFlg=='Y'] checked='false' [/#if] value="1"/>我是卖家</li>
    				<li><input type="checkbox" name="zclx" id="logisticsProviderFlg" [#if guest.logisticsProviderFlg=='Y'] checked='false' [/#if] value="2"/>我是物流商</li>
    			</ul>
    		</div>
    		
    		<div class="userBox-contList">
    			<h3>基本信息：</h3>
    			<ul>
    				<li><label>登录名:</label><span>${guest.userName}</span></li>
    				<li><label>企业名称:</label><span>${guest.name}</span></li>
    				<li><label>联系人:</label><span>${guest.pic}</span></li>
    				<li><label>联系电话:</label><span>${guest.crmTel}</span></li>
    				<li><label>联系地址:</label><span>${guest.address}</span></li>
    				<li><label>注册区域:</label><span>${guest.areaDesc}</span></li>
    			</ul>
    		</div>
    		<div class="userBox-contList body-container" >
    			<h3>图片展示：</h3>
    			<div style="padding:10px 0">
    				<div id="container">
						<div id="example">
							<div id="slides">
								<div class="slides_container">
									[#if guest.businessLicenseUrl?exists]
										<div class="slide">
											<img src="${guest.businessLicenseUrl}" >
										</div>
									[/#if]
									[#if guest.img0Url?exists]	
										<div class="slide">
											<img src="${guest.img0Url}" >
										</div>
									[/#if]	
									[#if guest.img1Url?exists]	
										<div class="slide">
											<img src="${guest.img1Url}" >
										</div>
									[/#if]	
									[#if guest.img2Url?exists]	
										<div class="slide">
											<img src="${guest.img2Url}" >
										</div>
									[/#if]	
									[#if guest.img3Url?exists]	
										<div class="slide">
											<img src="${guest.img3Url}" >
										</div>
									[/#if]	
									[#if guest.img4Url?exists]	
										<div class="slide">
											<img src="${guest.img4Url}">
										</div>
									[/#if]		
								</div>
								<a href="#" class="prev"><img src="${base}/styles/css/base/css/images/arrow-prev.png" width="24" height="43" alt="Arrow Prev"></a>
								<a href="#" class="next"><img src="${base}/styles/css/base/css/images/arrow-next.png" width="24" height="43" alt="Arrow Next"></a>
							</div>
							<img src="${base}/styles/css/base/css/images/example-frame.png" width="739" height="341" alt="Example Frame" id="frame">
						</div>
					</div>
    			</div>
    		</div>
    		<div class="userBox-contList" id="divxsqy" style="display: none">
    			<h3>销售区域</h3>
    			<div class="user-contsj">
    				<div class="user-contsj-l">
    					<div class="user-contsj-lcon" id="div1">
    					[#if listMap?exists]
    						[#list listMap as listMaps]
    							[#if listMaps.PICK==1]
    							${listMaps.AREA_NAME}<br />
    							[/#if]
    						[/#list]
    					[/#if]
    					</div>
    				</div>
    				<div class="user-contsj-r">
    				<table id="grid-table" ></table>
    				</div>
    			</div>
    		</div>
    		
    		<div class="userBox-contList" id="divpsqy" style="display: none">
    			<h3>配送区域</h3>
    			<div class="user-contsj">
    				<div class="user-contsj-l">
    					<div class="user-contsj-lcon" id="div2">
    					[#if listMapWl?exists]
    						[#list listMapWl as listMaps]
    							[#if listMaps.PICK==1]
    								${listMaps.AREA_NAME}<br />
    							[/#if]
    						[/#list]
    					[/#if]
    					</div>
    				</div>
    				<div class="user-contsj-r">
    				<table id="grid-table2" ></table>
    				</div>
    			</div>
    		</div>
    		
    		<div class="userBox-contList body-container" id="divfygz" style="display: none">
    			<h3>费用规则：</h3>
    			<div style="padding:10px 0"><table id="grid-table3" ></table></div>
    		</div>
    		
    		<div class="userBtn-box">
    			<span id="spanRefuse" style="float:left;display: none">拒绝原因 ：<input style="width:300px;" type="text" id="sefuse" value="" /></span>
				
				<button class="search_cBox_btn" data-toggle="jBox-close">
					关闭 
				</button>
			</div>
    	</div>  
    </body>
    
</html>