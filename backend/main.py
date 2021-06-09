from flask import Flask, request, render_template

app = Flask(__name__, template_folder='../frontend/')

frontend_page_path = "index.html"

@app.route('/', methods=['GET'])
def home_page():
    return render_template(frontend_page_path)

@app.route('/room/<int:room_id>', methods=['GET'])
def room_page(room_id):
    return render_template(frontend_page_path)
