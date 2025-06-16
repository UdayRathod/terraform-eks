from flask import Flask, render_template, request, redirect, url_for, session
import os

app = Flask(__name__)
app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'default-secret-key')

# Sample destination data
destinations = [
    {
        'id': 1,
        'name': 'Bali, Indonesia',
        'spots': ['Uluwatu Temple', 'Tegallalang Rice Terraces', 'Tanah Lot'],
        'hotels': ['Hotel Indigo Bali', 'The Legian Seminyak'],
        'price': '$999',
        'image': 'bali.jpg',
        'lat': -8.4095,
        'lon': 115.1889,
        'reviews': []
    },
    {
        'id': 2,
        'name': 'Paris, France',
        'spots': ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame'],
        'hotels': ['Le Meurice', 'Hotel Lutetia'],
        'price': '$1199',
        'image': 'paris.jpg',
        'lat': 48.8566,
        'lon': 2.3522,
        'reviews': []
    },
    {
        'id': 3,
        'name': 'Tokyo, Japan',
        'spots': ['Fushimi Inari Shrine', 'Kinkaku-ji', 'Gion District'],
        'hotels': ['The Ritz-Carlton', 'Hyatt Regency Kyoto'],
        'price': '$899',
        'image': 'tokyo.jpg',
        'lat': 35.0116,
        'lon': 135.7681,
        'reviews': []
    },
    {
        'id': 4,
        'name': 'New York City, USA',
        'spots': ['Statue of Liberty', 'Central Park', 'Times Square'],
        'hotels': ['The Plaza', 'Four Seasons'],
        'price': '$1299',
        'image': 'newyork.jpg',
        'lat': 40.7128,
        'lon': -74.0060,
        'reviews': []
    },
    {
        'id': 5,
        'name': 'Rome, Italy',
        'spots': ['Colosseum', 'Vatican Museums', 'Pantheon'],
        'hotels': ['Hotel Eden', 'Palazzo Manfredi'],
        'price': '$1099',
        'image': 'rome.jpg',
        'lat': 41.9028,
        'lon': 12.4964,
        'reviews': []
    },
    {
        'id': 6,
        'name': 'Sydney, Austrilia',
        'spots': ['Oia Village', 'Red Beach', 'Fira'],
        'hotels': ['Canaves Oia', 'Mystique Hotel'],
        'price': '$999',
        'image': 'sydney.jpg',
        'lat': 36.3932,
        'lon': 25.4615,
        'reviews': []
    },
    {
        'id': 7,
        'name': 'Maldives',
        'spots': ['Baros Island', 'Male City', 'Vaadhoo Island'],
        'hotels': ['Gili Lankanfushi', 'Baros Maldives'],
        'price': '$1499',
        'image': 'beach.jpg',
        'lat': 3.2028,
        'lon': 73.2207,
        'reviews': []
    },
    {
        'id': 8,
        'name': 'Bali',
        'image': 'bali.jpg',
        'spots': ['Ubud', 'Tanah Lot', 'Kuta Beach'],
        'hotels': ['Alila Villas', 'The Legian', 'Four Seasons'],
        'price': '$999',
        'lat': -8.4095,
        'lon': 115.1889,
        'reviews': []
    },
    {
        'id': 9,
        'name': 'London, UK',
        'spots': ['Big Ben', 'London Eye', 'Tower of London'],
        'hotels': ['The Savoy', 'The Langham', 'Corinthia Hotel'],
        'price': '$1400',
        'image': 'london.jpg',
        'lat': 51.5074,
        'lon': -0.1278,
        'reviews': []
    },
]

@app.route('/')
def home():
    query = request.args.get('search')
    if query:
        filtered = [d for d in destinations if query.lower() in d['name'].lower()]
    else:
        filtered = destinations
    return render_template('index.html', destinations=filtered)

@app.route('/destination/<int:id>', methods=['GET', 'POST'])
def destination(id):
    dest = next((d for d in destinations if d['id'] == id), None)
    if not dest:
        return "Destination not found", 404

    if request.method == 'POST':
        review = request.form.get('review')
        if review:
            dest.setdefault('reviews', []).append(review)
        return redirect(url_for('destination', id=id))

    return render_template('destination.html', destination=dest)

@app.route('/payment/<int:id>')
def payment(id):
    dest = next((d for d in destinations if d['id'] == id), None)
    if dest:
        return f"<h2>Proceed to payment for {dest['name']} - {dest['price']}</h2>"
    return "Destination not found", 404

@app.route('/add_to_wishlist/<int:id>')
def add_to_wishlist(id):
    if 'wishlist' not in session:
        session['wishlist'] = []
    if id not in session['wishlist']:
        session['wishlist'].append(id)
        session.modified = True
    return redirect(url_for('home'))

@app.route('/remove_from_wishlist/<int:id>')
def remove_from_wishlist(id):
    if 'wishlist' in session and id in session['wishlist']:
        session['wishlist'].remove(id)
        session.modified = True
    return redirect(url_for('wishlist'))

@app.route('/wishlist')
def wishlist():
    wishlist_ids = session.get('wishlist', [])
    wishlist_items = [d for d in destinations if d['id'] in wishlist_ids]
    return render_template('wishlist.html', destinations=wishlist_items)

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)



