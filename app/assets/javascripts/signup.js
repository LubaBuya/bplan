// 
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
        // mapping each error into ErrorAlertItem which returns a li of the prop messages
        var errors = this.props.errors.map(function(e) {
            return ErrorAlertItem({message: e});
        });

        console.log(errors);
        // returning a list heirarchy of erros
        return (
            React.DOM.ul(null, errors)
            // <ul>
            //     { errors }
            // </ul>
        );
    }
});

// a successs alert
var SuccessAlert = React.createClass({
    render: function() {
        return( React.DOM.div(null, this.props.message));
    }
});


// for logging in
$(document).ready(function() {
    // .on -- event is click for login button, function is what to run when this event occurs
    $('body').on('click', '#loginButton', function(event) {
        event.preventDefault(); // prevent default behavior
        form = $(this).closest('.Login').find('#userLoginForm'); // grab entire form
        console.log(form); //debugging
        handle_signup_form(form, "/login", function(data) {
            window.location.replace('/'); // go back to root after logging in
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

// this method is called when we click the button submit
function handle_signup_form(form, url, successHandler) {

    // #abort any pending request
    if (request) {
        request.abort();
    }

    // # setup some local variables
    // # selecting all elements in the form
    var inputs = form.find("input, select, button, textarea");
    // # serialize the data in the form - logging data to the console
    var serializedData = form.serialize();
    console.log('Serialized: ' + serializedData);

    // # let's disable the inputs for the duration of the ajax request
    inputs.prop("disabled", true);

    $('#formSuccess').addClass("Hidden");
    $('#formError').addClass("Hidden");

    // # submitting a post request to url which calls a method in rails controller
    request = $.ajax({
        url: url,
        type: "POST",
        data: serializedData, // submitting the data
        datatype: "JSON",
        success: function(data) { // what is data here?
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
