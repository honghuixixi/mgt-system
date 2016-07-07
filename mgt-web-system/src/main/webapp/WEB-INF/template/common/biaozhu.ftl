<div class="row">
	<div class="col-xs-6">
		<div class="form-group pad_top">
			<label style="padding-top:13px;" for="memo" class="col-sm-3 control-label">客户位置：</label>
		    <div class="col-sm-8 width_big">
		    	<input type="hidden" id="lng" name="lng" value="${user.longitude}">
			    <input type="hidden" id="lat" name="lat" value="${user.latitude}">
			    <input type="hidden" id="address" name="address" value="${locationStr}">
	           <span style="display: block;float: left;overflow: hidden;padding-top: 8px;line-height:20px; width: 631px;">
	           <button type="button" class="btn_divBtn" id="biaozhu" name="biaozhu">标注</button><label align="left" id="addressStr">${locationStr}</label>
				</span>
		    </div>
		</div>
	</div>
</div>
<script type="text/javascript">
	 $("#biaozhu").click(function(){
	 jBox.open("iframe:${base}/vendorCust/labelLocationUI.jhtml", null, 900, 360, { buttons: { '确定': true,'关闭': false  },
	 iframeScrolling: 'no',
	  showClose: false,
	  loaded: function (h) {
            var iframeName = h.children(0).attr("name");
	        var container = window.frames[iframeName].document;
	        $("#lng", container).val('${user.longitude}');
	        $("#lat", container).val('${user.latitude}');
	        $("#address", container).val('${user.crmAddress4}');
        },
      submit: function (v,h,f) {
            if(v){
            	var iframeName = h.children(0).attr("name");
		        var container = window.frames[iframeName].document;
		        var lng = $("#lng", container);
		        var lat = $("#lat", container);
		        var address = $("#address", container);
		        if(lng.val()){
		        	 //top.$.jBox.tip('有值');
		        	 $("#lng").val(lng.val());
		        	 $("#lat").val(lat.val());
		        	 $("#address").val(address.val());
		        	  $("#addressStr").html(address.val());
		        }else{
		        	 top.$.jBox.tip('未标注客户位置');
		        	 return false;
		        }
            }
        } 
        });
	});
</script>