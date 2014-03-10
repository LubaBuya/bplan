// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.

//= require signup

$(document).ready(function() {

    $('#userSignupForm').find("input").keyup(function(event) {
        if(event.keyCode == 13) {

            var id = event.target.id;

            if(id == "user_name") {
                $("#user_email").focus();
            } else if(id == "user_email") {
                $("#user_password").focus();
            } else if(id == "user_password") {
                $("#user_password_confirmation").focus();
            } else if(id == "user_password_confirmation") {
                $("#joinButton").click();
                setTimeout(function() { event.target.focus(); },
                           200);
            }
        }
    });

    $('#userLoginForm').find("input").keyup(function(event) {
        if(event.keyCode == 13) {

            var id = event.target.id;

            if(id == "user_email") {
                $("#user_password").focus();
            } else if(id == "user_password") {
                $("#loginButton").click();
                setTimeout(function() { event.target.focus(); },
                           200);
            }
        }
    });


    $('.GroupBox').ready(function() {

        var g = $('.GroupBox');

        if(g.length == 0) {
            return;
        }
        
        g.find('input[type=checkbox]').prop('disabled', true);
        g.find('select').prop('disabled', true);
        
        $.ajax({
            url: '/user_groups',
            type: 'GET',
            dataType: 'JSON',
            success: function(data) {
                for(var i=0; i<data.groups.length; i += 1) {
                    $('#group' + data.groups[i]).find('input[type=checkbox]').prop('checked', true);
                }

                console.log(data.remind_email);

                g.find('#reminders_email').val(data.remind_email);
                g.find('#reminders_sms').val(data.remind_sms);

                g.find('input[type=checkbox]').prop('disabled', false);
                g.find('select').prop('disabled', false);
            }

        });


    });

    $('#sendTestSMS').unbind();
    $('#sendTestSMS').click(function() {
        $('#formSuccess').html("Sent a test SMS. Check your phone!");
        
        $('#formSuccess').removeClass("Hidden");
        $('#formError').addClass("Hidden");
    });

    $('#sendTestEmail').unbind();
    $('#sendTestEmail').click(function() {
        $('#formSuccess').html("Sent a test email. Check your email!");
        
        $('#formSuccess').removeClass("Hidden");
        $('#formError').addClass("Hidden");
    });


    $('#allGroups').unbind();
    $('#allGroups').click(function() {
        $('input[type=checkbox]').prop('checked', true);
    });

    $('#noGroups').unbind();
    $('#noGroups').click(function() {
        $('input[type=checkbox]').prop('checked', false);
    });

});

