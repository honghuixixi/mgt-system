 <script  type="text/javascript">
 	//添加一行
	function editPack(){
		var mytime=new Date().getTime(); //获取当前时间
		var	baseStk = "<input type='radio' class='editRadio' id = 'baseStk' name='baseStk' value='"+mytime+"'>";
		var stkNameExt="<input type='text' class='pack form-control ' namestr='stkNameExt'  name='stkNameExt"+mytime+"' />";
		var modle="<input type='text' class='pack form-control required' namestr='modle'  name='modle"+mytime+"' />";
		var packUom="<input type='text' class='pack form-control required uomLength' namestr='packUom'  name='packUom"+mytime+"' />";
		var packCodev=$("#PLU_C").val();
		var packCode="<input type='text' style='width:100px;' class='pack form-control abcnb required' value='"+packCodev+"' maxlength='14' namestr='packCode' value='"+packCode+"' name='packCode"+mytime+"' />";
		var packQty="<input type='text' class='pack qtycls form-control number required' maxlength='14' namestr='packQty'  name='packQty"+mytime+"'/>";
		var packListPrice="<input type='text' class='pack form-control number required' maxlength='14' namestr='packListPrice'  name='packListPrice"+mytime+"' />";
		var packPrice="<input type='text' class='pack form-control number required' maxlength='14' namestr='packPrice'  name='packPrice"+mytime+"' />";
		var packNum="<input type='text' class='pack form-control number required' maxlength='9' namestr='packNum'  name='packNum"+mytime+"' />";
		var minStkLevel="<input type='text' class='pack form-control number ' maxlength='22' namestr='minStkLevel' name='minStkLevel"+mytime+"' />";
		var maxStkLevel="<input type='text' class='pack form-control number ' maxlength='22' namestr='maxStkLevel' name='maxStkLevel"+mytime+"' />";
		var minOrderQty="<input type='text' class='pack form-control number ' maxlength='22' namestr='minOrderQty' name='minOrderQty"+mytime+"' />";
		var th = "<tr height='40'><td>"+baseStk+"<input name='myId' id='myId' type='hidden' value='"+mytime+"'></td><td >"+stkNameExt+"</td><td >"+modle+"</td><td >"+packUom+"</td><td >"+packCode+"</td><td>"+packQty+"</td><td >"+packListPrice+"</td><td >"+packPrice+"</td><td >"+packNum+"</td><td >"+minStkLevel+"</td><td >"+maxStkLevel+"</td><td>"+minOrderQty+"</td><td ><label class='control-label'><a href='#' class='del' stkc='new'>删除</a></label></td></tr>";
         $("#packTab").append(th);
	}
	
	function jizhunUomInit(){
		$("input.editRadio").each(function(i,val) {
			if($(this).attr("checked") == 'checked'){
				$(this).parent().parent().find('input.qtycls').val(1).attr("readonly","readonly");
			}else{
				$(this).parent().parent().find('input.qtycls').removeAttr("readonly");
			}
		});
	}
	
	//校验完成前所有input的name属性不同，校验完成后，name改会分组状态
	function editName(){
		$("input.pack").each(function(i,val) {
			$(val).attr('name',$(val).attr('namestr'));
		});
	}
	$(document).ready(function(){
		$(".editRadio").live("click",function(){
			jizhunUomInit();
		});
		
		//包装单位长度验证
		jQuery.validator.addMethod("uomLength", function(value, element) { 
			var length = jmz.GetLength(value);
			return  length<9; 
		}, "字符长度不能大于8");
		
		//最小零售单位长度验证
		jQuery.validator.addMethod("maxUomLength", function(value, element) { 
			var length = jmz.GetLength(value);
			return  length<17; 
		}, "字符长度不能大于16");
	
		//名称长度验证
		jQuery.validator.addMethod("nameLength", function(value, element) { 
			var length = jmz.GetLength(value);
			return  length<256; 
		}, "长度不能大于256");
		var jmz = {};
		jmz.GetLength = function(str) {
		    var realLength = 0, len = str.length, charCode = -1;
		    for (var i = 0; i < len; i++) {
		        charCode = str.charCodeAt(i);
		        if (charCode >= 0 && charCode <= 128) realLength += 1;
		        else realLength += 3;
		    }
		    return realLength;
		};
		
		//删除一行
		$("a.del").live("click",function(){
			var stkc = $(this).attr("stkc");
			var status = $(this).attr("stkFlg");
			var note = "删除";
			if(status =='S'){
				status = 'Z';
			}else if(status =='Z'){
				status = 'S';
				note = "恢复";
			}
			if(status == 'S'){
				$(this).html("删除");
			}else{
				$(this).html("恢复");
			}
			$(this).attr("stkFlg",status);
			if(stkc != 'new'){
				$.jBox.confirm("确定"+note+"吗", "提示", function(v){
					if(v == 'ok'){
						$.ajax({
							url : '${base}/vendorPro/updateStatus.jhtml',
							type :'post',
							dataType : 'json',
							data : 'ids=' + stkc+'&status='+status,
							success : function(data) {
							if(data.code==001){		
								top.$.jBox.tip('操作成功！', 'success');
							}else{
								top.$.jBox.tip(data.msg, 'error');
										return false;
								}
							}
						});
					 }
				});
			}else{
				var tr = $(this).parent().parent().parent();
				tr.remove();
			}
		});
	});
