import '../config.dart';
import '../models/rides_info_model.dart';
import '../helper/date_time_helper.dart';
import '../api/enums/trip_type_enum.dart';

class AppArray {
  var bottomNavigationBarList = [
    {
      "title": appFonts.home,
      "icon": svgAssets.homeLight,
      "iconDark": svgAssets.homeDark
    },
    {
      "title": appFonts.activeRide,
      "icon": svgAssets.driving1,
      "iconDark": svgAssets.driving
    },
    {
      "title": appFonts.assignments,
      "icon": svgAssets.carLight,
      "iconDark": svgAssets.carDark
    },
    {
      "title": appFonts.settings,
      "icon": svgAssets.settingLight,
      "iconDark": svgAssets.settingDark
    }
  ];

  var localList = <Locale>[
    const Locale('en'),
    const Locale('ar'),
    const Locale('fr'),
    const Locale('hi')
  ];

  var upcomingRide = [
    {
      "user": {
        "name": "Johnson Smithkover",
        "image_url": "assets/image/home/user.png"
      },
      "rating": 4.5,
      "price": 256,
      "currency": "\$",
      "distance": "9.5 km",
      "date_time": "15 Dec'23 at 10:15 AM",
      "locations": {
        "pickup": {
          "address": "220 Yonge St, Toronto, ON M5B 2H1, Canada",
          "icon": "location_icon.png"
        },
        "dropoff": {
          "address": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada",
          "icon": "destination_icon.png"
        }
      }
    },
    {
      "user": {
        "name": "Johnson Smithkover",
        "image_url": "assets/image/home/user.png"
      },
      "rating": 4.5,
      "price": 122,
      "currency": "\$",
      "distance": "9.5 km",
      "date_time": "15 Dec'23 at 10:15 AM",
      "locations": {
        "pickup": {
          "address": "220 Yonge St, Toronto, ON M5B 2H1, Canada",
          "icon": "location_icon.png"
        },
        "dropoff": {
          "address": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada",
          "icon": "destination_icon.png"
        }
      }
    }
  ];

