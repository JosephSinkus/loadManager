component {

	this.name = "Chat";
	this.wschannels = [
        {
            name="chat"
            ,cfcListener: "WSApplication"
        }
    ];
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan( 0, 0, 1, 0 );

    
    function onSessionStart(){
        application.sessions[ hash( session.sessionID ) ] = session;
        session.isLoggedIn = false;
		session.name = "";

		return;
    }

    function onSessionEnd( sessionScope, applicationScope ){
		structDelete( 
			applicationScope.sessions,
			hash( sessionScope.sessionID ) 
		);
		return;		
	}

    function onWSSessionStart( user ){
		param name="form.cfid" type="string" default="";
		param name="form.cftoken" type="string" default="";

		var sessionID = "#this.name#_#form.cfid#_#form.cftoken#";

		var sessionHash = hash( sessionID );

		if (structKeyExists( application.sessions, sessionHash )){
			user.session = application.sessions[ sessionHash ]; 			
		}

		return;		
	}

    function onWSRequestStart( type, channel, user ){

		if (
					!user.session.isLoggedIn 
				&&
					(
						(type == "subscribe") ||
						(type == "publish")
					)
			){

			return( false );
			
		}
		return( true );
		
	}

    function onWSRequest( channel, publisher, message ){
		if (publisher.clientID){
			return( "[FROM: #publisher.session.name#] #message#" );
		} else {
			return( "[FROM: Server] #message#" );			
		}
		
	}

	function onWSResponse( channel, subscriber, message ){
		return( "[TO: #subscriber.session.name#] #message#" );		
	}

    function logData( data ){

		var logFilePath = (
			getDirectoryFromPath( getCurrentTemplatePath() ) & 
			"log.txt"
		);
		
		// Dump to TXT file.
		writeDump( var=data, output=logFilePath );
		
	}
}