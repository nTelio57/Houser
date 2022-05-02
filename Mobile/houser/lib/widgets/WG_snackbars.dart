import 'package:flutter/material.dart';

const noConnectionSnackbar = SnackBar(
    content: Text('Pasitikrinkite interneto ryšį.')
);

const serverErrorSnackbar = SnackBar(
    content: Text('Klaida bandant pasiekti serverį.')
);

const failedLogin = SnackBar(
    content: Text('Nepavyko prisijungti.')
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
    content: Text('Įvyko klaida bandant pasiekti žinučių servisą.')
);