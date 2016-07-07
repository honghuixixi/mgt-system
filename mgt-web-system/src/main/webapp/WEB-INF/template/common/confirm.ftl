<script>

var isIE = (document.all) ? true : false;
//isIE && ([/MSIE (\d)\.0/i.exec(navigator.userAgent)][0][1] == 6)
var isIE6 = null ;

var daole = function (id) {
	return "string" == typeof id ? document.getElementById(id) : id;
};

var Class = {
	create: function() {
		return function() { this.initialize.apply(this, arguments); }
	}
}

var Extend = function(destination, source) {
	for (var property in source) {
		destination[property] = source[property];
	}
}

var Bind = function(object, fun) {
	return function() {
		return fun.apply(object, arguments);
	}
}

var Each = function(list, fun){
	for (var i = 0, len = list.length; i < len; i++) { fun(list[i], i); }
};

var Contains = function(a, b){
	return a.contains ? a != b && a.contains(b) : !!(a.compareDocumentPosition(b) & 16);
}


var OverLay = Class.create();
OverLay.prototype = {
  initialize: function(options) {

	this.SetOptions(options);
	
	this.Lay = daole(this.options.Lay) || document.body.insertBefore(document.createElement("div"), document.body.childNodes[0]);
	
	this.Color = this.options.Color;
	this.Opacity = parseInt(this.options.Opacity);
	this.zIndex = parseInt(this.options.zIndex);
	
	with(this.Lay.style){ display = "none"; zIndex = this.zIndex; left = top = 0; position = "fixed"; width = height = "100%"; }
	
	if(isIE6){
		this.Lay.style.position = "absolute";
		//ie6设置覆盖层大小程序
		this._resize = Bind(this, function(){
			this.Lay.style.width = Math.max(document.documentElement.scrollWidth, document.documentElement.clientWidth) + "px";
			this.Lay.style.height = Math.max(document.documentElement.scrollHeight, document.documentElement.clientHeight) + "px";
		});
		//遮盖select
		this.Lay.innerHTML = '<iframe style="position:absolute;top:0;left:0;width:100%;height:100%;filter:alpha(opacity=0);"></iframe>'
	}
  },
  //设置默认属性
  SetOptions: function(options) {
    this.options = {//默认值
		Lay:		null,//覆盖层对象
		Color:		"#000",//背景色
		Opacity:	10,//透明度(0-100)
		zIndex:		1000//层叠顺序
    };
    Extend(this.options, options || {});
  },
  //显示
  Show: function() {
	//兼容ie6
	if(isIE6){ this._resize(); window.attachEvent("onresize", this._resize); }
	//设置样式
	with(this.Lay.style){
		//设置透明度
		isIE ? filter = "alpha(opacity:" + this.Opacity + ")" : opacity = this.Opacity / 100;
		backgroundColor = this.Color; display = "block";
	}
  },
  //关闭
  Close: function() {
	this.Lay.style.display = "none";
	if(isIE6){ window.detachEvent("onresize", this._resize); }
  }
};



