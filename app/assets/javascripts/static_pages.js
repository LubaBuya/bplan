function setupHandlers() {
    $('.bigEvent').unbind();

    $('.bigEvent').click(function(e) {
        var offset = $(this).offset();
        console.log(e);
        console.log(offset);
        var x = $(this).width() + offset.left - e.pageX;
        var y = e.pageY - offset.top;

        console.log("x:" + x + "  y:" + y);
        
        if(!(y < 40 && x < 70)) {
            $(this).find('.desc').toggleClass('ellipsis');
        }
    });

    $('.bigEvent').hover(
        function() {
            $(this).find('.linkIcon').removeClass('Hidden');
        },
        function() {
            $(this).find('.linkIcon').addClass('Hidden');
        }
    );

    $('.emailLink').unbind();
    $('.emailLink').click(function(e) {
        
        $(e.target).removeClass('emailLink');
        $(e.target).addClass('emailLinkChosen');

        
    });
}

$(document).ready(function() {
    if ($('.bigEvent').length == 0) {
        return;
    }
    
    setupHandlers();
    
    var wait = false;
    
    $(window).unbind();
    $(window).scroll(function() {
        if(page === null) {
            page = urlParams.page == undefined ? '1' : urlParams.page;
            page = parseInt(page);
        }

        if(isBottomVisible($('#upcomingList'))) {
            if(wait) {
                return;
            }
            
            page += 1;
            wait = true;
            
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

    return (elemBottom <= docViewBottom + 100);
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

var page = null;


