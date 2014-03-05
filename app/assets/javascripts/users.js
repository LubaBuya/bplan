// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.

//= require signup

$(document).ready(function() {

    $('#userSignupForm').find("input").keyup(function(event) {
        if(event.keyCode == 13) {
            $("#joinButton").click();
            setTimeout(function() { event.target.focus(); },
                       200);
        }
    });

    $('#userLoginForm').find("input").keyup(function(event) {
        if(event.keyCode == 13) {
            $("#loginButton").click();
            setTimeout(function() { event.target.focus(); },
                       200);
        }
    });


    $('.GroupBox').ready(function() {

        $('.GroupBox').find('input[type=checkbox]').prop('disabled', true);
        
        $.ajax({
            url: '/user_groups',
            type: 'GET',
            dataType: 'JSON',
            success: function(data) {
                console.log(data);
                for(var i=0; i<data.groups.length; i += 1) {
                    console.log('#group' + data[i]);
                    $('#group' + data.groups[i]).find('input[type=checkbox]').prop('checked', true);
                }

                $('.GroupBox').find('input[type=checkbox]').prop('disabled', false);
                
            }

        });

    });
    
});

