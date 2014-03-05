$(document).ready(function() {
    $('.bigEvent').click(function() {
        $(this).find('.desc').toggleClass('ellipsis');
    });
});