var LightBox = Class.create();
LightBox.prototype = {
  initialize: function(box, options) {
	
	this.Box = daole(box);//显示层
	
	this.OverLay = new OverLay(options);//覆盖层
	
	this.SetOptions(options);
	
	this.Fixed = !!this.options.Fixed;
	this.Over = !!this.options.Over;
	this.Center = !!this.options.Center;
	this.onShow = this.options.onShow;
	
	this.Box.style.zIndex = this.OverLay.zIndex + 1;
	this.Box.style.display = "none";
	
	//兼容ie6用的属性
	if(isIE6){
		this._top = this._left = 0; this._select = [];
		this._fixed = Bind(this, function(){ this.Center ? this.SetCenter() : this.SetFixed(); });
	}
  },
  //设置默认属性
  SetOptions: function(options) {
    this.options = {//默认值
		Over:	true,//是否显示覆盖层
		Fixed:	false,//是否固定定位
		Center:	false,//是否居中
		onShow:	function(){}//显示时执行
	};
    Extend(this.options, options || {});
  },
  //兼容ie6的固定定位程序
  SetFixed: function(){
	this.Box.style.top = document.documentElement.scrollTop - this._top + this.Box.offsetTop + "px";
	this.Box.style.left = document.documentElement.scrollLeft - this._left + this.Box.offsetLeft + "px";
	
	this._top = document.documentElement.scrollTop; this._left = document.documentElement.scrollLeft;
  },
  //兼容ie6的居中定位程序
  SetCenter: function(){
	this.Box.style.marginTop = document.documentElement.scrollTop - this.Box.offsetHeight / 2 + "px";
	this.Box.style.marginLeft = document.documentElement.scrollLeft - this.Box.offsetWidth / 2 + "px";
  },
  //显示
  Show: function(options) {
	//固定定位
	this.Box.style.position = this.Fixed && !isIE6 ? "fixed" : "absolute";

	//覆盖层
	this.Over && this.OverLay.Show();
	
	this.Box.style.display = "block";
	
	//居中
	if(this.Center){
		this.Box.style.top = this.Box.style.left = "50%";
		//设置margin
		if(this.Fixed){
			this.Box.style.marginTop = - this.Box.offsetHeight / 2 + "px";
			this.Box.style.marginLeft = - this.Box.offsetWidth / 2 + "px";
		}else{
			this.SetCenter();
		}
	}
	
	//兼容ie6
	if(isIE6){
		if(!this.Over){
			//没有覆盖层ie6需要把不在Box上的select隐藏
			this._select.length = 0;
			Each(document.getElementsByTagName("select"), Bind(this, function(o){
				if(!Contains(this.Box, o)){ o.style.visibility = "hidden"; this._select.push(o); }
			}))
		}
		//设置显示位置
		this.Center ? this.SetCenter() : this.Fixed && this.SetFixed();
		//设置定位
		this.Fixed && window.attachEvent("onscroll", this._fixed);
	}
	
	this.onShow();
  },
  //关闭
  Close: function() {
	this.Box.style.display = "none";
	this.OverLay.Close();
	if(isIE6){
		window.detachEvent("onscroll", this._fixed);
		Each(this._select, function(o){ o.style.visibility = "visible"; });
	}
  }
};

