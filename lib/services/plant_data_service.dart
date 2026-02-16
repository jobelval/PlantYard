import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/category_model.dart';

/// Sèvis santral ki kenbe tout done yo (plant ak kategori)
/// Tout lòt ekran yo ka itilize done sa yo
class PlantDataService {
  static final PlantDataService _instance = PlantDataService._internal();
  factory PlantDataService() => _instance;
  PlantDataService._internal();

  // ===================== KATEGORI YO =====================
  static final List<Category> categories = [
    Category(
      id: '1',
      name: 'Plant entryè',
      icon: '🏠',
      imageUrl:
          'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=500',
      plantCount: 3,
    ),
    Category(
      id: '2',
      name: 'Plant medsin',
      icon: '🌿',
      imageUrl:
          'https://images.unsplash.com/photo-1604762524889-3e2fcc145683?w=500',
      plantCount: 3,
    ),
    Category(
      id: '3',
      name: 'Fwi ak legim',
      icon: '🍅',
      imageUrl:
          'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=500',
      plantCount: 4,
    ),
    Category(
      id: '4',
      name: 'Plant dekoratif',
      icon: '🎍',
      imageUrl:
          'https://images.unsplash.com/photo-1509423350716-5aa7a1a67570?w=500',
      plantCount: 3,
    ),
    Category(
      id: '5',
      name: 'Kaktis',
      icon: '🌵',
      imageUrl:
          'https://images.unsplash.com/photo-1459411552882-8410e9964b6c?w=500',
      plantCount: 3,
    ),
  ];

