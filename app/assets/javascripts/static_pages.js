$(document).ready(function() {
    $('.bigEvent').unbind();
    $('.bigEvent').click(function() {
        $(this).find('.desc').toggleClass('ellipsis');
    });

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
                $('.bigEvent').unbind('click');
                $('.bigEvent').click(function() {
                    $(this).find('.desc').toggleClass('ellipsis');
                });
                wait = false;
            });
        }

    });
});

function isBottomVisible(elem)
{
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


