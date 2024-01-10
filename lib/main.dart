import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musicrecordstore/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RealTimeData(),
    );
  }
}

class RecordCard extends StatelessWidget {
  final String name;
  final String artist;
  final String price;
  final String reviews;
  final String rating;
  final String imageURL;
  final String details;

  RecordCard({
    required this.name,
    required this.artist,
    required this.price,
    required this.reviews,
    required this.rating,
    required this.imageURL,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              name: name,
              artist: artist,
              price: price,
              reviews: reviews,
              rating: rating,
              imageURL: imageURL,
              details: details,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageURL),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text("Artist: $artist"),
                    Text("Price: $price"),
                    Text("Reviews: $reviews"),
                    Text("Rating: $rating"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RealTimeData extends StatelessWidget {
  final ref = FirebaseDatabase.instance.ref('records');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MusicRecordStore"),
        backgroundColor: Color.fromARGB(255, 105, 240, 177),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    Expanded(
                      child: SearchTextField(),
                    ),
                    SearchButton(), // No need to pass state instance
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Popular Records",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: FirebaseAnimatedList(
                query: ref.orderByChild('Reviews').limitToLast(3),
                itemBuilder: (context, snapshot, animation, index) {
                  return RecordCard(
                    name: snapshot.child('Name').value.toString(),
                    artist: snapshot.child('Artist').value.toString(),
                    price: snapshot.child('Price').value.toString(),
                    reviews: snapshot.child('Reviews').value.toString(),
                    rating: snapshot.child('Rating').value.toString(),
                    imageURL: snapshot.child('ImageURL').value.toString(),
                    details: snapshot.child('Details').value.toString(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String name;
  final String artist;
  final String price;
  final String reviews;
  final String rating;
  final String imageURL;
  final String details;

  DetailPage({
    required this.name,
    required this.artist,
    required this.price,
    required this.reviews,
    required this.rating,
    required this.imageURL,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          // Sol Üst: Ürün Fotoğrafı
          Container(
            alignment: Alignment.topLeft,
            child: Image.network(
              imageURL,
              height: 200.0,
              width: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.0),

          // Sol Alt: Ürün Bilgileri
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Artist: $artist"),
                  Text("Price: $price"),
                  Text("Reviews: $reviews"),
                  Text("Rating: $rating"),
                ],
              ),
            ),
          ),

          // Sağ Üst: Sepete Ekle Butonu
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Sepete ekleme işlemi
                // TODO: Sepete ekleme işlemleri burada gerçekleştirilecek
              },
              child: Text("Add to Cart"),
            ),
          ),

          // Sağ Alt: Detaylar
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(details),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  _SearchTextFieldState createState() => _SearchTextFieldState();

  // Expose a method to perform the search
  void performSearch(BuildContext context) {
    _SearchTextFieldState state = _SearchTextFieldState();
    state._performSearch(context);
  }
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Search by artist/album/genre",
        border: InputBorder.none,
      ),
      onSubmitted: (value) {
        _performSearch(context);
      },
    );
  }

  void _performSearch(BuildContext context) {
    final String searchTerm = _searchController.text.trim().toLowerCase();
    print("Search Term: $searchTerm"); // Debugging print

    if (searchTerm.isNotEmpty) {
      // Firebase query to search by Name or Artist
      Query searchQuery = FirebaseDatabase.instance.ref('records').orderByChild('Name_Artist_Search').equalTo(searchTerm);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(searchQuery),
        ),
      );
    }
  }
}

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // Perform search using the exposed method
        SearchTextField().performSearch(context);
      },
    );
  }
}


class SearchResultsPage extends StatelessWidget {
  final Query searchQuery;

  SearchResultsPage(this.searchQuery);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
      ),
      body: FirebaseAnimatedList(
        query: searchQuery,
        itemBuilder: (context, snapshot, animation, index) {
          return RecordCard(
            name: snapshot.child('Name').value.toString(),
            artist: snapshot.child('Artist').value.toString(),
            price: snapshot.child('Price').value.toString(),
            reviews: snapshot.child('Reviews').value.toString(),
            rating: snapshot.child('Rating').value.toString(),
            imageURL: snapshot.child('ImageURL').value.toString(),
            details: snapshot.child('Details').value.toString(),
          );
        },
      ),
    );
  }
}