var ErrorAlertItem = React.createClass({
    render: function() {
        console.log(this.props.message);
        return (
            React.DOM.li(null, this.props.message)
            // <li> { this.props.message } </li>
        );
    }
});

var ErrorAlert = React.createClass({
    render: function() {
        var errors = this.props.errors.map(function(e) {
            return ErrorAlertItem({message: e});
        });

        console.log(errors);
        
        return (
            React.DOM.ul(null, errors)
            // <ul>
            //     { errors }
            // </ul>
        );
    }
});

var SuccessAlert = React.createClass({
    render: function() {
        return( React.DOM.div(null, this.props.message));
    }
});


// for logging in
$(document).ready(function() {
    $('body').on('click', '#loginButton', function(event) {
        event.preventDefault();
        form = $(this).closest('.Login').find('#userLoginForm');
        console.log(form); //debugging
        handle_signup_form(form, "/login", function(data) {
            window.location.replace('/');
        });
    });

    $('body').on('click', '#joinButton', function(event) {
        event.preventDefault();
        form = $(this).closest('.Signup').find('#userSignupForm');
        console.log(form); //debugging
        handle_signup_form(form, "/users", function(data) {
            window.location.replace('/');
        });
    });

    $('body').on('click', '#saveGroups', function(event) {
        event.preventDefault();
        form = $(this).closest('.GroupBox').find('#updateGroupsForm');
        console.log(form); //debugging
        handle_signup_form(form, "/subscriptions", function(data) {
            $('#formSuccess').removeClass("Hidden");
            $('#formError').addClass("Hidden");
            React.renderComponent (
                SuccessAlert({message: 'Success! We have updated your subscriptions.'}),
                document.getElementById('formSuccess')
            );
        });
    });
});

var request = false;

function handle_signup_form(form, url, successHandler) {

    // #abort any pending request
    if (request) {
        request.abort();
    }

    // # setup some local variables
    // # let's select and cache all the fields
    var inputs = form.find("input, select, button, textarea");
    // # serialize the data in the form
    var serializedData = form.serialize();
    console.log('Serialized: ' + serializedData);

    // # let's disable the inputs for the duration of the ajax request
    inputs.prop("disabled", true);

    $('#formSuccess').addClass("Hidden");
    $('#formError').addClass("Hidden");


    // # fire off the request to url
    request = $.ajax({
        url: url,
        type: "POST",
        data: serializedData,
        datatype: "JSON",
        success: function(data) {
            console.log(data);
            
            if(data.success) {
                successHandler(data);
            } else {
                $('#formSuccess').addClass("Hidden");
                $('#formError').removeClass("Hidden");
                React.renderComponent (
                    ErrorAlert({errors: data.errors}),
                    document.getElementById('formError')
                );
            }
        }
    });

    // # callback handler that will be called on failure
    request.fail(function (jqXHR, textStatus, errorThrown){
        // # log the error to the console
        console.error(
            "The following error occured: " +
                textStatus, errorThrown
        );
    });

    // # callback handler that will be called regardless
    // # if the request failed or succeeded
    request.always(function () {
        // # reenable the inputs
        inputs.prop("disabled", false);
    });

}
