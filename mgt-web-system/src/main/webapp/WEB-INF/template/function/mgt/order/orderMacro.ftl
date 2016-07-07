[#macro chinesesTatus status]
    [#if status == "WAITDELIVER"]待发货
    [#elseif status == "WAITPAYMENT"]待支付
    [#elseif status == "INPROCESS"]处理中
    [#elseif status == "DELIVERED"]已发货
    [#elseif status == "RETURNSING"]退单中
    [#elseif status == "SUCCESS"]交易成功
    [#elseif status == "CLOSE"] 交易关闭
    [#else][/#if]
[/#macro]

[#macro OrderPrint print couponMas]  
  <div id="printdiv_h">
  	  <table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb01" style="border-collapse:collapse">
    	<tbody>
    	<tr>
     		<td colspan="3" align="center">(www.qpwa.cn)</td>
    	</tr>
    	<tr>
      		<td style="text-align:left;float: left;" width="37%">单据编号：${order.get("MAS_NO")}</td>
      		<td style="text-align:left;float: left;" width="33%">单据日期：${order.get("OM_CREATE_DAT")}</td>
    	</tr>
   	    <tr>
     		<td style="text-align:left;float: left;" width="37%">供&nbsp;应&nbsp;商&nbsp;：${order.get("VENDOR_CODE")}</td>
     		[#if order.get("EMPNAME")?exists && order.get("EMPNAME") != 'null']
     			<td style="text-align:left;float: left;" width="63%">业&nbsp;务&nbsp;员&nbsp;：${order.get("EMPNAME")}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号：${order.get("EMPMOBILE")}</td>
    		[/#if]
    	</tr>
    	<tr>
      		<td colspan="3" align="left">客户名称：${order.get("CUST_NAME")}</td>
    	</tr>
    	<tr>
      		<td>客户电话：[#if order.get("RECEIVER_MOBILE")?exists && order.get("RECEIVER_MOBILE") != 'null']
      						${order.get("RECEIVER_MOBILE")}
      				   [#elseif order.get("RECEIVER_TEL")?exists && order.get("RECEIVER_TEL") != 'null']
      				   		${order.get("RECEIVER_TEL")}
      				   [/#if]
      		</td>
      		[#if order.get("Area")?exists && order.get("Area") != 'N']
      			<td colspan="2">送货区域：${order.get("Area")}</td>
      		[/#if]
    	</tr>
    	<tr>
      		<td colspan="2">送货地址：${order.get("RECEIVER_ADDRESS")}</td>
    	</tr>
    	</tbody>
  	 </table>
  </div>
  <div id="printdiv_b">
     <table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">
  		<thead>
 			<tr bgcolor="#F8F8FF" border="1" height="18" >
     			<th align="center" width="6%" style="border:1px solid #000; border-right:none 0;">序号</th>
    			<th align="center" width="18%" style="border:1px solid #000; border-right:none 0;">条码/编码</th>
     			<th align="center" width="40%" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>
     			<th align="center" width="6%" style="border:1px solid #000; border-right:none 0;">数量</th>
     			<th align="center" width="6%" style="border:1px solid #000; border-right:none 0;">单位</th>
     			<th align="center" width="10%" style="border:1px solid #000; border-right:none 0;">价格</th>
    			<th align="center" width="14%" style="border:1px solid #000;">金额小计</th>
  			</tr>
  		</thead>
  		<tbody>
  			[#list print.get("orderItem") as item]
  			<tr height="15" bgColor="#ffffff">
    			<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${item.ITEM_NO}</td>
    			<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">[#if item.PLU_C??]${item.PLU_C}[#else]${item.STK_C}[/#if]</td>
    			<td align="left" colspan="2"style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.STK_NAME}</td>
    			<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.UOM_QTY}</td>
    			<td align="center" style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.UOM}</td>
    			<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.NET_PRICE?string("0.00")}</td>
    			<td align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">${(item.UOM_QTY * item.NET_PRICE)?string("0.00")}</td>
  			</tr>
 			[/#list] 
 	<!-- 
  			<tr height="15" bgColor="#ffffff">
    			<td colspan="2" align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">
    				总金额：${(print.get("AMOUNT")-order.get("FREIGHT")+order.get("MISC_PAY_AMT")!0.00)?string("0.00")}
    			</td>
    			<td colspan="2" align="center" style="border-bottom:1px solid #000;">
    				优惠：[#if order.get("MISC_PAY_AMT")?exists && null != order.get("MISC_PAY_AMT")] ${order.get("MISC_PAY_AMT")?string("0.00")}[#else]0.00[/#if]
    			</td>
    			<td colspan="2" align="left" style="border-bottom:1px solid #000;">
    				已付：[#if alPayNum?exists && null != alPayNum] ${(alPayNum)?string("0.00")}[#else]0.00[/#if]
    			</td>
    			<td colspan="2" align="center" style="border-bottom:1px solid #000;border-right:1px solid #000;">
    				应付：${(print.get("AMOUNT")-order.get("FREIGHT")-alPayNum)?string("0.00")}
    			</td>
  			</tr>
  	-->  	
  			<tr height="15" bgColor="#ffffff">
    			<td colspan="2" align="right" style="border-left:1px solid #000;border-bottom:1px solid #000;">
    				总金额：${(print.get("AMOUNT")+order.get("FREIGHT")!0.00)?string("0.00")}
    			</td>
    			<td colspan="2" align="center" style="border-bottom:1px solid #000;">
    				优惠：[#if order.get("MISC_PAY_AMT")?exists && null != order.get("MISC_PAY_AMT")] ${order.get("MISC_PAY_AMT")?string("0.00")}[#else]0.00[/#if]
    			</td>
    			<td colspan="2" align="left" style="border-bottom:1px solid #000;">
    				已付：[#if alPayNum?exists && null != alPayNum] ${(alPayNum)?string("0.00")}[#else]0.00[/#if]
    			</td>
    			<td colspan="2" align="center" style="border-bottom:1px solid #000;border-right:1px solid #000;">
    				应付：[#if order.get("MISC_PAY_AMT") == null ]
    						${(print.get("AMOUNT")+order.get("FREIGHT"))?string("0.00")}
    					[#else]
    						${(print.get("AMOUNT")+order.get("FREIGHT")-order.get("MISC_PAY_AMT"))?string("0.00")}
    			 		[/#if]
    			</td>
  			</tr>  			
  		</tbody>
  		<tfoot>
    		<tr><td colspan="8" height="10"></td></tr>
    		<tr>
      			<td colspan="2" align="center">厂家送货：</td>
      			<td colspan="3" align="center">物流1送货： </td>
      			<td colspan="3" align="center">物流2送货：</td>
    		</tr>
    		<tr><td colspan="8" height="10"></td></tr>
    		<tr>
      			<td colspan="2" align="center">物流1收货：</td>
      			<td colspan="3" align="center">物流2收货： </td>
      			<td colspan="3" align="center">客户签字：</td>
    		</tr>
    		<tr><td colspan="8" height="10"></td></tr>
    		<tr>
      			<td colspan="4" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;送货日期：</td>
      			<td colspan="4" align="right">打单时间：${date}</td>
    		</tr>
    		<tr><td colspan="8" height="10"></td></tr>
    		<tr>
      			<td colspan="1" align="left"></td>
      			<td colspan="7" align="left">备注：${order.get("REMARK")}</td>
    		</tr>
    		<tr><td colspan="8" height="10"></td></tr>
    		<tr>
    			<td colspan="2" align="left"></td>
      			<td colspan="6" align="left">*千平万安电商平台，终端模式倡导者。全国统一服务热线：400-6699-008*</td>
    		</tr>
    		<tr><td colspan="8" height="10"></td></tr>
  		</tfoot>
    </table>
  </div> 
 [/#macro] 