  // ===================== TOUT PLANT YO =====================
  static final List<Plant> allPlants = [
    // --- Plant entryè (id: 1-3) ---
    Plant(
      id: '1',
      name: 'Monstera Deliciosa',
      scientificName: 'Monstera deliciosa',
      description:
          'Plant elegant ak fey ajoure, fasil pou swen. Li ka grandi jiska 2 mèt anwo nan kay.',
      price: 45.99,
      category: 'Plant entryè',
      images: [
        'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=500',
        'https://images.unsplash.com/photo-1614594976049-2e3df3bdb7e7?w=500',
      ],
      inStock: true,
      stockQuantity: 10,
      nurseryId: 'nur1',
      nurseryName: 'Pepinyè Vèt',
      careInstructions: {
        'light': 'Mwayen',
        'water': '2 fwa pa semèn',
        'temperature': '18-25°C'
      },
      rating: 4.5,
      reviewsCount: 23,
    ),
    Plant(
      id: '2',
      name: 'Ficus Lyrata',
      scientificName: 'Ficus lyrata',
      description:
          'Plant ak gwo fey an fòm viyòlon, renmen limyè dirèk. Idyal pou dekorasyon salon.',
      price: 65.50,
      category: 'Plant entryè',
      images: [
        'https://images.unsplash.com/photo-1587334274328-64186a80aeee?w=500',
        'https://images.unsplash.com/photo-1593691509543-55c32c4cc67e?w=500',
      ],
      inStock: true,
      stockQuantity: 5,
      nurseryId: 'nur1',
      nurseryName: 'Pepinyè Vèt',
      careInstructions: {
        'light': 'Anpil',
        'water': '1 fwa pa semèn',
        'temperature': '20-28°C'
      },
      rating: 4.8,
      reviewsCount: 15,
    ),
    Plant(
      id: '3',
      name: 'Palm Areca',
      scientificName: 'Dypsis lutescens',
      description:
          'Plant ki renmen limyè, ideyal pou salon. Li bay yon atmosfè tropikal nan nenpòt espas.',
      price: 35.99,
      category: 'Plant entryè',
      images: [
        'https://tse1.mm.bing.net/th/id/OIP.4Bai_RiegawexDggSEoXOgHaKl?cb=defcache2&pid=ImgDet&defcache=1&w=206&h=294&c=7&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 7,
      nurseryId: 'nur1',
      nurseryName: 'Pepinyè Vèt',
      careInstructions: {
        'light': 'Anpil',
        'water': '2 fwa pa semèn',
        'temperature': '18-26°C'
      },
      rating: 4.3,
      reviewsCount: 9,
    ),

    // --- Plant medsin (id: 4-6) ---
    Plant(
      id: '4',
      name: 'Aloe Vera',
      scientificName: 'Aloe barbadensis miller',
      description:
          'Plant medsin ak anpil itilite. Jèl li bon pou pwoteje po, geri boule ak trete enfeksyon.',
      price: 18.99,
      category: 'Plant medsin',
      images: [
        'https://tse2.mm.bing.net/th/id/OIP.l3De_0KWra0IjO9rOh7cDgHaD5?cb=defcache2&pid=ImgDet&defcache=1&w=203&h=106&c=7&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 15,
      nurseryId: 'nur2',
      nurseryName: 'Pepinyè Wouj',
      careInstructions: {
        'light': 'Anpil',
        'water': '1 fwa pa 2 semèn',
        'temperature': '15-28°C'
      },
      rating: 4.7,
      reviewsCount: 18,
    ),
    Plant(
      id: '5',
      name: 'Lavann',
      scientificName: 'Lavandula angustifolia',
      description:
          'Plant aromatik ak flè mov. Odè li kalme nevrès epi repouse ensèk. Bon pou te medsin.',
      price: 14.50,
      category: 'Plant medsin',
      images: [
        'https://tse2.mm.bing.net/th/id/OIP.Hu4HpTI-HWW5kxM7R7qIWQHaDt?cb=defcache2&defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 20,
      nurseryId: 'nur2',
      nurseryName: 'Pepinyè Wouj',
      careInstructions: {
        'light': 'Anpil solèy',
        'water': '1 fwa pa semèn',
        'temperature': '10-25°C'
      },
      rating: 4.6,
      reviewsCount: 31,
    ),
    Plant(
      id: '6',
      name: 'Mant Poivrée',
      scientificName: 'Mentha piperita',
      description:
          'Plant ki santi bon ak plizyè itilite medikal. Bon pou te, dijèsyon ak soulajman tèt fè mal.',
      price: 9.99,
      category: 'Plant medsin',
      images: [
        'https://tse2.mm.bing.net/th/id/OIP.l9_tx2yyz_BG85QKCMsEGQAAAA?cb=defcache2&pid=ImgDet&defcache=1&w=206&h=206&c=7&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 25,
      nurseryId: 'nur2',
      nurseryName: 'Pepinyè Wouj',
      careInstructions: {
        'light': 'Mwayen',
        'water': '2 fwa pa semèn',
        'temperature': '15-22°C'
      },
      rating: 4.4,
      reviewsCount: 14,
    ),

    // --- Fwi ak legim (id: 7-10) ---
    Plant(
      id: '7',
      name: 'Tomat Cheri',
      scientificName: 'Solanum lycopersicum var. cerasiforme',
      description:
          'Ti tomat dous ki fasil pou grandi nan pot oswa jaden. Rekòlte chak semèn lè yo mi.',
      price: 12.99,
      category: 'Fwi ak legim',
      images: [
        'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=500',
        'https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=500',
      ],
      inStock: true,
      stockQuantity: 18,
      nurseryId: 'nur3',
      nurseryName: 'Jaden Frè',
      careInstructions: {
        'light': 'Anpil solèy',
        'water': '3 fwa pa semèn',
        'temperature': '18-28°C'
      },
      rating: 4.5,
      reviewsCount: 27,
    ),
    Plant(
      id: '8',
      name: 'Sitron Meye',
      scientificName: 'Citrus × limon',
      description:
          'Plant sitwon ki pote fwi tout ane. Idyal pou kizin ak te. Li renmen solèy ak tè drenn bien.',
      price: 28.99,
      category: 'Fwi ak legim',
      images: [
        'https://tse1.mm.bing.net/th/id/OIP.PBg_aziUfWZMX0Cj42KI9wAAAA?cb=defcache2&defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 8,
      nurseryId: 'nur3',
      nurseryName: 'Jaden Frè',
      careInstructions: {
        'light': 'Plein solèy',
        'water': '2 fwa pa semèn',
        'temperature': '20-30°C'
      },
      rating: 4.6,
      reviewsCount: 19,
    ),
    Plant(
      id: '9',
      name: 'Piman Dous',
      scientificName: 'Capsicum annuum',
      description:
          'Piman kolorè ki dous, rich an vitamin C. Fasil pou grandi nan pot oswa jaden.',
      price: 10.50,
      category: 'Fwi ak legim',
      images: [
        'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=500',
        'https://images.unsplash.com/photo-1601648764658-cf37e8c89b70?w=500',
      ],
      inStock: true,
      stockQuantity: 22,
      nurseryId: 'nur3',
      nurseryName: 'Jaden Frè',
      careInstructions: {
        'light': 'Anpil solèy',
        'water': '2 fwa pa semèn',
        'temperature': '20-26°C'
      },
      rating: 4.2,
      reviewsCount: 11,
    ),
    Plant(
      id: '10',
      name: 'Frèz',
      scientificName: 'Fragaria × ananassa',
      description:
          'Plant frèz dous ki ka grandi nan pot. Fasil pou swen epi pote fwi savoureux.',
      price: 16.99,
      category: 'Fwi ak legim',
      images: [
        'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=500',
        'https://images.unsplash.com/photo-1543528176-61b239494933?w=500',
      ],
      inStock: false,
      stockQuantity: 0,
      nurseryId: 'nur3',
      nurseryName: 'Jaden Frè',
      careInstructions: {
        'light': 'Anpil solèy',
        'water': '3 fwa pa semèn',
        'temperature': '15-24°C'
      },
      rating: 4.8,
      reviewsCount: 35,
    ),

    // --- Plant dekoratif (id: 11-13) ---
    Plant(
      id: '11',
      name: 'Orchide',
      scientificName: 'Phalaenopsis amabilis',
      description:
          'Flè orchide elegann ki dire plizyè semèn. Dekorasyon pafè pou nenpòt espas enteryè.',
      price: 32.99,
      category: 'Plant dekoratif',
      images: [
        'https://tse1.mm.bing.net/th/id/OIP.kjbEwGRcjkJEOXXdHWgfZwHaE7?cb=defcache2&defcache=1&w=626&h=417&rs=1&pid=ImgDetMain&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 12,
      nurseryId: 'nur4',
      nurseryName: 'Pepinyè Bèl Flè',
      careInstructions: {
        'light': 'Limyè endirèk',
        'water': '1 fwa pa semèn',
        'temperature': '18-25°C'
      },
      rating: 4.9,
      reviewsCount: 42,
    ),
    Plant(
      id: '12',
      name: 'Succulent',
      scientificName: 'Echeveria elegans',
      description:
          'Ti plant gras ak bèl fòm rozèt. Fasil pou grandi, pa bezwen anpil dlo ni atansyon.',
      price: 12.50,
      category: 'Plant dekoratif',
      images: [
        'https://th.bing.com/th/id/OIP.nstVt05BVz4T29Cps-pqtwHaE8?o=7&cb=defcache2&rm=3&defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 30,
      nurseryId: 'nur2',
      nurseryName: 'Pepinyè Wouj',
      careInstructions: {
        'light': 'Mwayen',
        'water': '1 fwa pa 2 semèn',
        'temperature': '15-25°C'
      },
      rating: 4.6,
      reviewsCount: 12,
    ),
    Plant(
      id: '13',
      name: 'Begonia',
      scientificName: 'Begonia × tuberhybrida',
      description:
          'Bèl plant ak flè kolorè ki dire tout ane. Fasil pou swen nan pot enteryè.',
      price: 19.99,
      category: 'Plant dekoratif',
      images: [
        'https://images.unsplash.com/photo-1597305877032-0668b3c6413a?w=500',
      ],
      inStock: true,
      stockQuantity: 16,
      nurseryId: 'nur4',
      nurseryName: 'Pepinyè Bèl Flè',
      careInstructions: {
        'light': 'Limyè endirèk',
        'water': '2 fwa pa semèn',
        'temperature': '16-24°C'
      },
      rating: 4.3,
      reviewsCount: 8,
    ),

    // --- Kaktis (id: 14-16) ---
    Plant(
      id: '14',
      name: 'Kaktis Saguaro',
      scientificName: 'Carnegiea gigantea',
      description:
          'Kaktis emblematik ak gwo branch vètikal. Pa bezwen anpil swen. Idyal pou move klimat sèk.',
      price: 22.99,
      category: 'Kaktis',
      images: [
        'https://tse4.mm.bing.net/th/id/OIP.eupm4eBECDkEYUR5xP6nhgHaLJ?cb=defcache2&pid=ImgDet&defcache=1&w=203&h=305&c=7&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 9,
      nurseryId: 'nur5',
      nurseryName: 'Pepinyè Dezè',
      careInstructions: {
        'light': 'Plein solèy',
        'water': '1 fwa pa mwa',
        'temperature': '20-40°C'
      },
      rating: 4.1,
      reviewsCount: 6,
    ),
    Plant(
      id: '15',
      name: 'Kaktis Noel',
      scientificName: 'Schlumbergera bridgesii',
      description:
          'Kaktis ki fleri pandan sezon Noel. Flè wouj oswa woz bèl pou dekorasyon.',
      price: 15.99,
      category: 'Kaktis',
      images: [
        'https://tse3.mm.bing.net/th/id/OIP.IGAk1gu9Vr1VK4sY4KZ7jQHaEK?cb=defcache2&defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 20,
      nurseryId: 'nur5',
      nurseryName: 'Pepinyè Dezè',
      careInstructions: {
        'light': 'Limyè endirèk',
        'water': '1 fwa pa semèn',
        'temperature': '15-25°C'
      },
      rating: 4.4,
      reviewsCount: 17,
    ),
    Plant(
      id: '16',
      name: 'Opuntia',
      scientificName: 'Opuntia ficus-indica',
      description:
          'Kaktis raquèt ak fig endyen. Solid, rezistazn ak chalè epi pa bezwen anpil swen.',
      price: 18.50,
      category: 'Kaktis',
      images: [
        'https://tse3.mm.bing.net/th/id/OIP.RA0HnEgIV-R-0d23pWNlpAHaJ4?cb=defcache2&defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3',
      ],
      inStock: true,
      stockQuantity: 11,
      nurseryId: 'nur5',
      nurseryName: 'Pepinyè Dezè',
      careInstructions: {
        'light': 'Plein solèy',
        'water': '1 fwa pa 3 semèn',
        'temperature': '18-35°C'
      },
      rating: 4.0,
      reviewsCount: 5,
    ),
  ];

  /// Retounen plant pa kategori
  static List<Plant> getPlantsByCategory(String categoryName) {
    return allPlants
        .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
        .toList();
  }

  /// Rechèch plant pa non
  static List<Plant> searchPlants(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();
    return allPlants
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.scientificName.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  /// 6 plant popilè (pi wo rating)
  static List<Plant> get featuredPlants {
    final sorted = List<Plant>.from(allPlants);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(6).toList();
  }

  /// Plant ki pa nan "popilè" yo (pou seksyon Nouvo)
  static List<Plant> get recentPlants {
    final featured = featuredPlants.map((p) => p.id).toSet();
    return allPlants.where((p) => !featured.contains(p.id)).toList();
  }

  /// Jwenn yon plant pa ID
  static Plant? getPlantById(String id) {
    try {
      return allPlants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