  // language list
  // var languageList = [
  //   {
  //     "title": appFonts.english,
  //     "locale": const Locale('en', 'EN'),
  //     "code": "en",
  //     "icon": 'assets/image/settings/Base.png'
  //   },
  //   {
  //     "title": appFonts.arabic,
  //     "locale": const Locale("ar", 'AE'),
  //     "code": "ar",
  //     "icon": 'assets/image/settings/base1.png'
  //   },
  //   {
  //     "title": appFonts.french,
  //     "locale": const Locale('fr', 'FR'),
  //     "code": "fr",
  //     "icon": 'assets/image/settings/Base2.png'
  //   },
  //   {
  //     "title": 'Hindi',
  //     "locale": const Locale("hi", 'HI'),
  //     "code": "es",
  //     "icon": 'assets/image/settings/Base3.png'
  //   },
  // ];
  var languageList = [
    {
      "title": appFonts.english,
      "locale": const Locale('en', 'EN'),
      "code": "en",
      "icon": 'assets/image/settings/Base.png'
    },
    {
      "title": appFonts.arabic,
      "locale": const Locale("ar", 'AE'),
      "code": "ar",
      "icon": 'assets/image/settings/base1.png'
    },
    {
      "title": appFonts.french,
      "locale": const Locale('fr', 'FR'),
      "code": "fr",
      "icon": 'assets/image/settings/Base2.png'
    },
    {
      "title": appFonts.spanish,
      "locale": const Locale("es", 'HI'),
      "code": "es",
      "icon": 'assets/image/settings/Base3.png'
    }
  ];
  var currencyList = [
    {
      "id": 1,
      "code": "USD",
      "symbol": "\$",
      "no_of_decimal": "2.00",
      "exchange_rate": "1.00",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "0",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-11-13T03:43:17.000000Z",
      "deleted_at": null,
      "title": 'US dollar',
      "icon": svgAssets.usDollar
    },
    {
      "id": 2,
      "code": "INR",
      "symbol": "₹",
      "no_of_decimal": "2.00",
      "exchange_rate": "83.24",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "1",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-11-13T03:43:17.000000Z",
      "deleted_at": null,
      "title": 'INR',
      "icon": svgAssets.inr
    },
    {
      "id": 3,
      "code": "GBP",
      "symbol": "£",
      "no_of_decimal": "2.00",
      "exchange_rate": "100.00",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "0",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-09-08T16:55:08.000000Z",
      "deleted_at": null,
      "title": 'Pound',
      "icon": svgAssets.pound
    },
    {
      "id": 4,
      "code": "EUR",
      "symbol": "€",
      "no_of_decimal": "2.00",
      "exchange_rate": "0.01",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "0",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-09-08T16:55:08.000000Z",
      "deleted_at": null,
      "title": 'Euro',
      "icon": svgAssets.euro
    }
  ];
  List settings = [
    {
      "title": appFonts.general,
      "data": [
        {"subTitle": appFonts.profileSettings, "icon": svgAssets.profile},
        {"subTitle": appFonts.myWallet, "icon": svgAssets.wallet},
        {"subTitle": appFonts.offerList, "icon": svgAssets.offer},
        {"subTitle": appFonts.appSettings, "icon": svgAssets.settings}
      ]
    },
    {
      "title": appFonts.registrationDetails,
      "data": [
        {"subTitle": appFonts.documentRegistration, "icon": svgAssets.document},
        {"subTitle": appFonts.userRegistration, "icon": svgAssets.frame},
        {"subTitle": appFonts.bankDetail, "icon": svgAssets.bank}
      ]
    },
    {
      "title": appFonts.alertZone,
      "data": [
        {"subTitle": appFonts.deleteAccount, "icon": svgAssets.check},
        {"subTitle": appFonts.logout, "icon": svgAssets.logout}
      ]
    }
  ];
  final List<Map<String, String>> rideData = [
    {"count": "02", "title": "Pending \nRide"},
    {"count": "16", "title": "Complete \nRide"},
    {"count": "04", "title": "Cancel \nRide"}
  ];
  final List<RideInfo> rides = [
    RideInfo(
        userName: 'Johnson Smithkover',
        userImage: 'assets/image/home/user.png',
        rating: '4.5',
        price: '256',
        distance: '9.5 km',
        dateTime: '15 Dec’23 at 10:15 AM',
        pickUpAddress: '220 Yonge St, Toronto, ON M5B 2H1, Canada',
        dropOffAddress: '17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada'),
    RideInfo(
        userName: 'Emily Davis',
        userImage: 'assets/image/home/user.png',
        rating: '4.2',
        price: '150',
        distance: '7.8 km',
        dateTime: '16 Dec’23 at 12:30 PM',
        pickUpAddress: '123 Queen St, Toronto, ON M5H 2N2, Canada',
        dropOffAddress: '456 King St, Toronto, ON M5A 1K2, Canada')
  ];

  List<Map<String, dynamic>> offers = [
    {
      'name': 'Johnson Smithkover',
      'discountText': '(30% OFF)',
      'carType': 'Mini sedan',
      'peopleCount': '4',
      'validTill': '20/11/2023',
      'isToggled': true
    },
    {
      'name': 'Johnson Smithkover',
      'discountText': '(30% OFF)',
      'carType': 'Mini sedan',
      'peopleCount': '4',
      'validTill': '20/11/2023',
      'isToggled': true
    }
  ];

  List<Map<String, dynamic>> userCompleteRideData = [
    {
      'name': 'Tony Danza',
      'price': 56,
      'rating': 4.8,
      'reviews': 127,
      'date': '23 Dec \'23',
      'time': '10:15 AM',
      'distance': '1 km',
      'pickUpAddress': '220 Yonge St, Toronto, ON M5B 2H1, Canada',
      'droppingAddress': '17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada',
      'imageUrl': 'assets/image/home/user2.png'
    },
    {
      'name': 'Willie Tanner',
      'price': 84,
      'rating': 4.8,
      'reviews': 127,
      'date': '30 Dec \'23',
      'time': '10:15 AM',
      'distance': '2 km',
      'pickUpAddress':
          '1600 Amphitheatre Parkway, Mountain View, CA 94043, USA',
      'droppingAddress': '350 5th Ave, New York, NY 10118, USA',
      'imageUrl': 'assets/image/home/user2.png'
    },
    {
      'name': 'Sarah Connor',
      'price': 92,
      'rating': 4.7,
      'reviews': 150,
      'date': '05 Jan \'24',
      'time': '02:30 PM',
      'distance': '3 km',
      'pickUpAddress': '742 Evergreen Terrace, Springfield, USA',
      'droppingAddress': '10 Downing St, London SW1A 2AA, UK',
      'imageUrl': 'assets/image/home/user2.png'
    },
    {
      'name': 'John Wick',
      'price': 120,
      'rating': 4.9,
      'reviews': 200,
      'date': '15 Jan \'24',
      'time': '11:00 AM',
      'distance': '5 km',
      'pickUpAddress': '123 Main St, New York, NY 10001, USA',
      'droppingAddress': 'Champs-Élysées, Paris, France',
      'imageUrl': 'assets/image/home/user2.png'
    },
    {
      'name': 'Ellen Ripley',
      'price': 65,
      'rating': 4.6,
      'reviews': 110,
      'date': '20 Jan \'24',
      'time': '01:15 PM',
      'distance': '4 km',
      'pickUpAddress': '221B Baker St, London NW1 6XE, UK',
      'droppingAddress': '742 Evergreen Terrace, Springfield, USA',
      'imageUrl': 'assets/image/home/user2.png'
    }
  ];

