<cftry>

    <cfwebsocket name="webSocketObj" onMessage="messageHandler" onError="errorHandler" onOpen="openHandler" onClose="closeHandler" subscribeTo="chat" />


    <doctype html>

        <head>
            <title>WebSocket Example</title>
            <script type="text/javascript">
                messageHandler = function (aEvent, aToken) {

                    if (aEvent.data) {
                        var txt = document.getElementById("msgArea");
                        txt.innerHTML += aEvent.data + "<br />";
                    }
                }

                openHandler = function () {
                    alert("Connection is open");
                }

                closeHandler = function () {
                    alert("Connection Closed");
                }

                errorHandler = function () {
                    alert("Doh!");
                    console.log(arguments);
                }

                sendMessage = function () {
                    var text = window.prompt("Enter some text", "");
                    if (text) {
                        webSocketObj.publish("chat", text);
                    }
                }
            </script>
        </head>

        <body>
            <div id="msgArea" />
            <input type="button" value="Send Message" onClick="sendMessage()">
        </body>

        </html>

        <cfcatch type="any">
            <cfdump var="#cfcatch#">
        </cfcatch>
</cftry>