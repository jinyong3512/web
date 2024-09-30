<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Chat Interface</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/default.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        header {
            background-color: #4a76a8;
            color: white;
            text-align: center;
            padding: 1rem 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        header h1 {
            margin: 0;
            font-size: 2rem;
        }
        .content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }
        #chat-container {
            width: 100%;
            max-width: 800px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 70vh;
        }
        #chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 1rem;
        }
        .message {
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 18px;
            max-width: 80%;
            word-wrap: break-word;
        }
        .user-message {
            background-color: #e3f2fd;
            align-self: flex-end;
            margin-left: auto;
        }
        .ai-message {
            background-color: #f0f4c3;
            align-self: flex-start;
        }
        #user-input-container {
            display: flex;
            padding: 1rem;
            background-color: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }
        #user-input {
            flex: 1;
            padding: 0.5rem 1rem;
            border: 1px solid #ced4da;
            border-radius: 20px;
            font-size: 1rem;
        }
        #send-button {
            background-color: #4a76a8;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 0.5rem 1rem;
            margin-left: 0.5rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        #send-button:hover {
            background-color: #3a5a78;
        }
        footer {
            background-color: #4a76a8;
            color: white;
            text-align: center;
            padding: 1rem 0;
            font-size: 0.9rem;
        }
        /* Markdown styles */
        .message p {
            margin: 0 0 1rem 0;
        }
        .message h1, .message h2, .message h3 {
            margin-top: 1rem;
            margin-bottom: 0.5rem;
        }
        .message pre {
            background-color: #f8f9fa;
            border-radius: 4px;
            padding: 1rem;
            overflow-x: auto;
        }
        .message code {
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9em;
        }
        .message ul, .message ol {
            margin: 0 0 1rem 0;
            padding-left: 2rem;
        }
    </style>
</head>
<body>
    <header>
        <h1>AI Chat Interface</h1>
    </header>

    <div class="content">
        <div id="chat-container">
            <div id="chat-messages"></div>
            <div id="user-input-container">
                <input type="text" id="user-input" placeholder="Type your message here...">
                <button id="send-button">Send</button>
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2024 AI Chat Interface</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/4.0.2/marked.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js"></script>
    <script>
    $(document).ready(function() {
        function sendMessage() {
            var message = $('#user-input').val();
            if (message) {
                addMessage('user', message);
                $.ajax({
                    url: 'http://localhost:9090/ai',
                    method: 'GET',
                    data: { message: message },
                    success: function(response) {
                        addMessage('ai', response.completion);
                    },
                    error: function() {
                        addMessage('ai', 'Sorry, I encountered an error.');
                    }
                });
                $('#user-input').val('');
            }
        }

        $('#user-input').keypress(function(e) {
            if (e.which == 13) {  // Enter key
                sendMessage();
            }
        });

        $('#send-button').click(sendMessage);

        function addMessage(sender, message) {
            var messageClass = sender === 'user' ? 'user-message' : 'ai-message';
            var renderedMessage = sender === 'ai' ? marked.parse(message) : message;
            var messageElement = $('<div class="message ' + messageClass + '"></div>').html(renderedMessage);
            $('#chat-messages').append(messageElement);
            $('#chat-messages').scrollTop($('#chat-messages')[0].scrollHeight);
            
            // Apply syntax highlighting to code blocks
            messageElement.find('pre code').each(function(i, block) {
                hljs.highlightBlock(block);
            });
        }

        // Initialize marked options
        marked.setOptions({
            breaks: true,
            gfm: true
        });
    });
    </script>
</body>
</html>