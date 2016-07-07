<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>赠品发放-商品详情</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={pkNo:${pkNo},type:"${type}"};
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/donation/donationLogs.jhtml',
					postData: postData,
 					colNames:['','商品编码','商品名称','单位','数量','创建时间'],
 					multiselect:false,
 					rownumbers:true,
 					rownumWidth:10,
				   	colModel:[	 
						{name:'PK_NO',index:'PK_NO',width:50,hidden:true,key:true},
						{name:'STK_C',width:50},
						{name:'NAME',width:150},
				   		{name:'UOM',width:30},
				   		{name:'STK_QTY', width:50},
				   		{name:'CREATE_DATE', width:100,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd hh:mm:ss');
						}},
				   	],
				  });
			});
	</script>
    </head>
    <body>
       <div class="body-container">
		    <table id="grid-table" >
		    </table>        		    		    
   		</div>
    </body>
</html>