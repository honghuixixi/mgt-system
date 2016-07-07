<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8" />
<title>日志管理-日志信息</title> [#include "/common/commonHead.ftl" /]
<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
<script type="text/javascript" language="javascript"
	src="${base}/scripts/lib/tabData.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						getMonth();
						var startDate = $("input[name='startDate']").val();
			    		var endDate = $("input[name='endDate']").val();
						var postData = {
							orderby : "ACTION_DATE",
							startDate:startDate,
							endDate:endDate
						};
						mgt_util
								.jqGrid(
										'#grid-table',
										{
											postData : postData,
											url : '${base}/log/logInfoList.jhtml',
											colNames : [ '', '用户ID', '用户登录名',
													'中文名', '订单号', '行动日期',
													'行动代码', '行动类型', '行动名称',
													'业务模块', '业务名称', '业务内容',
													'客户端IP地址', '客户端机器名称',
													'客户端信息', '客户端浏览器信息', '操作' ],
											colModel : [ {
												name : 'PK_NO',
												index : 'PK_NO',
												width : 30,
												hidden : true,
												key : true
											}, {
												name : 'USER_NO',
												width : 30,
												hidden : true,
												key : true
											}, {
												name : 'USER_NAME',
												align : "center",
												width : 30
											}, {
												name : 'NAME',
												align : "center",
												width : 30
											}, {
												name : 'ACTION_ID',
												width : 100,
												align : "center"
											}, {
												name : 'ACTION_DATE',
												width : 100,
												align:"center",
												formatter:function(data){
													if(data==null){return '';}
													var date=new Date(data);
													return date.format('yyyy-MM-dd hh:mm:ss');
												}
											}, {
												name : 'ACTION_CODE',
												width : 60,
												align : "center",
												hidden : true,
												key : true
											}, {
												name : 'ACTION_TYPE',
												align : "center",
												width : 60,
												hidden : true,
												key : true
											}, {
												name : 'ACTION_NAME',
												align : "center",
												width : 60,
												hidden : true,
												key : true
											}, {
												name : 'BIZ_MODULE',
												align : "center",
												width : 40
											}, {
												name : 'BIZ_NAME',
												align : "center",
												width : 80
											}, {
												name : 'BIZ_CONTENT',
												align : "center",
												width : 60,
												hidden : true,
												key : true
											}, {
												name : 'IP_ADDRESS',
												align : "center",
												width : 60
											}, {
												name : 'MACHINE_NAME',
												align : "center",
												width : 60
											}, {
												name : 'CLIENT_INFO',
												align : "center",
												width : 60
											}, {
												name : 'BROWSER_INFO',
												align : "center",
												width : 40
											}, {
												name : 'detail',
												width : 40,
												align : 'center',
												sortable : false,
											} ],
											gridComplete : function() { //循环为每一行添加业务事件 
												var ids = jQuery("#grid-table")
														.jqGrid('getDataIDs');
												for (var i = 0; i < ids.length; i++) {
													var id = ids[i];
													var rowData = $(
															'#grid-table')
															.jqGrid(
																	'getRowData',
																	id);
													detail = "";
													detail = detail
															+ "<button type='button' class='btn btn-info edit' id='"+rowData.PK_NO+"' data-toggle='jBox-show' href='${base}/log/logDetailUI.jhtml'>详情</button> ";
													jQuery("#grid-table")
															.jqGrid(
																	'setRowData',
																	ids[i],
																	{
																		detail : detail
																	});
												}
												;
												//table数据高度计算
												cache = $(".ui-jqgrid-bdivFind")
														.height();
												tabHeight($(".ui-jqgrid-bdiv")
														.height());
											}
										});

							$("#searchbtn").click(
								function() {
									$("#grid-table").jqGrid(
											'setGridParam',
											{
												datatype : 'json',
												postData : $("#queryForm")
														.serializeObjectForm(), //发送数据  
												page : 1
											}
									).trigger("reloadGrid"); //重新载入  
							});

					});

								
							function getMonth() {
								var date = new Date();//当月第一天
								date.setFullYear(date.getFullYear());
								date.setMonth(date.getMonth());
								date.setHours(0);
								date.setMinutes(0);
								date.setDate(1);
								$("#startDate").val(format(date.getTime(), 'yyyy-MM-dd HH:mm'));
								var date1 = new Date();//当月最后一天
								date1.setFullYear(date1.getFullYear());
								date1.setMonth(date1.getMonth()+1);
								date.setHours(0);
								date.setMinutes(0);
								date1.setDate(0);
								$("#endDate").val(format(date1.getTime(), 'yyyy-MM-dd HH:mm'));
								$("#loginfo_search").click();
							}
	var format = function(time, format) {
		var t = new Date(time);
		var tf = function(i) {
			return (i < 10 ? '0' : '') + i
		};
		return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a) {
			switch (a) {
			case 'yyyy':
				return tf(t.getFullYear());
				break;
			case 'MM':
				return tf(t.getMonth() + 1);
				break;
			case 'mm':
				return tf(t.getMinutes());
				break;
			case 'dd':
				return tf(t.getDate());
				break;
			case 'HH':
				return tf(t.getHours());
				break;
			case 'ss':
				return tf(t.getSeconds());
				break;
			}
		})
	}
	
	$("#loginfo_search").live('click',function(){
		//alert(JSON.stringify($("#queryForm").serializeObjectForm()));
		//mgt_util.showMask('正在查询，请稍等...');
		//top.$.jBox.tip('删除成功！','success');
		$("#grid-table").jqGrid('setGridParam',{  
	        datatype:'json',  
	        postData:$("#queryForm").serializeObjectForm(), //发送数据  
	        page:1  
	    }).trigger("reloadGrid"); //重新载入  
	});
				

	function doSearch() {
		$("#loginfo_search").trigger('click');
	}
	// 详情
	function detailUI(id) {
		top.$.jBox.tip('该赠品活动类型未知！！', 'error');
		return false;
	}

	// 详情
	function detai(id) {
		top.$.jBox.tip('该赠品活动类型未知！！', 'error');
		return false;
	}
	function getColProperties(id) {
		var b = jQuery("#" + id)[0];
		var params = b.p.colModel;

		var cols = "";
		for (var i = 1; i < params.length; i++) {
			cols += params[i].name + ",";
		}
		return cols
	}
