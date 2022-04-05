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