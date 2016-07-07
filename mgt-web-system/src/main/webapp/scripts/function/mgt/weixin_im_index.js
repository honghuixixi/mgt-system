var checked="";
$(function(){
    // 弹框
	$(".select_list_box li").on("click",function(){		
		$(".md-modal").addClass("md-show");
		$(".mask").show();
		checked=$(this).attr("id");
	});
	$(".mask,#modal_close").on("click",function(ev){
		$(".md-modal").removeClass("md-show");
		$(".mask").hide();
	});
    /**下拉加载**/
    $(document).ready(function () {
      $(window).scroll(function () {
          var $body = $("body");
          if (($(window).height() + $(window).scrollTop()) >= $body.height()) {
              $("#page_tag_load").show();
              insertcode();
          }
      });
    });
    function insertcode() {
        $.ajax({
              type: 'POST',
              url: 'http://www.baidu.com',
              data: {},
              success: function(data){
                
                $('#page_tag_load').hide();
              }
        });        
    }
})