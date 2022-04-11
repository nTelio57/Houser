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

const validationFailed = SnackBar(
    content: Text('Patikrinkite įvestus duomenis.')
);

const visibilityChangeFailed = SnackBar(
    content: Text('Nepavyko pakeisti matomumo.')
);

const offerHasToHaveImages = SnackBar(
    content: Text('Privalote įkelti bent 1 nuotrauką.')
);