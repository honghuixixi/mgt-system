<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>财务管理-汇总账单</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script type="text/javascript" src="${base}/scripts/lib/jquery/common.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
			
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/paybill/paybillSummary.jhtml',
 					colNames:['','创建时间','交易分类','交易金额','对账状态','交易说明','操作'],
				   	colModel:[
				   		{name:'PK_NO',index:'PK_NO',width:0,hidden:true,key:true},
				   		{name:'CREATE_TIME',align:"center",width:250,formatter : function(data){
                            if(!isNaN(data) && data){
                            data = (new Date(parseFloat(data))).format("yyyy-MM-dd hh:mm:ss");
                            }
                            return data;
                            }
                        },
				   		{name:'TRAN_TYPE',align:"center",width:'220',
				   		editable:true,formatter:function(data){
							if(data=='9001'){
								return '第三方支付平台收款';
							}else if(data=='9002'){
								return '资金归集';
							}else if(data=='9003'){
								return '批量代付';
							}
	   					}
				   		},
				   		{name:'TRANAMOUNT',align:"center",width:110},
				   		{name:'CHANNEL_CHECK_STATE',align:"center",width:'130',
				   		    editable:true,formatter:function(data){
								return '未对账';
	   					    }
				   		},
				   		{name:'TRAN_NOTE',align:"center",width:110},
                        {name:'',width:200,align:"center",editable:true,formatter:function(value,row,index) {

                          //  return '<button type="button" class="btn btn-info edit"  id="' + index.PK_NO + '"  onClick=checkPaybillUI("' + index.PK_NO + '","' + index.SN + '","'+index.TRANAMOUNT+'") > 确认对账 </button > ';
                          return '';
                        } }
				   	],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
					/*,
				   		gridComplete:function(){ //循环为每一行添加业务事件
                            var ids=jQuery("#grid-table").jqGrid('getDataIDs');
						    for(var i=0; i<ids.length; i++){
							var id=ids[i]; 
							//detail ="<button type='input'  class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' onClick=checkPaybillUI('"+id+"') href='${base}/paybill/checkPaybillUI.jhtml'>确认对账</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
						}
					}*/
				   	
				});
				
			});
            function checkPaybillUI(id,sn,tranAmount){
                mgt_util.showjBox({
                    width : 700,
                    height : 400,
                    title : '编辑',
                    url : '${base}/paybill/checkPaybillUI.jhtml?id='+id+'&sn='+sn+"&tranAmount="+tranAmount,
                    grid : $('#grid-table')
                });
            }
		</script>
    </head>
    <body>
     <div class="body-container">
        <div class="main_heightBox1"></div>    
		<table id="grid-table" ></table>
     </div>
    </body>

</html>