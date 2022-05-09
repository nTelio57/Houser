import 'package:flutter/material.dart';

const noConnectionSnackbar = SnackBar(
    content: Text('Kažkas įvyko ne taip.')
);

const serverErrorSnackbar = SnackBar(
    content: Text('Kažkas įvyko ne taip.')
);

const failedLogin = SnackBar(
    content: Text('Nepavyko prisijungti.')
);

const failedRegister = SnackBar(
    content: Text('Nepavyko prisiregistruoti.')
);

const failedFileUpload = SnackBar(
    content: Text('Nepavyko įkelti failo.')
);

const failedImageDelete = SnackBar(
    content: Text('Nepavyko pašalinti nuotraukos.')
);

const failedMatchDelete = SnackBar(
    content: Text('Nepavyko atšaukti suporavimo.')
);

const failedImageUpdate = SnackBar(
    content: Text('Nepavyko atnaujinti nuotraukos.')
);

const validationFailed = SnackBar(
    content: Text('Patikrinkite įvestus duomenis.')
);

const visibilityChangeFailed = SnackBar(
    content: Text('Nepavyko pakeisti matomumo.')
);

const roomHasToHaveImages = SnackBar(
    content: Text('Privalote įkelti bent 1 nuotrauką.')
);

const messengerFailed = SnackBar(
    content: Text('Kažkas įvyko ne taip.')
);

const noRoomOfferForUserFilter = SnackBar(
    content: Text('Norint pasirinkti kambarioko filtrą reikalingas kambario pasiūlymas.')
);