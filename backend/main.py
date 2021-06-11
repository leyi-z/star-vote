from flask import Flask, jsonify, request, abort, render_template

app = Flask(__name__, template_folder='../frontend/')

frontend_page_path = "index.html"


## Endpoints for template rendering

@app.route('/', methods=['GET'])
def home_page():
    return render_template(frontend_page_path)

@app.route('/rooms/<int:room_id>', methods=['GET'])
def room_page(room_id):
    return render_template(frontend_page_path)
    
    
## Functional endpoins

@app.route('/rooms', methods=['POST'])
def room_create():
    body = request.get_json()
    new_room = body.get('room')
    new_user = body.get('user')
    if not new_room: 
        new_room = "generated new room" 
        event = "created new room and user"
    else:
        old_room = "an existing room"
        if new_room == old_room:
            event = "created new user for existing room"
        else:
            event = "no such room"
    return jsonify({
        "success": True,
        "new_room": new_room,
        "new_user": new_user,
        "event": event
    })