  List<Map<String, dynamic>> userCancelRideData = [
    {
      'name': 'Tony Danza',
      'price': 56,
      'rating': 4.8,
      'reviews': 127,
      'date': '23 Dec \'23',
      'time': '10:15 AM',
      'distance': '1 km',
      'pickUpAddress': '220 Yonge St, Toronto, ON M5B 2H1, Canada',
      'droppingAddress': '17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada',
      'imageUrl': 'assets/image/home/user2.png'
    }
  ];

  List<Map<String, dynamic>> userPendingRideData = [
    {
      'name': 'John Doe',
      'rating': 4.9,
      'reviews': 150,
      'distance': '2.3 km',
      'earnings': 321.50,
      'pickupTime': '12 Oct \'23 at 9:30 AM',
      'pickUpAddress': '123 King St, Toronto, ON M5A 1J1, Canada',
      'droppingAddress': '456 Queen St, Toronto, ON M6A 2K3, Canada',
      'actions': ['chat', 'call']
    },
    {
      'name': 'Sarah Lee',
      'rating': 4.7,
      'reviews': 98,
      'distance': '0.8 km',
      'earnings': 278.40,
      'pickupTime': '22 Nov \'23 at 2:15 PM',
      'pickUpAddress': '789 Dundas St, Toronto, ON M5B 2K1, Canada',
      'droppingAddress': '234 Bloor St, Mississauga, ON L5C 1Z5, Canada',
      'actions': ['chat', 'call']
    },
    {
      'name': 'Alex Murphy',
      'rating': 4.5,
      'reviews': 76,
      'distance': '1.5 km',
      'earnings': 199.99,
      'pickupTime': '05 Dec \'23 at 11:45 AM',
      'pickUpAddress': '987 Spadina Ave, Toronto, ON M5S 2J3, Canada',
      'droppingAddress': '654 Sherbourne St, Toronto, ON M4Y 1X2, Canada',
      'actions': ['chat', 'call']
    },
    {
      'name': 'Emma Watson',
      'rating': 4.8,
      'reviews': 135,
      'distance': '0.9 km',
      'earnings': 412.00,
      'pickupTime': '01 Jan \'24 at 5:00 PM',
      'pickUpAddress': '321 Bay St, Toronto, ON M5H 2Y2, Canada',
      'droppingAddress': '789 Parliament St, Toronto, ON M5A 2J4, Canada',
      'actions': ['chat', 'call']
    },
    {
      'name': 'David Johnson',
      'rating': 4.3,
      'reviews': 110,
      'distance': '3.2 km',
      'earnings': 175.25,
      'pickupTime': '14 Feb \'24 at 8:00 AM',
      'pickUpAddress': '654 Yonge St, Toronto, ON M4Y 2A6, Canada',
      'droppingAddress': '987 King St, Toronto, ON M6K 3B3, Canada',
      'actions': ['chat', 'call']
    }
  ];

  var optionList = [appFonts.callNow, appFonts.clearChat];
  var chatList = [
    {
      "type": "receiver",
      "message": "Hello ! How can i help you ?",
    },
    {
      "type": "source",
      "message": "Hello ! When will you arrive ?",
    },
    {
      "type": "receiver",
      "message": "I’ll be there soon.",
    },
    {
      "type": "source",
      "message": "Okay !! Thank you.",
    }
  ];

