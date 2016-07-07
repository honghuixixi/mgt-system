$(function() {
    // 点击标题排序
    $('table thead th a.sort').on('click', function() {
        var self = $(this);
        var i_class = $('i', self).attr('class');
        $('table thead th a.sort i').removeClass('icon-caret-up').removeClass('icon-caret-down');

        if (i_class == 'icon-caret-down') {
            $('i', self).removeClass('icon-caret-down').addClass('icon-caret-up');
        }
        else {
            $('i', self).removeClass('icon-caret-up').addClass('icon-caret-down');
        }
        return false;
    })

    // table行选中
    $('body').on('click', '.table-single > tbody > tr',function() {
        var self_tr = $(this);
        if (self_tr.hasClass('selected_tr')) {
            self_tr.removeClass('selected_tr');
            return;
        }

        self_tr.parent().find('tr').removeClass('selected_tr');
        self_tr.addClass('selected_tr');
    })

    $('body').on('click','.table-double > tbody > tr', function() {
        var self_tr = $(this);
        if (self_tr.hasClass('selected_tr')) {
            self_tr.removeClass('selected_tr');
            return;
        }
        self_tr.addClass('selected_tr');
    })
    
    //移除table的一行
    $('body').on('click', '.remove_tr', function(){
        $(this).parent().parent().remove();
    });
    
    //表格查询条件显示隐藏
    $(".open_btn").click(function(){
    	if($(".form_divBox").hasClass('open_form')){
    		$(".form_divBox").removeClass("open_form");
    	}else{
    		$(".form_divBox").addClass("open_form");
    	}
    });
	
	//点击三角金额汇总显示关闭
	$(".orderCount-IconBtn").click(function(){
			if($(this).hasClass('cur')){
				$(this).removeClass("cur");
				$(".pos_orderCount").animate({width:'100%',padding:'0 0 0 25px'},1000);
			}else{
				$(this).addClass("cur");
				$(".pos_orderCount").animate({width:'0',padding:'0'},1000);
			}
	});
})