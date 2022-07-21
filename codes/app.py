#!/usr/bin/env python3
from flask import Flask, render_template, redirect

app = Flask(__name__)


@app.route('/')
def index():
    return render_template("index.html.j2")


@app.route('/hass')
@app.route('/homeassistant')
def hass():
    return redirect("https://www.pupalot.fi:8123", code=301)


@app.route('/router')
def router():
    return redirect("https://paakinnu.asuscomm.com:8443", code=301)


@app.route('/pi-hole')
def pi_hole():
    return redirect("http://192.168.2.126:8444/admin/", code=301)



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
