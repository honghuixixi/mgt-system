<!DOCTYPE html>
<html lang="zh-cn">
    <head>
    	<meta charset="utf-8" />
        <title>系统管理-平台首页维护</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <script type="text/javascript" src="${base}/scripts/lib/jquery/jquery.lSelect.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				var postData={areaId:$('#areaId').val(),prodType:$('#prodType').val()};
				mgt_util.jqGrid('#grid-table',{
					postData: postData,
					url:'${base}/index/indexContentList.jhtml',
 					colNames:['ID','显示','类型','名称','顺序','修改时间','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:30,hidden:true,key:true},
				   		{name:'SHOW_FLG',width:30,align:"center",editable:true,formatter:function(data){
							if(data=='Y'){
								return '是';
							}else{
								return '否';
	   					}}},
						{name:'TYPE',align:"center",width:30},
						{name:'BOX_NAME',align:"center",width:150},
				   		{name:'SORT_NO',align:"center",width:30},
				   		{name:'MODIFY_DATE', align:"center",width:100,formatter:function(data){
							if(data==null){return '';}
							var date=new Date(data);
							return date.format('yyyy-MM-dd hh:mm:ss');
						}},
				   		{name:'detail',width:100,align:'center',sortable:false} ,
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i]; 
							var rowData = $('#grid-table').jqGrid('getRowData',id);
							if(rowData.TYPE=='A'||rowData.TYPE=='B'||rowData.TYPE=='D'||rowData.TYPE=='E'){
								detail="<button type='input' class='btn btn-info'  id='"+id+"' data-toggle='jBox-show' onClick=editTypeUI('"+id+"','"+rowData.TYPE+"') >编辑</button>";
							}else{
								detail="<button type='input' class='btn btn-info'  id='"+id+"' onClick=editTypeUI('"+id+"','"+rowData.TYPE+"') >编辑</button>";
							}
							if(rowData.SHOW_FLG=='是'){
								detail+="<button type='button' class='btn btn-info changeFlg'  id='"+id+"' flg='N'>隐藏 </button>"
							}else{
								detail+="<button type='button' class='btn btn-info changeFlg'  id='"+id+"' flg='Y'>显示</button>"
							}
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					}				   	
				});
				
			// 改变数据隐藏显示状态
			$(".changeFlg").live("click",function(){
				var id = $(this).attr("id");
				var showFlg = $(this).attr("flg");
				var str = "";
				if(showFlg=='N'){
					str="确认‘隐藏’该条数据吗?";
				}else if(showFlg=='Y'){
					str="确认‘显示’该条数据吗?";
				}
				$.jBox.confirm(str,"提示",function(v){
					if(v=='ok'){
						$.ajax({
							url:'${base}/index/isShowFlg.jhtml',
							sync:false,
							type:'post',
							dataType:'json',
							data:{
								'id':id,
								'showFlg':showFlg
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
								if(data.code==100){
									top.$.jBox.tip('操作成功！', 'success');
									top.$.jBox.refresh = true;
									$('#grid-table').trigger("reloadGrid");
								}else{
									top.$.jBox.tip('操作失败！', 'error');
									return false;
								}
							}
						});
					}
				});
			});
		});
		
	// 编辑首页数据
	function editTypeUI(id,type){
		var AREAID= $('#areaId').val();
		var PRODTYPE= $('#prodType').val();
		if('A'==type||'B'==type||'D'==type||'E'==type){
        	mgt_util.showjBox({
        		width : 1000,
        		height : 500,
        		title : '编辑',
       	    	url : '${base}/index/editDetails.jhtml?id='+id+'&type='+type+'&areaId='+AREAID+'&prodType='+PRODTYPE,
            	grid : $('#grid-table')
        	});
		}else{
			top.$.jBox.tip('此类型数据已暂停使用！！', 'error');
			return false;
		}
     }
     
	//预览按钮
	function preview(areaId,prodType){
		if(''!=areaId && areaId=='-1'){
			areaId=1;
		}
		if('B2BWEB'==prodType){
		  //window.open('http://localhost:8081/qpwa-platform/'+'indexCurrent.jhtml?areaId='+areaId+'');
		  window.open($("#macroUrl0").val()+'indexCurrent.jhtml?areaId='+areaId+'');
		}else{
		  //window.open('http://localhost:8081/qpwa-wap/'+'indexCurrent.jhtml?areaId='+areaId+'');
		  window.open($("#macroUrl0").val()+'indexCurrent.jhtml?areaId='+areaId+'');
		}		
     }
     
	//保存按钮
	function publish(AeraId,prodType){
		//网址url0
		var clreaUrl0='';
		//网址url1
		var clreaUrl1='';
		
		if(''!=AeraId && AeraId=='-1'){
			AeraId=1;
		}
		if('B2BWEB'==prodType){
		  //clreaUrl = 'http://localhost:8081/qpwa-platform/indexCurrent/publish.jhtml';
		  clreaUrl0 = $("#macroUrl0").val()+'indexCurrent/publish.jhtml';
		  clreaUrl1 = $("#macroUrl1").val()+'indexCurrent/publish.jhtml';
		}else{
		  //clreaUrl = 'http://localhost:8081/qpwa-wap/indexCurrent/publish.jhtml';
		  clreaUrl0 = $("#macroUrl0").val()+'indexCurrent/publish.jhtml'; 
		  clreaUrl1 = $("#macroUrl1").val()+'indexCurrent/publish.jhtml'; 
		}
		//根据所选择的网站，清除缓存数据
		$.jBox.confirm("确认保存并立即生效吗?","提示",function(v){
			
			if(v=='ok'){
				$.ajax({
					url:clreaUrl0,
					sync:false,
					type:'post',
					dataType:'jsonp',
					data:{
						'AeraId':AeraId,
					},
					error:function(data){
						alert("网络异常")
						return false;
					},
					success:function(data){
						$.ajax({
							url:clreaUrl1,
							sync:false,
							type:'post',
							dataType:'jsonp',
							data:{
								'AeraId':AeraId,
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
								top.$.jBox.tip('操作成功！', 'success');
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
			<div id="currentDataDiv" action="menu">
    			<div class="currentDataDiv_tit">
        			<div class="form-group">
    		        	<button type="button" class="btn_divBtn edit" id="info_edit" onclick="publish($('#areaId').val(),$('#prodType').val())">保存</button>
    		        	<button type="button" class="btn_divBtn del"  id="info_del"  onclick="preview($('#areaId').val(),$('#prodType').val())">预览 </button>
    		        </div> 
    			</div>
    			<div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
	        			<div class="form-group">
		                    <label class="control-label">区域：</label>
							[#if areaRoot != -1]
		                    	<select class="form-control" disabled="true" name="areaId" id="areaId">
									[#list areaOptions as areaOptions]
										[#if areaOptions.areaId == areaRoot]
											<option value='${areaOptions.areaId}' selected>${areaOptions.areaName}</option>
										[/#if]
									[/#list]
		                   	 	</select>
		                   	[#else]	
		                    	<select class="form-control" name="areaId" id="areaId">
									[#list areaOptions as areaOptions]
										<option value='${areaOptions.areaId}'>${areaOptions.areaName}</option>
									[/#list]
		                    	</select>		                   	
							[/#if]
	        			</div>
		                <div class="form-group">
		                    <label class="control-label">网站：</label>
		                    <select class="form-control" id="prodType" name="prodType">
		                        <option value="B2BWEB" selected>B2BWEB</option>
		                        <option value='B2BWAP'>B2BWAP</option>
		                        <option value='B2BAPP'>B2BAPP</option>
		                        <option value='B2CWAP'>B2CWAP</option>
		                        <option value='B2CAPP'>B2CAPP</option>
		                    </select>
		                </div>
		            </form>
            	</div>
	             <div class="search_cBox">
	                <div class="form-group">
	                 	<button type="button" class="search_cBox_btn" id="info_search" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	             </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
		  <div style="display:none">
			[#import "/function/mgt/platformIndex/URLMacro.ftl" as urlBox]
			[@urlBox.urlPrefix url= 'B2BWEB' /]
		  </div>
   		</div>
    </body>
</html>