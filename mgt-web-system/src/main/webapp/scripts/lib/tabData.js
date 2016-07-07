// JavaScript Document
var cache = 0;
function tabHeight(aDynamicH){
	var aaa = $(".main_heightBox1").height();
	var bbb = $(window).height();
	var ccc = bbb-aaa-80;
	var ddd = bbb-40-38;
	$(".ui-jqgrid-bdiv").css("height",ccc);
	$(".aaab").css("height",ddd);
	$(".ui-jqgrid-hdiv").css("padding-right","17px");
	if( cache <= aDynamicH ){
		$(".ui-jqgrid-hdiv").css("padding-right","0");
		$(".aaab").css("width","193px");
	}else{
		$(".ui-jqgrid-hdiv").css("padding-right","17px");
		$(".aaab").css("width","176px");
	}
	
}
$(window).resize(function() {
    tabHeight($(".ui-jqgrid-bdiv").height());
});

$(window).scroll(function() {
    tabHeight($(".ui-jqgrid-bdiv").height());
})
$(window).click(function() {
    tabHeight($(".ui-jqgrid-bdiv").height());
})

