<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>赠品发放日志</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>		
		<style type="text/css">
 			li:hover { cursor: pointer; }
 			.change-ul li {background:none;display:inline-block;padding:0px 5px;float:left; line-height:20px; font-size:12px;}
 			.change-ul .cur {background:#c2dff7 ;border-radius:5px;}
		</style>
		<script  type="text/javascript">
			$(document).ready(function(){
			        //getMonth();
			        var startDate = $("input[name='startDate']").val();
			        var endDate = $("input[name='endDate']").val();
					mgt_util.jqGrid('#grid-table',{
					    multiselect:false,
						postData: {startDate:startDate,endDate:endDate},
						url:'${base}/donation/donationTaskUserLogList.jhtml?userName=${userName}',
	 					colNames:['客户编码','客户名称','筛选规则','条件','类型','发放日期'],
	 					width:1000,
					   	colModel:[
					   		{name:'CUST_CODE',align:"center",width:100},
					   		{name:'CUST_NAME',align:"center",width:200},
					   		{name:'FILTER_RULE',align:"center",width:100,align:"center",formatter:function(data){
								if(data=='A'){
									return '按订单金额';
								}else if(data=='B'){
									return '按订货频率';
								}else if(data=='M'){
									return '手工添加';
								}else{
									return '';
	   							}
	   						  }
	   						},
					   		{name:'FILTER_CON',align:"center",width:250},
					   		{name:'DONATION_TYPE',width:80,align:"center",formatter:function(data){
								if(data=='S'){
									return '实物';
								}else if(data=='C'){
									return '优惠券';
								}else{
									return '';
	   							}
	   						  }
	   						},
					   		{name:'CREATE_DATE',width:150,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd hh:mm:ss');
							}}
					   	],
					   	gridComplete:function(){ 
							//table数据高度计算
							cache=$(".ui-jqgrid-bdivFind").height();
							tabHeight($(".ui-jqgrid-bdiv").height());
						}
					});
					
					$(".change-ul li").click(function(){
						$(".change-ul li").removeClass("cur");
						$(this).addClass("cur");
					});
					$("#stock_query").click(function(){
						$(".change-ul li").removeClass("cur");
					});
				});
				
				var format = function(time, format){
			    var t = new Date(time);
			    var tf = function(i){return (i < 10 ? '0' : '') + i};
			    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){
			        switch(a){
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
				
				function getToday(){
					var date=new Date();
					form1.startDate.value = format(date.getTime(), 'yyyy-MM-dd');
					form1.endDate.value = format(date.getTime(), 'yyyy-MM-dd');
					$("#stock_query").click();
				}
				function getWeek(){
					var myDate = new Date();
					var date = new Date(myDate-(myDate.getDay()-1)*86400000);
					var dateOne = date.getTime()
					var dateSeven = myDate.getTime()
					form1.startDate.value=format(dateOne, 'yyyy-MM-dd');
					form1.endDate.value=format(dateSeven, 'yyyy-MM-dd');
					$("#stock_query").click();
				}
				function getMonth(){
					var date=new Date();//今天
					form1.endDate.value = format(date.getTime(), 'yyyy-MM-dd');
				 	date.setDate(1);//当前月的第一天
					form1.startDate.value = format(date.getTime(), 'yyyy-MM-dd');
					$("#stock_query").click();
				}
				function doSearch() {
	        		$("#stock_query").trigger('click');
	       		}
	       		
	       		// 详情
				function detailUI(id,type){
					if('S'==type){
        				mgt_util.showjBox({
        					width : 1000,
        					height : 500,
        					title : '编辑',
       	    				url : '${base}/donation/LogDetails.jhtml?id='+id+'&type='+type,
            				grid : $('#grid-table')
        				});
					}else if('C'==type){
        				mgt_util.showjBox({
        					width : 1000,
        					height : 500,
        					title : '编辑',
       	    				url : '${base}/donation/LogDetails.jhtml?id='+id+'&type='+type,
            				grid : $('#grid-table')
        				});					
					}else{
						top.$.jBox.tip('该赠品活动类型未知！！', 'error');
						return false;
					}
    			 }
    		//撤销按钮
			function cancle(id){
				$.jBox.confirm("确认撤销并删除该记录吗?","提示",function(v){
					if(v=='ok'){
						$.ajax({
							url:'${base}/donation/LogCancle.jhtml',
							sync:false,
							type:'post',
							dataType:'json',
							data:{
								'id':id,
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
									if(data.code==001){
										top.$.jBox.tip('操作成功！', 'success');
										top.$.jBox.refresh = true;
										$('#grid-table').trigger("reloadGrid");
									}else if(data.code==002){
										top.$.jBox.tip('商品已被领取，不可撤销！', 'error');
							 			return false;
									}else if(data.code==003){
										top.$.jBox.tip('优惠券已被使用，不可撤销！', 'error');
							 			return false;
									}else if(data.code==004){
										top.$.jBox.tip('优惠券不存在！', 'error');
							 			return false;
									}else{
										top.$.jBox.tip('操作失败，请联系管理员！', 'error');
							 			return false;
									}
							}
						});
					}
				});
   			 }		 
    		//发放按钮
			function send(id){
				$.jBox.confirm("确认执行发放操作吗?","提示",function(v){
					if(v=='ok'){
						$.ajax({
							url:'${base}/donation/send.jhtml',
							sync:false,
							type:'post',
							dataType:'json',
							data:{
								'id':id,
							},
							error:function(data){
								alert("网络异常")
								return false;
							},
							success:function(data){
									if(data.code==001){
										top.$.jBox.tip('操作成功！', 'success');
										top.$.jBox.refresh = true;
										$('#grid-table').trigger("reloadGrid");
									}else if(data.code==002){
										top.$.jBox.tip('该活动状态不允许执行发放！', 'error');
							 			return false;
									}else{
										top.$.jBox.tip('操作失败，请联系管理员！', 'error');
							 			return false;
									}
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
			<div style="border-bottom:1px solid #f39801;overflow:hidden;padding-bottom:10px;">
	            <form class="form form-inline queryForm"  id="query-form" name="form1">
	           		<div>
	           			<ul class="change-ul" style="list-style:none;padding-top:14px;float:left;">
    						<li  onClick="getToday()">今日</li>
    						<li  onClick="getWeek()">本周</li>
    						<li  style="margin-right:10px;"  onClick="getMonth()">本月</li>
  						</ul>
	               	 </div>
	                 <div class="form-group">
						<label class="control-label" style=" vertical-align: middle;">时间从</label>
						<input type="text" class="form-control" id="startDate" style="width:90px;" name="startDate" value="${startDate}">
					 </div>
					 <div class="form-group">
						<label class="control-label" style=" vertical-align: middle;padding-right:10px;">时间至</label>
						<input type="text" class="form-control" id="endDate" style="width:90px;" name="endDate" value="${endDate}">
					 </div>
					 <div class="form-group">
					 	 <label class="control-label" style=" vertical-align: middle;"></label>
		                 <input type="hidden" class="form-control" name="nameOrCustCode" id="nameOrCustCode" value="${nameOrCustCode}" placeholder="输入客户名称/编码搜索" style="width:150px;" >
					 </div>
						<script type="text/javascript"> 
								$(function(){
							         $("#startDate").bind("click",function(){
							             WdatePicker({dateFmt:'yyyy-MM-dd'});
							         });
							         $("#endDate").bind("click",function(){
							             WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}',dateFmt:'yyyy-MM-dd'});
							         });
								});
								</script>
						<div class="search_cBox" style="bottom:20px;">
							 <div class="form-group">
							 	<!-- <button class="search_cBox_btn btn btn-info"  id="order_search" data-toggle="jBox-call"  data-fn="checkForm">
							 	搜索<i class="fa-save align-top bigger-125 fa-on-right"></i>
						        </button>-->
						        <button type="button" class="btn_divBtn" id="stock_query" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	           			    </div>
           			    </div>
	            </form>
	        </div>
	      </div>
		  <table id="grid-table"></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>

<script type="text/javascript">
</script>
</html>