/** @jsx React.DOM */

var ErrorAlertItem = React.createClass({
    render: function() {
        console.log(this.props.message);
        return (
            // React.DOM.li(null, this.props.message)
            <li> { this.props.message } </li>
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
            //React.DOM.ul(null, errors)
            <ul>
                 { errors }
             </ul>
        );
    }
});

// a successs alert
var SuccessAlert = React.createClass({
    render: function() {
        return( React.DOM.div(null, this.props.message));
    }
});