</script>
</head>
<body>
	<div class="body-container">
		<div class="main_heightBox1">
			<div id="currentDataDiv" action="menu">
				<div class="currentDataDiv_tit">
					<div class="form-group">
			             <button type="button" class="btn_divBtn edit" id="compare_view"  onclick="compare('false');">对比上一条</button>
						 <button type="button" class="btn_divBtn edit" id="compare_view" onclick="compare('true');">对比下一条</button>
			        </div>
			    </div>
		    </div>
				<div class="form_divBox" style="display: block;">
					<form class="form form-inline queryForm" id="query-form">
						<div class="form-group">
							<label class="control-label" >订单号</label> <input type="text"
								class="form-control" name="actionId" style="width: 175px;"
								placeholder="请输入订单号进行查询">
						</div>
						<div class="form-group">
							<label class="control-label" style="vertical-align: middle;">开始时间</label>
							<input type="text" class="form-control" id="startDate"
								style="width: 125px;" name="startDate" value="${startDate}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',readOnly:true})">
						</div>
						<div class="form-group">
							<label class="control-label"
								style="vertical-align: middle; padding-right: 10px;">结束时间</label>
							<input type="text" class="form-control" id="endDate"
								style="width: 125px;" name="endDate" value="${endDate}" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',minDate:'#F{$dp.$D(\'startDate\')}',readOnly:true})">
						</div>
						<script type="text/javascript">
							$(function() {
								$("#startDate")
										.bind(
												"click",
												function() {
													WdatePicker({
														doubleCalendar : true,
														dateFmt : 'yyyy-MM-dd HH:mm',
														autoPickDate : true,
														maxDate : '#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}',
														onpicked : function() {
															endDate.click();
														}
													});
												});
								$("#endDate").bind("click", function() {
									WdatePicker({
										doubleCalendar : true,
										minDate : '#F{$dp.$D(\'startDate\')}',
										maxDate : '%y-%M-%d',
										dateFmt : 'yyyy-MM  HH:mm',
										autoPickDate : true,
										onpicked : doSearch
									});
								});
							});
							function compare(flag){
								var grid = $("#grid-table");
								var ids = $("#grid-table").jqGrid('getGridParam', 'selarrrow');
								if (ids.length <= 0) {
									top.$.jBox.tip('请选择一条记录！');
									return;
								} else if (ids.length > 1) {
									top.$.jBox.tip('选择记录不能超过一条！');
									return;
								}
								url = '${base}/log/logCmpUI.jhtml' + '?id=' + ids[0] + '&nextFlg=' + flag;
								mgt_util.showjBox({
											width : 1000,
											height : 500,
											title : "日志对比",
											url : url,
											grid : grid
										});
							}
							
						</script>
						<!--这里的id和资源中配置的值需要一致。-->
					</form>

					<div class="search_cBox">
						<div class="form-group">
							<button type="button" class="btn_divBtn" id="loginfo_search" data-toggle="jBox-query">搜 索</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<table id="grid-table"></table>
		<div id="grid-pager"></div>
	</div>
</body>
</html>