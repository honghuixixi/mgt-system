//初始化
Yhxutil.ns("Yhxutil.role");
Yhxutil.role.doInit = function(params){
	$.ajax({
		   type: "POST",		   
		   url:  params.url,
		   data: params.data,
		   async:false,
		   scope:this,
		   success: Yhxutil.role.doSuccess
		});
}
Yhxutil.role.doSuccess = function(response){
	//拼接角色数据
	var obj = jQuery.parseJSON(response)
    var re = obj.data;
    var option="";
    var option1="";
	for(var i in re.left)
	   {
	   option +=  "<option value ='"+re.left[i].id+"' >"+re.left[i].name+"</option>"
	   }
	for(var i in re.right)
	   {
	   option +=  "<option value ='"+re.right[i].id+"' >"+re.right[i].name+"</option>"
	   }
    $('#select1').append(option);
	$('#select2').append(option1);
}


$(function(){
    //移到右边
    $('#add').click(function() {
        //获取选中的选项，删除并追加给对方
        var leftValue = $('#select1 option:selected');
        var rightValue = $('#select2 option');
        var leftLength = leftValue.length;
        var rightLength = rightValue.length;
        for(var i =0 ;i<leftLength;i++)
            {
                 var lcode = leftValue[i].value
                 var ltext = leftValue[i].text;
                 var flag = true;
                 for(var j=0;j<rightLength;j++)
                  {
                   var rcode = rightValue[j].value;
                   var rtext = rightValue[j].text;
                    if(lcode == rcode)
                    {
                  	flag = false;
                    }
                  }
                 if(flag)
                    {
                	 $('#select2').append("<option value = '"+lcode+"'>"+ltext+"</option>");
               	     $("#select1 option[value="+lcode+"]").remove();
                    }
            }
        var endValue = $('#select2 option');
        var endLength = endValue.length;
        var endParan ="";
        for(var i =0;i<endLength;i++)
        {
        	endParan+=endValue[i].value
        	if(i<(endLength-1))
        	{
        		endParan+=",";
        	}
        }
        $("#id").attr("value","");
        $("#id").attr("value",endParan);
        
    });
    //移到左边
    $('#remove').click(function() {
        var rightValue = $('#select2 option:selected');
        var leftValue = $('#select1 option');
        var leftLength = leftValue.length;
        var rightLength = rightValue.length;
        for(var i =0 ;i<rightLength;i++)
            {
                 var rcode = rightValue[i].value
                 var rtext = rightValue[i].text;
                 var flag = true;
                 for(var j=0;j<leftLength;j++)
                  {
                   var lcode = leftValue[j].value;
                   var ltext = leftValue[j].text;
                    if(rcode == lcode)
                    {
                  	flag = false;
                    }
                  }
                 if(flag)
                    {
               	 $('#select1').append("<option value = '"+rcode+"'>"+rtext+"</option>");
               	 $("#select2 option[value="+rcode+"]").remove();
                    }
            }
        
        var endValue = $('#select2 option');
        var endLength = endValue.length;
        var endParan ="";
        for(var i =0;i<endLength;i++)
        {
        	endParan+=endValue[i].value
        	if(i<(endLength-1))
        	{
        		endParan+=",";
        	}
        }
        $("#id").attr("value","");
        
        
    });
    //全部移到右边
    $('#add_all').click(function() {
        //获取全部的选项,删除并追加给对方
        var leftValue = $('#select1 option');
        var rightValue = $('#select2 option');
        var leftLength = leftValue.length;
        var rightLength = rightValue.length;
        for(var i =0 ;i<leftLength;i++)
            {
                 var lcode = leftValue[i].value
                 var ltext = leftValue[i].text;
                 var flag = true;
                 for(var j=0;j<rightLength;j++)
                  {
                   var rcode = rightValue[j].value;
                   var rtext = rightValue[j].text;
                    if(lcode == rcode)
                    {
                  	flag = false;
                    }
                  }
                 if(flag)
                    {
                	 $('#select2').append("<option value = '"+lcode+"'>"+ltext+"</option>");
               	     $("#select1 option[value="+lcode+"]").remove();
                    }
            }
        var endValue = $('#select2 option');
        var endLength = endValue.length;
        var endParan ="";
        for(var i =0;i<endLength;i++)
        {
        	endParan+=endValue[i].value
        	if(i<(endLength-1))
        	{
        		endParan+=",";
        	}
        }
        $("#id").attr("value","");
        $("#id").attr("value",endParan);
    });
    //全部移到左边
    $('#remove_all').click(function() {
        var rightValue = $('#select2 option');
        var leftValue = $('#select1 option');
        var leftLength = leftValue.length;
        var rightLength = rightValue.length;
        for(var i =0 ;i<rightLength;i++)
            {
                 var rcode = rightValue[i].value
                 var rtext = rightValue[i].text;
                 var flag = true;
                 for(var j=0;j<leftLength;j++)
                  {
                   var lcode = leftValue[j].value;
                   var ltext = leftValue[j].text;
                    if(rcode == lcode)
                    {
                  	flag = false;
                    }
                  }
                 if(flag)
                    {
               	 $('#select1').append("<option value = '"+rcode+"'>"+rtext+"</option>");
               	 $("#select2 option[value="+rcode+"]").remove();
                    }
            }
        var endValue = $('#select2 option');
        var endLength = endValue.length;
        var endParan ="";
        for(var i =0;i<endLength;i++)
        {
        	endParan+=endValue[i].value
        	if(i<(endLength-1))
        	{
        		endParan+=",";
        	}
        }
        $("#id").attr("value","");
        $("#id").attr("value",endParan);
    });
    //双击选项
    $('#select1').dblclick(function(){
        var leftValue = $('#select1 option:selected');
        var rightValue = $('#select2 option');
        var leftLength = leftValue.length;
        var rightLength = rightValue.length;
        for(var i =0 ;i<leftLength;i++)
            {
                 var lcode = leftValue[i].value
                 var ltext = leftValue[i].text;
                 var flag = true;
                 for(var j=0;j<rightLength;j++)
                  {
                   var rcode = rightValue[j].value;
                   var rtext = rightValue[j].text;
                    if(lcode == rcode)
                    {
                  	flag = false;
                    }
                  }
                 if(flag)
                    {
                	 $('#select2').append("<option value = '"+lcode+"'>"+ltext+"</option>");
               	     $("#select1 option[value="+lcode+"]").remove();
                    }
            }
        var endValue = $('#select2 option');
        var endLength = endValue.length;
        var endParan ="";
        for(var i =0;i<endLength;i++)
        {
        	endParan+=endValue[i].value
        	if(i<(endLength-1))
        	{
        		endParan+=",";
        	}
        }
        $("#id").attr("value","");
        $("#id").attr("value",endParan);
    });
    //双击选项
    $('#select2').dblclick(function(){
        var rightValue = $('#select2 option:selected');
        var leftValue = $('#select1 option');
        var leftLength = leftValue.length;
        var rightLength = rightValue.length;
        for(var i =0 ;i<rightLength;i++)
            {
                 var rcode = rightValue[i].value
                 var rtext = rightValue[i].text;
                 var flag = true;
                 for(var j=0;j<leftLength;j++)
                  {
                   var lcode = leftValue[j].value;
                   var ltext = leftValue[j].text;
                    if(rcode == lcode)
                    {
                  	flag = false;
                    }
                  }
                 if(flag)
                    {
               	 $('#select1').append("<option value = '"+rcode+"'>"+rtext+"</option>");
               	 $("#select2 option[value="+rcode+"]").remove();
                    }
            }
        var endValue = $('#select2 option');
        var endLength = endValue.length;
        var endParan ="";
        for(var i =0;i<endLength;i++)
        {
        	endParan+=endValue[i].value
        	if(i<(endLength-1))
        	{
        		endParan+=",";
        	}
        }
        $("#id").attr("value","");
        $("#id").attr("value",endParan);
    });

});