</script>
<style>
.lightbox{width:320px;border:1px solid #ccc;line-height:25px;left:40%; height:150px;}
</style>
<!--取消关注提示-->
<div class="popup_cart lightbox" id="idBox" >
  <div class="pop_cart_tishi"><strong>提示</strong><a  id="idBoxCancel"><img src="${base}/styles/images/popup_close.png" height="7" width="7" alt="关闭" /></a></div>
  <div class="pop_cart_body">
    <p class="note">您确定取消关注该商品吗？</p>
    <br />
    <p><a class="btn btn-size25 queding">确定</a><span class="none"></span><a class="btn btn-size25 quxiao">取消</a></p>
  </div>
</div>
<!--取消关注提示--> 
<script>
	var box = new LightBox("idBox");
	//定位效果
	box.Fixed = true;
	//居中效果
	box.Box.style.top = "25%";
	box.Box.style.marginTop = box.Box.style.marginLeft = "0";
	
	daole("idBoxCancel").onclick = function(){ box.Close(); }
	$("a.quxiao").bind("click",function(){ box.Close(); });
	function myConfirm(note,funk){
		$("p.note").html(note);
		box.Show();
		$("a.queding").unbind("click"); 
		$("a.queding").bind("click",funk);
	}
</script>

<!--取消关注提示-->
<div class="popup_cart lightbox" id="alertBox" >
  <div class="pop_cart_tishi"><strong>提示</strong><a  id="alertBoxCancel"><img src="${base}/styles/images/popup_close.png" height="7" width="7" alt="关闭" /></a></div>
  <div class="pop_cart_body">
    <p class="alert"></p>
    <br />
    <p><a class="btn btn-size25 alert">确定</a></p>
  </div>
</div>
<!--取消关注提示--> 
<script>
	var alertBox = new LightBox("alertBox");
	//定位效果
	alertBox.Fixed = true;
	//居中效果
	alertBox.Box.style.top = "25%";
	alertBox.Box.style.marginTop = box.Box.style.marginLeft = "0";
	
	daole("alertBoxCancel").onclick = function(){ alertBox.Close(); }
	function myAlert(note){
		$("p.alert").html(note);
		alertBox.Show();
		$("a.alert").unbind("click"); 
		$("a.alert").bind("click",function(){ alertBox.Close(); });
	}
</script>

<!-- 物流信息div -->
<div id="logist_infor" class="comPoP_infor" style="display:none;">
  <div class="comPoP_head">
    <p class="left">订单跟踪</p>
    <a class="right"><img width="9" height="9" alt="关闭" src="${base}/styles/images/popup_close.png"></a>
  </div>
  <div class="comPoP_body">
  
  
  </div>
</div>
<!-- 物流信息div -->
<script>
	var logistInfor = new LightBox("logist_infor");
	//打开遮罩层
	logistInfor.Over = true;
	//定位效果
	logistInfor.Fixed = true;
	//居中效果
	logistInfor.Box.style.left = box.Box.style.top = "25%";
	logistInfor.Box.style.marginTop = box.Box.style.marginLeft = "0";
</script>

<!-- 投诉建议 - 顾客投诉 -->
<div class="comPoP_infor" id="complaint_infor">
  <div class="comPoP_head">
    <p class="left">我的投诉</p>
    <a class="right"><img width="9" height="9" src="${base}/styles/images/popup_close.png" alt="关闭"></a></div>
  <div class="comPoP_body">
  	<input type="hidden" name="userType" value="C" />
    <p class="com_tit">我的投诉：如果您对商品的价格、质量和性能存在质疑，请随时告知我们！</p>
    <div class="com_pre"><b>我的竞价：</b> <span>
      <input name="purPrice" type="text" class="com_int"/>
      </span></div>
    <div class="com_pre"><b>进货渠道：</b> <span>
      <input name="vendorChannel" type="text" class="com_int" />
      </span></div>
    <div class="com_pre"><b>投诉建议：</b> <span>
      <textarea class="com_text"></textarea>
      </span></div>
    <p style="padding-left:70px;" class="line_height_30 color_2">还可以输入<span class="color_1 maxLimit"></span>字</p>
    <p style="padding-left:70px;"><a class="btn btn-red btn-size25 mright doComplaint">我要投诉</a><a class="btn btn-red btn-size25 close">关闭</a></p>
  </div>
</div>

<!-- 投诉建议 - 顾客投诉 -->
<script>
	var complaintInfor = new LightBox("complaint_infor");
	//打开遮罩层
	complaintInfor.Over = true;
	//定位效果
	complaintInfor.Fixed = true;
	//居中效果
	complaintInfor.Box.style.left = box.Box.style.top = "25%";
	complaintInfor.Box.style.marginTop = box.Box.style.marginLeft = "0";
</script>

<!-- 订单打印格式选项弹出层-->
<div class="comPoP_infor" id="printInfo">
  <div class="comPoP_head">
    <p class="left">打印设置</p>
    <a class="right"><img width="9" height="9" src="${base}/styles/images/popup_close.png" alt="关闭"></a></div>
  <div class="comPoP_body">
    <h4 class="com_tit">请根据您的打印机的纸张大小，设置您需要的打印样式！</h4>
    <div class="control-label">常用参数： 
    	<span>
      		<select>
      			<option value="297mm">A4</option>
      			<option value="139.5mm">1/2 x A4</option>
      			<option value="91.0mm">1/3 x A4</option>
      		<select>
      	</span>
    </div>
    <p class="btn_boxa">
    	<a class="btn btn-red btn-size25 mright confirm">确定</a>
    </p>
  </div>
</div>

<!--订单打印格式选项弹出层 -->
<script>
	var printInfo = new LightBox("printInfo");
	//打开遮罩层
	printInfo.Over = true;
	//定位效果
	printInfo.Fixed = true;
	//居中效果
	printInfo.Box.style.left = box.Box.style.top = "15%";
	printInfo.Box.style.marginTop = box.Box.style.marginLeft = "1";
</script>