</script>
<div class="box-revise-list maT10">
	<h3>定义包装</h3>
	<div class="edit-btnBox"><button type="button" class="btn btn-info btn_divBtn" id='' onclick="editPack();"> 增加包装单位</button></div>
	<div class="edit-listTab">
		<table id="packTab" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th height="40" width="7%">基准库存</th>
				<th width="12%">扩展描述</th>
				<th width="9%">规格</th>
				<th width="6%">包装单位</th>
				<th width="15%">包装码</th>
				<th width="6%">包装数量</th>
				<th width="6%">参考价格</th>
				<th width="6%">价格</th>
				<th width="6%">供货量</th>
				<th width="6%">最低库存</th>
				<th width="6%">最高库存</th>
				<th width="6%">安全库存</th>
				<th width="7%">操作</th>
			</tr>
		</thead>
		<tbody>
			[#if stklist??]
			[#list stklist as stk]
    			<tr height='40px'>
    			<td >
    			[#if stk.STK_C == stk.BASE_STK_C]
				<input type='radio' class='editRadio' checked id = 'baseStk' name='baseStk' value='${stk.STK_C}'>
				[#else]
				<input type='radio' class='editRadio' id = 'baseStk' name='baseStk' value='${stk.STK_C}'>
				[/#if]
				</td>
				<td>
				<input type='text' class='pack form-control ' namestr='stkNameExt' name='stkNameExt${stk.STK_C}' value="${stk.STK_NAME_EXT}"/>
				</td>
				<td>
				<input type='text' class='pack form-control required' namestr='modle' name='modle${stk.STK_C}' value="${stk.MODLE}"/>
				</td>
    			<td width='50px'>
    				<input type='text' class='pack form-control required uomLength' maxlength='8' namestr='packUom' name='packUom${stk.STK_C}' value="${stk.UOM}"/>
    				<input type='hidden' name="stkC" id ="stkC" value="${stk.STK_C}"/>
    				<input type='hidden' name="myId" id ="myId" value="${stk.STK_C}"/>
					</td><td>
						<input type='text' style='width:100px;' class='pack form-control required' maxlength='14' namestr='packCode' value='${stk.PACK_PLU_C}' name='packCode${stk.STK_C}' />
					</td><td>
					[#if stk.STK_C == stk.BASE_STK_C]
					<input type='text' readonly="readonly" class='pack form-control qtycls number required' namestr='packQty' name='packQty${stk.STK_C}' value="${stk.PACK_QTY}"/>
					[#else]
					<input type='text' class='pack form-control qtycls number required' namestr='packQty' name='packQty${stk.STK_C}' value="${stk.PACK_QTY}"/>
					[/#if]
					</td><td>
					<input type='text' class='pack form-control  number required' namestr='packListPrice' name='packListPrice${stk.STK_C}' value="${stk.LIST_PRICE}"/>
					</td><td>
					<input type='text' class='pack form-control  number required' namestr='packPrice' name='packPrice${stk.STK_C}' value="${stk.NET_PRICE}"/>
					</td><td>
					<input type='text' class='pack form-control  number required' namestr='packNum' maxlength='9' name='packNum${stk.STK_C}' value="${stk.SUPPLY_QTY}"/>
					</td><td>
					<input type='text' class='pack form-control  number ' namestr='minStkLevel' name='minStkLevel${stk.STK_C}' value="${stk.MIN_STK_LEVEL}"/>
					</td><td>
					<input type='text' class='pack form-control  number ' namestr='maxStkLevel' name='maxStkLevel${stk.STK_C}' value="${stk.MAX_STK_LEVEL}"/>
					</td><td>
					<input type='text' class='pack form-control  number ' namestr='minOrderQty' name='minOrderQty${stk.STK_C}' value="${stk.MIN_ORDER_QTY}"/>
					</td><td><label class='control-label'><a href='#' class='del' stkFlg="${stk.STK_FLG}" stkc="${stk.STK_C}">[#if stk.STK_FLG == 'S']删除[#else]恢复[/#if]</a></label></td>
					</tr>
			 [/#list]
			 [/#if]
			<tbody>
		</table>
	</div>
</div>