  var saveLocation = [
    {
      "title": "Home",
      "icon": svgAssets.home,
      "address": "220 Yonge St, Toronto, ON M5B 2H1, Canada"
    },
    {
      "title": "Work",
      "icon": svgAssets.briefcase,
      "address": "220 Yonge St, Toronto, ON M5B 2H1, Canada"
    },
  ];

  final List<Map<String, dynamic>> totalEarningTransactions = [
    {
      'type': 'Admin Commission Debit',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': false,
    },
    {
      'type': 'Wallet TopUp',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': true,
    },
    {
      'type': 'Wallet TopUp',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': true,
    },
    {
      'type': 'Admin Commission Debit',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': false,
    },
    {
      'type': 'Admin Commission Debit',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': false,
    },
    {
      'type': 'Wallet TopUp',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': true,
    },
  ];
  final List<Map<String, dynamic>> withdrawHistory = [
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123456',
      'amount': 300,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123457',
      'amount': 250,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123458',
      'amount': 400,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123459',
      'amount': 350,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123460',
      'amount': 150,
      'isCredit': false
    }
  ];

  final List<Map<String, String>> paymentMethods = [
    {'name': 'PayPal', 'icon': svgAssets.logoPaypal},
    {'name': 'Apple Pay', 'icon': svgAssets.cibApplePay},
    {'name': 'Google Pay', 'icon': svgAssets.gPay}
  ];

  //app setting
  List appSetting(isNotification) => [
        {
          'title':
              isNotification ? appFonts.notification : appFonts.notification,
          'icon': svgAssets.bell
        },
        {'title': appFonts.changeCurrency, 'icon': svgAssets.currency},
        {'title': appFonts.changeLanguage, 'icon': svgAssets.translate},
      ];

  final List<Map<String, dynamic>> offersList = [
    {
      "discount": "30% OFF",
      "description": "Up to 10 km from Wankover city area",
      "carType": "Mini sedan",
      "capacity": "4 person",
      "validTill": "20/10/2023",
      "isActive": true
    },
    {
      "discount": "60% OFF",
      "description": "Up to 10 km from Wankover city area",
      "carType": "Mini sedan",
      "capacity": "3 person",
      "validTill": "15/11/2023",
      "isActive": false
    },
    {
      "discount": "20% OFF",
      "description": "Up to 10 km from Wankover city area",
      "carType": "Mini sedan",
      "capacity": "4 person",
      "validTill": "22/12/2023",
      "isActive": true
    }
  ];

  var notification = [
    {
      "title": "Account Alert!",
      "subtitle": "This allow you to retrieve your account if you lose access.",
      "icon": svgAssets.alert,
      "isRead": false
    },
    {
      "title": "Receive 20% discount for first ride",
      "subtitle": "You have booked plumber service today at 6:30pm.",
      "icon": svgAssets.discountCircle,
      "isRead": true
    },
    {
      "title": "New year shopping with rider!",
      "subtitle": "You have booked plumber service today at 6:30pm.",
      "icon": svgAssets.driving1,
      "isRead": true
    },
    {
      "title": "You have received 1 coupon",
      "subtitle": "You have booked plumber service today at 6:30pm.",
      "icon": svgAssets.ticketDiscount,
      "isRead": true
    }
  ];
  final List<Map<String, dynamic>> ridesData = [
    {
      'userName': 'Home to School',
      'price': '',
      'rating': 4.8,
      'totalRatings': 127,
      'time': DateTimeHelper.getFormattedDateTime(timeOfDay: '8:00 AM'),
      'tripType': TripType.pickup,
      // 'pickUpAddress': '220 Yonge St, Toronto, ON M5B 2H1, Canada',
      // 'droppingAddress': '17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada',
      'contact': '+919876543210',
      'imageUrl': 'assets/image/home/user1.png'
    },
    {
      'userName': 'School to Home',
      'price': '',
      'rating': 4.9,
      'totalRatings': 205,
      'time': DateTimeHelper.getFormattedDateTime(timeOfDay: '4:00 PM'),
      'tripType': TripType.drop,
      // 'pickUpAddress': '500 King St, Toronto, ON M5V 1L9, Canada',
      // 'droppingAddress': '2500 Rutherford Rd, Vaughan, ON L4K 2N6, Canada',
      'contact': '+919876543211',
      'imageUrl': 'assets/image/home/user2.png'
    }
  ];
}
