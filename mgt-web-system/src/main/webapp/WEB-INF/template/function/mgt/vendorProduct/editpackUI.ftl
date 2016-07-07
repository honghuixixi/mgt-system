<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>商品信息管理</title>
	[#include "/common/commonHead.ftl" /]
   <script  type="text/javascript">
		function checkForm(){
			if (mgt_util.validate(addform)){
				var rownum = $("#packTab tr").length;
				 if(rownum == '0'){
				 	top.$.jBox.tip('请添加包装单位！','error');
				 	return false;
				 }
				  var baseStk = $('input[name="baseStk"]:checked').val();
				 if(typeof(baseStk) == 'undefined'){
				 	top.$.jBox.tip('请指定基准库存！','error');
				 	return false;
				 }
				$("#baseStkC").val(baseStk);
				editName();
				var str ="";
				 $("input[name='stkNameExt']").each(function(i,val) {
					str = str+$(val).val()+",";
				});
				$("#stkNameExts").val(str);
				mgt_util.submitForm('#addform');
		  	}
		}
		//校验完成前所有input的name属性不同，校验完成后，name改会分组状态
		function editName(){
			$("input.form-control").each(function(i,val) {
				$(val).attr('name',$(val).attr('namestr'));
			});
		}
	</script>
    </head>
    <body>
       <div class="body-container">
   		 <form class="form-horizontal" action="${base}/vendorPro/update.jhtml"  id="addform" name="addForm" method="POST">
   		 	<input type="hidden" name="pluC" id="PLU_C" value="${pluC}" />
    		<input type="hidden" name="baseStkC" id="baseStkC"/>
    		<input type="hidden" name="bcFlg" id="bcFlg" value='${bcFlg}'/>
    		<input type="hidden" name="ref6" id="ref6" value='${sm.ref6}'/>
    		<input type="hidden" name="vendorCatC" id="vendorCatC" value='${sm.vendorCatC}'/>
    		<input type="hidden" name="vendorStkC" id="vendorStkC" value='${sm.vendorStkC}'/>
    		<input type="hidden" name="globalFlg" id="globalFlg" value='${sm.globalFlg}'/>			
    		<input type="hidden" name="stkNameExts" id="stkNameExts"/>
    		[#include "/function/mgt/vendorProduct/editPack.ftl" /]
			<!--发布取消按钮-->
	 		<div class="upload-btnBox"><a class="upload-btna1" href="#" data-toggle="jBox-call"  data-fn="checkForm">发布</a><a href="#" onclick="mgt_util.closejBox('jbox-win');">取消</a></div>
        </form>
        </div>
        </div>
    </body>
</html>