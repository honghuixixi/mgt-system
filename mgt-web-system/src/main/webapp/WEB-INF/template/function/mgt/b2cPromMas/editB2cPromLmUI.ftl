<!DOCTYPE html>
<html>
	<head>
		<title>菜单新增</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
	</head>
	<style>
		.page-content span{padding-right:15px;}
		.page-content span input{margin-right:5px;}
	</style>

<script>
	$(document).ready(function(){
		addAreaSelect($(".area_list"));
		loadArea();
		
	});
	// 加载区域选项
		function loadArea(){
    		$("#areaId").lSelect({
    			isArea:"on",
	    		url:"${base}/common/areao.jhtml"
    		});
		}
 		// 显示区域下拉列表
		function addAreaSelect(v){
    		v.append('<input type="text"  id="areaId" name="areaId"  treePath="" value="" style="display:block; width:0;float:right; border:none; color:#fff;"/>'); 
		}
		
		// 删除区域下拉列表
		function removeAreaSelect(v){
    		v.empty();
		}
		
		//搜索
		function search(){
        	var selectTypeVal = $("#selectTypeVal").val();
        	if($("#selectTypeVal").val()=='1'){
				 $("#selectTypeVal").val("2");
				 $("#sreachFlagSpan").text("查看已选地标");
				 }else{
				 $("#selectTypeVal").val("1");
				 $("#sreachFlagSpan").text("搜索");
				 }
            var areaId = $("#areaId").val();
            if(areaId == null){
             alert("请选择所查询的地区");
            }	
            $.ajax({
                url:'${base}/b2cPromMas/searchLm.jhtml',
                sync:false,
                type : 'post',
                dataType : 'json',
                data :{
                    'pkNo':${pkNo},
                    'areaId':areaId,
                    'selectTypeVal':selectTypeVal
                },
                error : function(data) {
                    alert("网络异常");
                    return false;
                },
                success : function(data) {
                    if(data.code==001 && data.data!=null){
                        //在表格后面加载数据
                        var landmarkList = data.data.landmarkList;
                        if($("#lmCheck").text().trim()!=""){
                            $("#lmCheck").empty();
                        }
                        var html = "";
                        if(landmarkList!=null){
                            $.each(landmarkList, function (index, lm) {
                                html+= "<span><input type='checkbox' name='codes' onclick='change(this)' title='"+lm.NAME+"' value='"+lm.CODE+"' ";
                                 if( selectTypeVal == '2'){
                                    html+= " checked />" ;
                                }else{
                                    html+="/>";
                                }
                                html+=lm.NAME;
                                html+="</span>";
                            });
                           
                        }
                        $("#lmCheck").append(html);

                    }else{
                        /*$("#resource").hidden();*/
                        top.$.jBox.tip(data.msg, 'error');
                        return false;
                    }
                }

            });
    }
    //选择复选框或者反选操作
    function change(obj){
      var lmcode = $(obj).val();
      var pkNo = $('#pkNo').val();

         $.ajax({
             url:'${base}/b2cPromMas/addB2cPromLm.jhtml',
             sync:false,
             type : 'post',
             dataType : 'json',
             data :{
                 pkNo:pkNo,
                 addFlag: obj.checked,
                 lmCode:lmcode
             },
             error : function(data) {
                 alert("网络异常");
                 return false;
             },
             success : function(data) {
             
                 if(data.code==001){
                    top.$.jBox.tip('增加地标成功！', 'success');
                        
                 }else{
                     top.$.jBox.tip('增加地标失败！', 'error');
                     return false;
                 }
             }
         });
     
     
  }
</script>
	<body class="toolbar-fixed-top">
		<form class="form-horizontal" id="form" action="${base}/b2cPromMas/editB2cPromLm.jhtml" method="POST">
			<input type="hidden"id="pkNo" name="pkNo"  value="${pkNo}" >
			<input type="hidden"id="selectTypeVal" name="selectTypeVal"  value="1" >
 	        <div class="page-content">
				<div class="row">
                <div  class="page-content">
                   <div  id="lmCheck" style='float:left;margin:0;'>
                     [#if landmarkList?exists]
                        [#list landmarkList as land]
                               <input type="checkbox" name="codes" value="${land.CODE}" title=" ${land.NAME}"  onclick="change(this)" [#if land.PROM_CODE?exists] checked [/#if]>
                                ${land.NAME}        
                        [/#list]
                    [/#if]
                   </div>
                </div>
			</div>
		</form>
	</body>
</html>
