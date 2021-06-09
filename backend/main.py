from flask import Flask, request, render_template

app = Flask(__name__, template_folder='../frontend/')

frontend_page_path = "index.html"

@app.route('/', methods=['GET'])
def bleh():
    return render_template(frontend_page_path)

@app.route('/room/<int:bleh_id>', methods=['GET'])
def bleh_number(bleh_id):
    return render_template(frontend_page_path)
