$(function() {
    // 初始化 mainIframe 高度
    var init_h = function() {
    	var mainHeightBox = $(".main_heightBox1").height();
    	var absd = $(".ui-jqgrid-hdiv").height() 
        var body_h = $(window).height() - 97;
        $('.menu-wrap').height(body_h);
        $('.main-wrap').height(body_h+2);
        $('#mainIframe').height(body_h-29);
        $(".ui-jqgrid-bdiv").height(body_h-29)
        var current_meeting_name = $.cookie('meeting_name');
        if(!(current_meeting_name == null || current_meeting_name == "" || typeof(current_meeting_name) == "undefined")){        	
        	$('.cmt').html('<i class="icon-group"></i>'+current_meeting_name);
        }
    }

    $(window).resize(function() {
        init_h();
    });

    $(window).scroll(function() {
        init_h();
    })

    init_h();

    // 菜单选择
    $('.menu-wrap dt').click(function() {
        var self = $(this);        

        // 获取一级菜单是否有url
        var first_url = self.find('a').attr('href');
        if (first_url) {
            $('#mainIframe').attr('src', first_url);
        }
        
        if (self.hasClass('disabled')) {
            return false;
        }
        
        if (self.closest('dl').hasClass('active')) {
            self.closest('dl').find('dd').slideUp(function() {
                $(this).find('a.active').removeClass('active');
                self.closest('dl').removeClass('active');
                init_h();
            })
        } else if ($('.menu-wrap dl.active').length > 0) {
            $('.menu-wrap dl.active').find('dd').hide();
            $('.menu-wrap dl').removeClass('active');
            self.closest('dl').addClass('active');

            self.closest('dl').find('dd').slideDown(function() {
                if (!first_url) {
                    self.closest('dl').find('dd:first a')[0].click();
                }
                init_h();
            });
        } else {
            self.closest('dl').addClass('active').slideDown();
            self.closest('dl').find('dd').slideDown(function() {
                if (!first_url) {
                    self.closest('dl').find('dd:first a')[0].click();
                }
                init_h();
            });
        }
        return false;
    })

    // 菜单子项点击事件
    $('.menu-wrap dd a').click(function() {
        var self = $(this);
        $('.menu-wrap dd a').removeClass('active');
        self.addClass('active');
        return true;
    })
})