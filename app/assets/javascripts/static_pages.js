 // Place all the behaviors and hooks related to the matching controller here.
 // All this logic will automatically be available in application.js.


$(document).ready(function() {
    $('.bigEvent').click(function() {
        $(this).find('.desc').toggleClass('ellipsis');
    });
});
