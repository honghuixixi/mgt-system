[#macro SupOrderPrint supPrint] 
  <div id="printdiv_b">
     <table width="90%" align="center" style=" font-size:15px;" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" id="tb02" style="border-collapse:collapse">
  		<thead>
 			<tr bgcolor="#F8F8FF" border="1" height="18" >
     			<th align="center"style="border:1px solid #000; border-right:none 0;">编号</th>
     			<th align="center"style="border:1px solid #000; border-right:none 0;">商品编码</th>
    			<th align="center" style="border:1px solid #000; border-right:none 0;">条码</th>
     			<th align="center" colspan="2" style="border:1px solid #000; border-right:none 0;">商品名称</th>
     			<th align="center" style="border:1px solid #000; border-right:none 0;">单位</th>
     			<th align="center" style="border:1px solid #000; border-right:none 0;">数量</th>
     			<th align="center" style="border:1px solid #000; border-right:none 0;">净价</th>
    			<th align="center" style="border:1px solid #000;">小计</th>
  			</tr>
  		</thead>
  		<tbody>
  			[#list supPrint.get("orderItem") as item]
  			<tr height="15" bgColor="#ffffff">
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${item_index+1}</td>
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;" >${item.STK_C}</td>
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;">[#if item.PLU_C??]${item.PLU_C}[#else]${item.STK_C}[/#if]</td>
    			<td align="left" colspan="2"style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.STK_NAME}</td>
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.UOM}</td>
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.STK_QTY}</td>
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;">${item.NET_PRICE?string("0.00")}</td>
    			<td align="left" style="border-left:1px solid #000;border-bottom:1px solid #000;border-right:1px solid #000;">${(item.STK_QTY * item.NET_PRICE)?string("0.00")}</td>
  			</tr>
 			[/#list] 
  		</tbody>
    </table>
  </div> 
 [/#macro] 