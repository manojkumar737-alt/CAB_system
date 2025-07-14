from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Home Page
@app.route('/')
def home():
    return render_template('index.html')

# Booking Page (example endpoint)
@app.route('/book', methods=['GET', 'POST'])
def book():
    if request.method == 'POST':
        name = request.form['name']
        destination = request.form['destination']
        # You can add DB integration or logging here
        return redirect(url_for('confirmation', name=name, destination=destination))
    return render_template('book.html')

# Confirmation Page
@app.route('/confirmation')
def confirmation():
    name = request.args.get('name')
    destination = request.args.get('destination')
    return f"Thanks {name}, your ride to {destination} is confirmed!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
