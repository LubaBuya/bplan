function setupHandlers() {
    $('.bigEvent').unbind();

    $('.bigEvent').click(function(e) {
        var offset = $(this).offset();

        var x = $(this).width() + offset.left - e.pageX;
        var y = e.pageY - offset.top;
        
        if(!(y < 40 && x < 70)) {
            $(this).find('.desc').toggleClass('ellipsis');
            
            $(this).find('.descShort').toggleClass('Hidden');
            $(this).find('.descLong').toggleClass('Hidden');
            
            $(this).find('.linkIcon').removeClass('Hidden');
        }
    });

    $('.bigEvent').hover(
        function() {
            $(this).find('.linkIcon').removeClass('Hidden');
        },
        function() {
            if($(this).find('.desc').length == 0 ||
               $(this).find('.desc').hasClass('ellipsis')) {
                $(this).find('.linkIcon').addClass('Hidden');
            }
        }
    );

    var favs_url = '/update_favs';

    function make_click_func(name, force_set, success) {
        function f(e) {
            var clicked = $(this);
            var event = clicked.closest('.bigEvent');
            var event_ids = event.data('ids');
            var set = event.data(name);
            set = !set;

            if(force_set) {
                set = true;
            }

            console.log(set);
            
            $.ajax({
                url: favs_url,
                type: 'POST',
                data: { type: name, event_ids: event_ids, set: set },
                datatype: "JSON",
                success: function(data) {
                    if(set) {
                        $(e.target).removeClass(name + 'Link');
                        $(e.target).addClass(name + 'LinkChosen');
                        event.data(name, true);
                        if(!(success === undefined)) {
                            success(clicked);
                        }
                    } else {
                        $(e.target).removeClass(name + 'LinkChosen');
                        $(e.target).addClass(name + 'Link');
                        event.data(name, false);
                    }
                }
            });
        }

        return f;
    }
    
    $('.emailLink').unbind();
    $('.emailLink, .emailLinkChosen').click(make_click_func('email'));

    $('.smsLink, .smsLinkChosen').unbind();
    $('.smsLink, .smsLinkChosen').click(make_click_func('sms'));

    // $('.gcalLink, .gcalLinkChosen').unbind();
    // $('.gcalLink, .gcalLinkChosen').click(
    //     make_click_func('gcal', true, function(clicked) {
    //         window.location = clicked.data('link');
    //     }));

}

$(document).ready(function() {
    if ($('.bigEvent').length == 0) {
        return;
    }
    
    setupHandlers();


    // from http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
    var urlParams;
    (window.onpopstate = function () {
        var match,
        pl     = /\+/g,  // Regex for replacing addition symbol with a space
        search = /([^&=]+)=?([^&]*)/g,
        decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
        query  = window.location.search.substring(1);

        urlParams = {};
        while (match = search.exec(query))
            urlParams[decode(match[1])] = decode(match[2]);
    })();

    var wait = false;
    var page = null;
    // page = urlParams.page == undefined ? '1' : urlParams.page;
    // page = parseInt(page);
    page = 1;
    
    $(window).unbind();
    $(window).scroll(function() {
        if(isBottomVisible($('#upcomingList'))) {
            if(wait) {
                return;
            }
            
            wait = true;
            page += 1;
            
            $('#loadingDiv').load('/?page=' + page + ' #upcomingList', function() {
                $('#upcomingList').append(
                    $('#loadingDiv').find('#upcomingList').html());

                setupHandlers();
                
                wait = false;
            });
        }

    });
});

function isBottomVisible(elem) {
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return (elemBottom <= docViewBottom + 200);
}





