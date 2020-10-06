#!/usr/bin/env python3
from flask import Flask, render_template, redirect

app = Flask(__name__)


@app.route('/')
def index():
    return render_template("index.html.j2")


@app.route('/hass')
@app.route('/homeassistant')
def hass():
    return redirect("https://pupalot.ddns.net:8123", code=301)



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
