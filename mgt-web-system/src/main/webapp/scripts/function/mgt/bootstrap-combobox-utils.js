Yhxutil.ns("Yhxutil.combobox");
/**
* 初始化动态combobox
**/
Yhxutil.combobox.doInit = function (params){
	$.ajax({
		type: "POST",
		url:  params.url,
		data: params.data,
		success: function(response){
			var obj = jQuery.parseJSON(response);
			var re = obj.data;
			var option="";
			for(var i in re){
			   option +=  "<option value ='"+re[i].code+"' >"+re[i].name+"</option>";
			}
			$(params.id).append(option);
		    $(params.id).combobox();
	   }
	});
};