function setupHandlers() {
    $('.bigEvent').unbind();

    $('.descShort').unbind();
    $('.hideDesc').unbind();
    
    $('.descShort').click(function(e) {
        var event = $(this).closest('.bigEvent');
        var offset = event.offset();

        var x = event.width() + offset.left - e.pageX;
        var y = e.pageY - offset.top;
        
        if(!(y < 40 && x < 70)) {
            event.find('.desc').removeClass('ellipsis');
            
            // event.find('.descShort').toggleClass('Hidden');
            // event.find('.descLong').toggleClass('Hidden');

            event.find('.descLong').slideDown({start: function() {
                event.find('.descLong').removeClass("Hidden");
            }});
            
            event.find('.descShort').addClass("Hidden");

            
            event.find('.linkIcon').removeClass('Hidden');
        }
    });

    $('.hideDesc').click(function(e) {
        var event = $(this).closest('.bigEvent');
        var offset = event.offset();

        var x = event.width() + offset.left - e.pageX;
        var y = e.pageY - offset.top;
        
        if(!(y < 40 && x < 70)) {
            
            // event.find('.descShort').toggleClass('Hidden');
            // event.find('.descLong').toggleClass('Hidden');

            event.find('.descLong').first().slideUp({
                progress: function(anim, progress, remaining) {
                    if(remaining < 90) {
                        event.find('.descShort').removeClass("Hidden");
                        event.find('.desc').addClass('ellipsis');
                        event.find('.descLong').addClass("Hidden");
                    }
                },
                complete: function() {
                    event.find('.descLong').addClass("Hidden");
                    event.find('.desc').addClass('ellipsis');
                }});
            
            
            event.find('.linkIcon').removeClass('Hidden');
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

var e1 = {
    title: 'Hello World',
    color: "#2A4973",
    groups: 'EECS / Neuroscience',
    page: '/events/1000',
    date_range: 'Now - Never',
    location: 'Somewhere',
    descShort: 'Short short short',
    descLong: '<p>Long long long</p>'
};

var e2 = {
    title: 'Another world!',
    color: "#742A4F",
    groups: 'Statistics',
    page: '/events/100',
    date_range: 'Now - Sometime',
    location: 'Here',
    descShort: 'Short short short 222',
    descLong: '<p>Long long long</p>'
};

var el = EventList({});

$(document).ready(function() {
    if ($('.bigEvent').length == 0) {
        return;
    }
    

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


    
    
    React.renderComponent(el, $('#today')[0]);

    el.setState({events: [e1, e2]});

    setupHandlers();
});

function isBottomVisible(elem) {
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return (elemBottom <= docViewBottom + 200);
}





