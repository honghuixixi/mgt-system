<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>赠品发放-优惠券详情</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
			$(document).ready(function(){
				var postData={pkNo:"${pkNo}",type:"${type}"};
				mgt_util.jqGrid('#grid-table',{
					url:'${base}/donation/donationLogs.jhtml',
					postData: postData,
 					colNames:['','券面值','最低消费金额','券数量','券有效期起','券有效期止','券创建时间'],
 					multiselect:false,
 					rownumbers:true,
 					rownumWidth:10,
				   	colModel:[	 
						{name:'PK_NO',index:'PK_NO',hidden:true,key:true},
						{name:'CP_VALUE',width:60},
				   		{name:'MIN_AMT_NEED',width:60},
				   		{name:'CP_QTY', width:40},
				   		{name:'CP_DATE_FROM', width:100,formatter:function(data){
							if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
				   		{name:'CP_DATE_TO', width:100,formatter:function(data){
								if(data==null){return '';}
								var date=new Date(data);
								return date.format('yyyy-MM-dd');
						}},
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