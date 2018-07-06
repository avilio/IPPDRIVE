import 'package:flutter/material.dart';

import './src/blocs/login_provider.dart';
import './src/blocs/favorites_provider.dart';
import './src/blocs/home_provider.dart';
import './src/blocs/drawer_provider.dart';
import './src/ippDrive.dart';

void main() => runApp(
      DrawerProvider(
        child: FavoritesProvider(
          child: HomeProvider(
            child: LoginProvider(
              child:IppDrive(),
            ),
          ),
        ),
      ),
    );

