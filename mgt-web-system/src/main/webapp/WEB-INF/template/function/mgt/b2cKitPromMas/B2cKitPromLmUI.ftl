<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>用户信息管理平台</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
	function addPromLmItem(obj){
		var masPkNo = ${pkNo};
		var	lmCode = $(obj).val();
		
		$.ajax({
			url:'${base}/b2cKitPromMas/addB2cKitPromLm.jhtml',
			type : 'post',
			dataType : 'json',
			data : {
				masPkNo: masPkNo,
				lmCode: lmCode,
				addFlag: obj.checked,
				},
			success : function(data) { 
					top.$.jBox.tip('编辑成功！','success');
					top.$.jBox.refresh = true;
					
			}
       });
		
   }
	
	function addOrList() {
		if($("#selectTypeVal").val()=='1'){
			 $("#selectTypeVal").val("2");
			 $("#sreachFlagSpan").text("查看已添加地标");
		}else{
			 $("#selectTypeVal").val("1");
			 $("#sreachFlagSpan").text("添加地标");
		}
		$.ajax({
			url:'${base}/b2cKitPromMas/b2cKitPromLmList.jhtml',
			type : 'post',
			dataType : 'json',
			data : {
				selectTypeVal: $("#selectTypeVal").val(),
				pkNo: ${pkNo},
			},
			success : function(data) { 
					if (data.selectTypeVal == "1") {
						var promItemList =  jQuery.parseJSON(data.promItemList);
						var landmarkMasList = JSON.parse(data.landmarkMasList);
						var str = "";
						alert(landmarkMasList.length);
						for (var i=0; i<promItemList.length; i++) {
							for(var j=0; j<landmarkMasList.length; j++){
								if (promItemList[i].LM_CODE == landmarkMasList[j].CODE) {
									//str += '<input type="checkbox" id="'+${pkNo}+'" value="'+promItemList[i].LM_CODE+'" onclick="addPromLmItem(this)" />'+landmarkMasList[j].NAME;
									str += '<input type="checkbox" id="'+${pkNo}+'" value="'+landmarkMasList[j].CODE+'" onclick="addPromLmItem(this)" checked=checked/>'+landmarkMasList[j].NAME+'&nbsp\;&nbsp\;&nbsp\;';
								}
							}
						}
						$("#first").html(str);
					} else if (data.selectTypeVal == "2") {
						var landmarkMasList =  jQuery.parseJSON(data.landmarkMasList);
						var str = "";
						for(var i=0; i<landmarkMasList.length; i++){
							str += '<input type="checkbox" id="'+${pkNo}+'" value="'+landmarkMasList[i].CODE+'" onclick="addPromLmItem(this)"/>'+landmarkMasList[i].NAME+'&nbsp\;&nbsp\;&nbsp\;';
						}
						$("#first").html(str);
					}
			}
       });
		
	}
	
	function ss(){
		$.jBox.confirm("确认要保存该数据?", "提示", function(v){
		if(v == 'ok'){
			mgt_util.showMask('正在保存数据，请稍等...');
			setTimeout(function () { 
				mgt_util.hideMask();
			}, 1000);
			
		}
		});
		}
	
   </script>
    </head>
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
                              <input type="checkbox" id="${pkNo}" value="${land.CODE}" onclick="addPromLmItem(this)" [#if land.PROM_CODE?exists] checked [/#if]/>${land.NAME}&nbsp;&nbsp;&nbsp;&nbsp;     
                        [/#list]
                    [/#if]
                   </div>
                </div>
			</div>
		</form>
	</body>
</html>