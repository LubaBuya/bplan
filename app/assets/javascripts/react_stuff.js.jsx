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

        //console.log(errors);
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


var EventList = React.createClass({
    getInitialState: function() {
        return {events: []};
    },
    
    render: function() {
        var events = this.state.events.map(function(e) {
            return Event({event: e});
        })
        return React.DOM.ul(null, events);
    }
});

var Event = React.createClass({
    render: function() {
        var e = this.props.event;
        console.log(e);
        
        return (
                <li>
                <div className="bigEvent">
                <div className="coloredTop" style={{'background-color': e['color'] }}>
                
                <a className="eventTitle" href="{ e['page'] }">
                { e['title'] }
            </a>

            
                <span className="tagger">
                { e['groups'] }
            </span>


            <div className="topright">

              <a className="outLink linkIcon Hidden"
                 href="{ e['url'] }"
                 title="External link to event"
                 target="_blank"></a>

              <a className="gcalLink
                        linkIcon Hidden"
                 href="{ e['gcal'] }"
                 title="Add to Google Calendar"
                 target="_blank"></a>

            </div>

          </div>
          
          <div className="dateloc">
                <span className="date">
                { e['date_range'] }
            </span>

            <br/> 

            <div className="loc">
                { e['location'] }
            </div>

            
            <div className="desc ellipsis">
              <div className="descShort">
                <span className="descLink">Description:</span>
                { e['descShort'] }
              </div>

              <div className="descLong Hidden">
                <span className="descLink">Description:</span>
                <a className="descLong hideDesc Hidden">Hide description</a>
                <span dangerouslySetInnerHTML={{__html: e['descLong']}} />
              </div>
            </div>

          </div>
        </div>
      </li>

        );
    }
});
