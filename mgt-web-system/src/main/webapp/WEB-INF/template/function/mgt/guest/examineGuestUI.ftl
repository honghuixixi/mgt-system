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
					url:'${base}/guest/areaIdList.jhtml?areaId=${areaId}&userNo=${userNo}',
					autowidth: false,  
					rowNum:2147483647,
					multiselect : false,
 					colNames:['','','','市/区','区县','是否可销售','是否可配送','合作模式'],
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
				   		},
				   		{name:'VENDOR_CODE',align:"center",width:"90",cellattr: addCellAttr,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(rowObject.CP_TYPE=="0"){
				   					return "<select id='sel"+rowObject.AREA_ID+"'><option value='SOP'>SOP</option><option value='SOP'>SOP-L</option></select>";
				   				}else{
				   					return "<select id='sel"+rowObject.AREA_ID+"'><option value='SOP'>SOP</option><option value='LBP'>LBP</option><option value='FBP'>FBP</option><option value='SOP-L'>SOP-L</option></select>";
				   					
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
 					colNames:['','','项目编码','项目名称','收款方类型','收款方','收费方式','收费比率/金额','勾选','定义收费比率/金额','说明'],
				   	colModel:[
				   		{name:'UUID',index:'UUID',width:0,hidden:true,key:true},
				   		{name:'ITEM_TYPE',width:0,hidden:true,key:true},
				   		{name:'CODE',align:"center",width:50},
				   		{name:'NAME',align:"center",width:60},
				   		{name:'PAY_TO_TYPE',align:"center",width:50,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue=="A") {
				   					return "平台"
				   				}else if(cellvalue=="B"){
				   					return "供应商"
				   				}if(cellvalue=="C"){
				   					return "物流商"
				   				}else{
				   					return ""
				   				}
				   			}
				   		},
				   		{name:'PAY_TO_CUSTID',align:"center",width:70},
				   		{name:'RATIO_TYPE',align:"center",width:50,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue=="R") {
				   					return "按比率"
				   				}else if(cellvalue=="A"){
				   					return "按金额"
				   				}else{
				   					return ""
				   				}
				   			}
				   		},
				   		{name:'RATIO',align:"center",width:50},
				   		{name:'PICK',align:"center",width:40,
				   			formatter:function(cellvalue, options, rowObject){
				   				if($('#purchaserFlg').is(':checked')) {
				   					return "<input type='checkbox' name='PICK' value='1' uuid='"+rowObject.UUID+"' id='boxWL"+rowObject.UUID+"' checked='false' disabled='disabled'>";
				   				}else if(($('#logisticsProviderFlg').is(':checked') && rowObject.PAY_TO_TYPE=="C") || rowObject.PAY_TO_TYPE=="A"){
				   					return "<input type='checkbox' name='PICK' value='1' uuid='"+rowObject.UUID+"' id='boxWL"+rowObject.UUID+"' checked='false' disabled='disabled'>";
				   				}
				   			}
				   		},
				   		{name:'RATIO',align:"center",width:50,
				   			formatter:function(cellvalue, options, rowObject){
				   				if(rowObject.ITEM_TYPE=="B" || rowObject.ITEM_TYPE=="Z"){
				   					return "<input type='test' id='U"+rowObject.UUID+"' disabled='disabled' value='"+rowObject.RATIO+"'/>"
				   				}else{
				   					return "<input type='test' id='U"+rowObject.UUID+"'/>"
				   				}
				   				
				   			}
				   		},
				   		{name:'NOTE',align:"center",width:90}
				   	],
				   	width:838,
				});
				
				//table数据高度计算
				tabHeight();
			});
			$(document).ready(function(){
				var postData={orderby:"CREATE_DATE"};
				mgt_util.jqGrid('#grid-table2',{
					url:'${base}/guest/wlAreaIdList.jhtml?wlAreaId=${areaIdWl}&userNo=${userNo}',
					autowidth: false,  
					rowNum:2147483647,
					multiselect : false,
 					colNames:['','','','市/区','区县','申请区域','是否可配送'],
				   	colModel:[
				   		{name:'AREA_ID',index:'USER_NO',width:"20",key:true},
				   		{name:'CP_TYPE',width:0,hidden:true,key:true},
				   		{name:'AREA_ID2',width:0,hidden:true,key:true},
				   		{name:'AREA_NAME2',align:"center",width:"90",cellattr:addCellAttrs},
				   		{name:'AREA_NAME',align:"center",width:"90",cellattr:addCellAttrs},
				   		{name:'PICK',align:"center",width:"90",
				   			formatter:function(cellvalue, options, rowObject){
				   				if(cellvalue==1){
				   					return "<input type='checkbox' disabled='disabled'   checked='false'>";
				   				}else{
				   					return "<input type='checkbox' disabled='disabled'   >";
				   				}
				   			}
				   		},
				   		{name:'PICK',align:"center",width:"90",
				   			formatter:function(cellvalue, options, rowObject){
				   				if(rowObject.CP_TYPE!="0"){
				   					return "<input type='checkbox' name='PICK' value='1' areaid='"+rowObject.AREA_ID+"'  id='P"+rowObject.AREA_ID+"' disabled='disabled'>";
				   				}else{
				   					if(rowObject.CP_TYPE!="0"){
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
				
				//循环给销售区域左侧数据添加点击事件
				$("#div1 :checkbox").click(function(){
					var str ="";
					//循环获取选中数据
					$('#div1 input[name="box"]:checked').each(function(){ 
						str+=$(this).val()+",";
					});
					//去除最后位逗号
				    str=str.substring(0,str.length-1)
				    //刷新grid表单数据
					$("#grid-table").jqGrid('setGridParam', {
							start : 1,
							datatype:'json',
							type:'post',
							mtype:'post',
							page:1 ,
							url : '${base}/guest/areaIdList.jhtml?areaId='+str+'&userNo='+$("#userNo").val()
					}).trigger("reloadGrid");
				});
				
				//循环给配送区域左侧数据添加点击事件
				$("#div2 :checkbox").click(function(){
					var str ="";
					//循环获取选中数据
					$('#div2 input[name="box"]:checked').each(function(){ 
						str+=$(this).val()+",";
					});
					//去除最后位逗号
				    str=str.substring(0,str.length-1)
				    //刷新grid表单数据
					$("#grid-table2").jqGrid('setGridParam', {
							start : 1,
							datatype:'json',
							type:'post',
							mtype:'post',
							page:1 ,
							url : '${base}/guest/wlAreaIdList.jhtml?wlAreaId='+str+'&userNo='+$("#userNo").val()
					}).trigger("reloadGrid");
				});
				
				//是否显示div
				$("#divzclx :checkbox").click(function(){
					if($(this).is(':checked')) {
     					if($(this).val()==2){
     						$("#divxsqy").show();
     						$("#divfygz").show();
     						$("#divfpqx").show();
     						$("#divzqsz").show();
     						
     						
							$("#agree").show();
							$("#refuse").show();
     						
     					}else if($(this).val()==3){
     						$("#divpsqy").show();
     						$("#divfygz").show();
     						$("#divfpqx").show();
     						$("#divzqsz").show();
     						$("#agree").show();
							$("#refuse").show();
     					}else if($(this).val()==1 && ($("#purchaserFlg").is(':checked') || $("#logisticsProviderFlg").is(':checked')) ){
     						$("#divfygz").show();
     						$("#divfpqx").show();
     						$("#divzqsz").show();
     						if($(this).val()==1){
     							if($("#type").val()=="N"){
     								$("#spanRefuse").hide();
									$("#agree").hide();
									$("#cancel").hide();
									$("#confirmRefuse").hide();
									$("#refuse").hide();
									$("#span1").show();
     							}
     						}else{
     							$("#agree").show();
								$("#refuse").show();
     						}
     					}else if($(this).val()==1){
     						if($("#type").val()=="N"){
     							$("#spanRefuse").hide();
								$("#agree").hide();
								$("#cancel").hide();
								$("#confirmRefuse").hide();
								$("#refuse").hide();
								$("#span1").show();
     						}else{
     							$("#agree").show();
								$("#refuse").show();
     						}
     					}
     					
     					$("#grid-table3").jqGrid().trigger("reloadGrid");
     					
 					}else{
 						if($(":checkbox[name=zclx]:checked").size() == 0) {
							$("#spanRefuse").hide();
							$("#agree").hide();
							$("#cancel").hide();
							$("#confirmRefuse").hide();
							$("#refuse").hide();
						}
 						if($("#purchaserFlg").is(':checked') || $("#logisticsProviderFlg").is(':checked')){
     						$("#divfygz").show();
     						$("#divfpqx").show();
     						$("#divzqsz").show();
     					}else{
     						$("#divfygz").hide();
     						$("#divfpqx").hide();
     						$("#divzqsz").hide();
     					}
 						if($(this).val()==2){
     						$("#divxsqy").hide();
     					}else if($(this).val()==3){
     						$("#divpsqy").hide();
     						//$("#divfpqx").hide();
     						//$("#divzqsz").hide();
     					}else if($(this).val()==1){
     						if($("#type").val()=="N"){
     							if($(":checkbox[name=zclx]:checked").size() == 0) {
									$("#spanRefuse").hide();
									$("#agree").hide();
									$("#cancel").hide();
									$("#confirmRefuse").hide();
									$("#refuse").hide();
								}else{
									$("#agree").show();
									$("#refuse").show();
									$("#span1").hide();
								}
     							
     						}
     					}
     					$("#grid-table3").jqGrid().trigger("reloadGrid");
     					
 					}
				});
				//判断div是否显示
				$("#divfpqx").hide();
					if($("#type").val()=="N"){
	     				$("#spanRefuse").hide();
						$("#agree").hide();
						$("#cancel").hide();
						$("#confirmRefuse").hide();
						$("#refuse").hide();
						$("#span1").show();
     				}
				
				[#if guest.purchaserFlg=='Y'] $("#divxsqy").show();$("#divfygz").show();$("#divfpqx").show();$("#divzqsz").show(); [/#if]
				[#if guest.logisticsProviderFlg=='Y'] $("#divpsqy").show();$("#divfygz").show();$("#divfpqx").show();$("#divzqsz").show(); [/#if]
				
				
			});
			
			//function jsClick(obj){
				//if($("#"+obj.id+"").is(':checked')){
					//var id =obj.id;
					//id=id.replace("boxWL","P")
					//$("#"+id+"").attr("checked", true)
				//}
				
			//}
			
			function saveRows(){
				var alljson="{";
				if(!$("#divxsqy").is(":hidden")){
					//拼装销售区域数据
					var xsqy="'xsqy':[";
					var p1=""
					$('#grid-table input[name="PICK"]:checked').each(function(){ 
						var id =$(this).attr('areaid');
						var rowData = $('#grid-table').jqGrid('getRowData',id);
						var boxWL="";
						if($('#boxWL'+id).is(':checked')) {
     						boxWL=1
						}else{
							boxWL=0
						}
						var data ="{PICK:"+$(this).val()+",SELF_WL_FLG:"+boxWL+",VENDOR_CODE:'"+$('#sel'+id+' option:selected').val()+"',AREA_ID_L2="+rowData.AREA_ID2+",AREA_ID="+rowData.AREA_ID+",AREA_ID_L1="+$('#areaIdL1').val()+",WH_C='"+rowData.CP_TYPE+"'},"
						p1+=data
					});
					//判断p1是否为空
					if(p1==""){
						xsqy="";
					}else{
						p1=p1.substring(0,p1.length-1)
						p1+="]";
						xsqy+=p1
					}
					//判断xsqy是否为空
					if(xsqy!=""){
						alljson+=xsqy;
					}else{
						alljson+="'xsqy':''"
					}
				}else{
					alljson+="'xsqy':''"
				}
				
				
				if(!$("#divpsqy").is(":hidden")){
					//拼装物流区域
					var wlqy=",'wlqy':[";
					var p2=""
					$('#grid-table2 input[name="PICK"]:checked').each(function(){ 
						var id =$(this).attr('areaid');
						var rowData = $('#grid-table2').jqGrid('getRowData',id);
						var data ="{PICK:"+$(this).val()+",AREA_ID_L2="+rowData.AREA_ID2+",AREA_ID="+rowData.AREA_ID+",AREA_ID_L1="+$('#areaIdL1').val()+"},"
						p2+=data
					})
					//判断p2是否为空
					if(p2==""){
						wlqy="";
					}else{
						p2=p2.substring(0,p2.length-1)
						p2+="]";
						wlqy+=p2
					}
					//判断是否是只有物流商
					if($("#salesmenFlg").is(':checked') || $("#purchaserFlg").is(':checked')){
						//判断wlqy是否为空
						if(wlqy!=""){
							alljson+=wlqy;
						}else{
							alljson+=",'wlqy':''"
						}
					}else{
						if(wlqy!=""){
							alljson+=wlqy;
						}else{
							top.$.jBox.tip('未选中配送区域,请确认数据!');
							return false;
						}
					}
				}else{
					alljson+=",'wlqy':''"
				}
				
				
				
				//拼装费用规则
				var fygz="";
				if(!$("#divfygz").is(":hidden")){
					var fygz=",'fygz':[";
					var p3="";
					var bl=true
					$('#grid-table3 input[name="PICK"]:checked').each(function(){
						var id =$(this).attr('uuid');
						var rowData = $('#grid-table3').jqGrid('getRowData',id);
						var rat= $("#U"+id).val()
						if(rat!=null && rat!=""){
							if (!(/^(([1-9]\d*)|\d)(\.\d{1,7})?$/).test(rat)) {
								top.$.jBox.tip('收费比例必须是数字');
								bl=false;
								return false;
							} else {
								var data ="{uuid:"+id+",RATIO='"+rat+"',ITEM_TYPE='"+rowData.ITEM_TYPE+"'},"
							}
						}else{
							var data ="{uuid:"+id+",RATIO_NULL='',ITEM_TYPE='"+rowData.ITEM_TYPE+"'},"
						}
						p3+=data
					});
					if(!bl){
						return false;
					}
					//判断p2是否为空
					if(p3==""){
						fygz="";
					}else{
						p3=p3.substring(0,p3.length-1)
						p3+="]";
						fygz+=p3
					}
					//判断fygz是否为空
					if(fygz!=""){
						alljson+=fygz;
					}
				}
				//拼装用户权限
				var fpqx=""
				if(!$("#divfygz").is(":hidden")){
					var len=$("#divfpqx input[name='roleIds']:checked").length;
					var p4="";
					$("#divfpqx input[name='roleIds']:checked").each(function(i){
					
						if(i==(len-1)){
							p4+=""+$(this).val();
						}else{
							p4+=""+$(this).val()+",";
						}
					})
					if(len==0){
						alert("请选择用户权限!")
						return false;
					}else{
						
						fpqx+=",fpqx:'"+p4+"'"
						alljson+=fpqx;
					}
				}else{
					alljson+=",'fpqx':''"
				}
				//拼装账期设置
				if(!$("#divzqsz").is(":hidden")){
					var regu = "^[0-9]+$";
					var re = new RegExp(regu);
					
					if ($("#inv_terms").val().search(re) != -1) {
					
					} else {
						top.$.jBox.tip('对帐帐期请输入数字');
						return false;
					}
					
					if ($("#disc_terms").val().search(re) != -1) {
					
					} else {
						top.$.jBox.tip('结算帐期请输入数字');
						return false;
					}
					var p5=",'INV_TERMS':'"+$("#inv_terms").val()+"','DISC_TERMS':'"+$("#disc_terms").val()+"'";
					alljson+=p5;
				}
				
				//拼装注册类型
				var zclx=""
				
				$("#divzclx input[name='zclx']:checked").each(function(){
					if($(this).val()==1){
						zclx+="'SALESMEN_FLG':1,"
					}else if($(this).val()==2){
						zclx+="'PURCHASER_FLG':1,"
					}else if($(this).val()==3){
						zclx+="'LOGISTICS_PROVIDER_FLG':1,"
					}
				})
				if(zclx!=""){
					zclx=zclx.substring(0,zclx.length-1)
					zclx=","+zclx;
					alljson+=zclx;
				}
				alljson+=",id:"+$("#userNo").val();
				alljson+="}"
				$.ajax({
            		url:'${base}/guest/saveRows.jhtml',
            		type : 'post',
					dataType : 'json',
					data:{data:alljson},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) { 
						if(!data.success){
							top.$.jBox.tip(data.msg, data.success);
							return false;
						}
						top.$.jBox.tip('操作成功！', 'success');
	   					top.$.jBox.refresh = true;
	   					top.$.jBox.close();
					}
            	});
			}
			function addCellAttr(rowId, val, rawObject, cm, rdata) {
 				if (rawObject.CP_TYPE!=0) {
                    return "style='color:red'";
                }
			}
			
			function addCellAttrs(rowId, val, rawObject, cm, rdata) {
 				if (rawObject.CP_TYPE!=0) {
                    return "style='color:red'";
                }
			}
			
			function onRefuse(){
				$("#spanRefuse").show();
				$("#agree").hide();
				$("#cancel").show();
				$("#confirmRefuse").show();
				$("#refuse").hide();
				
			}
			function onCancel(){
				$("#spanRefuse").hide();
				$("#agree").show();
				$("#cancel").hide();
				$("#confirmRefuse").hide();
				$("#refuse").show();
			}
			
			function onConfirmRefuse(){
				if($("#sefuse").val()==null || $("#sefuse").val()==""){
					top.$.jBox.tip('请填写拒绝原因!');
					return false;
				}
				$.ajax({
            		url:'${base}/guest/saveRefuse.jhtml',
            		type : 'post',
					dataType : 'json',
					data:{data:$('#sefuse').val(),id:$('#userNo').val()},
					error : function(data) {
						alert("网络异常");
						return false;
					},
					success : function(data) { 
						top.$.jBox.tip('操作成功！', 'success');
	   					top.$.jBox.refresh = true;
						top.$.jBox.close();
					}
            	});
			}
			
			function clickbox1(){
				if($("#xsbox").is(':checked')){
					$("#grid-table").jqGrid('setGridParam', {
						start : 1,
						datatype:'json',
						type:'post',
						mtype:'post',
						page:1 ,
						url :'${base}/guest/areaIdList.jhtml?areaId=${areaId}&pick=1&userNo='+$("#userNo").val()
					}).trigger("reloadGrid");
					[#if listMap?exists]
    					[#list listMap as listMaps]
    						[#if listMaps.PICK==1] 
    							$("#X"+${listMaps.AREA_ID}).attr("checked", true)
    						[#else]
    							$("#X"+${listMaps.AREA_ID}).attr("checked", false)
    							$("#Xspan"+${listMaps.AREA_ID}).hide();
    						[/#if]
						[/#list]
    				[/#if]
				}else{
					$("#grid-table").jqGrid('setGridParam', {
						start : 1,
						datatype:'json',
						type:'post',
						mtype:'post',
						page:1 ,
						url :'${base}/guest/areaIdList.jhtml?areaId=${areaId}&userNo='+$("#userNo").val()
					}).trigger("reloadGrid");
					[#if listMap?exists]
    					[#list listMap as listMaps]
    						[#if listMaps.PICK==1] 
    							$("#X"+${listMaps.AREA_ID}).attr("checked", true)
    						[#else]
    							$("#Xspan"+${listMaps.AREA_ID}).show();
    						[/#if]
						[/#list]
    				[/#if]
				}
			}
			
			function clickbox2(){
				if($("#psbox").is(':checked')){
					$("#grid-table2").jqGrid('setGridParam', {
						start : 1,
						datatype:'json',
						type:'post',
						mtype:'post',
						page:1 ,
						url : '${base}/guest/wlAreaIdList.jhtml?wlAreaId=${areaIdWl}&pick=1&userNo='+$("#userNo").val()
					}).trigger("reloadGrid");
					[#if listMapWl?exists]
    					[#list listMapWl as listMaps]
    						[#if listMaps.PICK==1] 
    							$("#P"+${listMaps.AREA_ID}).attr("checked", true)
    						[#else]
    							$("#P"+${listMaps.AREA_ID}).attr("checked", false)
    							$("#Pspan"+${listMaps.AREA_ID}).hide();
    						[/#if]
						[/#list]
    				[/#if]
				}else{
					$("#grid-table2").jqGrid('setGridParam', {
						start : 1,
						datatype:'json',
						type:'post',
						mtype:'post',
						page:1 ,
						url : '${base}/guest/wlAreaIdList.jhtml?wlAreaId=${areaIdWl}&userNo='+$("#userNo").val()
					}).trigger("reloadGrid");
					[#if listMapWl?exists]
    					[#list listMapWl as listMaps]
    						[#if listMaps.PICK==1] 
    							$("#P"+${listMaps.AREA_ID}).attr("checked", true)
    						[#else]
    							$("#Pspan"+${listMaps.AREA_ID}).show();
    						[/#if]
						[/#list]
    				[/#if]
				}
			}
			
			
			
		</script>
    </head>
    
    <body>
    	 <input type="hidden" id="areaIdL1" value="${guest.areaIdL1}"/>
    	 <input type="hidden" id="userNo" value="${guest.userNo}"/>
    	 <input type="hidden" id="type" value="${type}"/>
    	<div class="userBox">
    		<div class="userBox-tit" id="divzclx">
    			<h3>注册类型：</h3>    			
    			<ul>
    				<li><input type="checkbox" name="zclx" id="salesmenFlg" [#if guest.salesmenFlg=='Y'] checked='false' [/#if] value="1"/>我是买家</li>
    				<li><input type="checkbox" name="zclx" id="purchaserFlg" [#if guest.purchaserFlg=='Y'] checked='false' [/#if] value="2"/>我是卖家</li>
    				<li><input type="checkbox" name="zclx" id="logisticsProviderFlg" [#if guest.logisticsProviderFlg=='Y'] checked='false' [/#if] value="3"/>我是物流商</li>				
    			</ul>
    			<div style="width:100%;overflow:hidden;line-height:24px;color:#f00;"><span id="span1" style="float:left;display: none">此用户不能成为买家,请去掉申请买家身份</span></div>
    			
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
											<img width="570" height="270" src="${guest.businessLicenseUrl}" >
										</div>
									[/#if]
									[#if guest.img0Url?exists]	
										<div class="slide">
											<img width="570" height="270" src="${guest.img0Url}" >
										</div>
									[/#if]	
									[#if guest.img1Url?exists]	
										<div class="slide">
											<img width="570" height="270" src="${guest.img1Url}" >
										</div>
									[/#if]	
									[#if guest.img2Url?exists]	
										<div class="slide">
											<img width="570" height="270" src="${guest.img2Url}" >
										</div>
									[/#if]	
									[#if guest.img3Url?exists]	
										<div class="slide">
											<img width="570" height="270" src="${guest.img3Url}" >
										</div>
									[/#if]	
									[#if guest.img4Url?exists]	
										<div class="slide">
											<img width="570" height="270" src="${guest.img4Url}">
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
    			<h3>销售区域<span><input type="checkbox" id="xsbox" onclick="clickbox1()"/>仅显示用户申请区域</span></h3>
    			<div class="user-contsj">
    				<div class="user-contsj-l">
    					<div class="user-contsj-lcon" id="div1">
    					[#if listMap?exists]
    						[#list listMap as listMaps]
    							<span id="Xspan${listMaps.AREA_ID}"><input type="checkbox" name="box" id="X${listMaps.AREA_ID}" value="${listMaps.AREA_ID}"  [#if listMaps.PICK==1] checked="false" [/#if]/>${listMaps.AREA_NAME}<br /></span>
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
    			<h3>配送区域<span><input type="checkbox" id="psbox" onclick="clickbox2()"/>仅显示用户申请区域</span></h3>
    			<div class="user-contsj">
    				<div class="user-contsj-l">
    					<div class="user-contsj-lcon" id="div2">
    					[#if listMapWl?exists]
    						[#list listMapWl as listMaps]
    							<span id="Pspan${listMaps.AREA_ID}"><input type="checkbox" name="box" id="P${listMaps.AREA_ID}" value="${listMaps.AREA_ID}"  [#if listMaps.PICK==1] checked="false" [/#if]/>${listMaps.AREA_NAME}<br /></span>
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
    		<div class="userBox-contList body-container" id="divfpqx">
    			<h3>分配权限：</h3>
    			<div style="padding:10px 0">
    				<table >
						<tr height="50">
                              [#if mgtRole?exists]
	                              [#list mgtRole as roleList]
                                      <td>
                                           <input type="checkbox" value="${roleList.ID}" name="roleIds" title=" ${roleList.NAME}" >${roleList.NAME}&nbsp;&nbsp;&nbsp;
                                      </td>
							          [#if (roleList_index+1)%4==0 && roleList.size()>4]
								          </tr><tr  height="50">
							          [/#if]
	                            [/#list] 
							[/#if]
						</tr>
					</table>
    			</div>
    		</div>
    		
    		<div class="userBox-contList body-container" id="divzqsz" style="display: none">
    			<h3>账期设置：</h3>
    			<div style="padding:10px 0">
    				<table >
						<tr height="50">
                                      <td>对账账期 :<input type="text" value="" name="inv_terms" id="inv_terms" >
                                      </td>
                                      <td>账期结算:<input type="text" value="" name="disc_terms" id="disc_terms" >
                                      </td>
						</tr>
					</table>
    			</div>
    		</div>
    		
    		<div class="userBtn-box">
    			<span id="spanRefuse" style="float:left;display: none">拒绝原因 ：<input style="width:300px;" type="text" id="sefuse" value="" /></span>
				<button type="button" class="search_cBox_btn" data-toggle="jBox-query" id="agree" onclick="saveRows()">同意</button>
				<button type="button" class="search_cBox_btn" data-toggle="jBox-query" id="refuse" onclick="onRefuse()">拒绝 </button>
				<button type="button" class="search_cBox_btn" data-toggle="jBox-query" style="display: none" id="confirmRefuse" onclick="onConfirmRefuse()">确定拒绝 </button>
				<button type="button" class="search_cBox_btn" data-toggle="jBox-query" style="display: none" id="cancel"  onclick="onCancel()">取消 </button>
				<button class="search_cBox_btn" data-toggle="jBox-close">
					关闭 
				</button>
			</div>
    	</div>  
    </body>
    
</html>