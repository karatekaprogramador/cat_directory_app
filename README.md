# Cat Directory App

Aplicación Flutter para explorar razas de gatos consumiendo la API pública de `catfact.ninja`.

## Objetivo

Construir un MVP con foco en:

- Arquitectura clara y escalable.
- Manejo de estado reactivo.
- Paginación con buen rendimiento.
- UX sólida ante fallos de red.

## Funcionalidades implementadas

- **Listado de razas** (`/breeds`) con:
  - Infinite scroll.
  - Pull to refresh.
  - Búsqueda local sobre elementos cargados en memoria.
- **Detalle de raza** con información completa:
  - Breed, Country, Origin, Coat, Pattern.
- **Dato curioso aleatorio** (`/fact`) en la vista de detalle con estado de carga independiente.
- **Tema claro/oscuro global** con switch en la pantalla principal.
  - Cambio aplicado a toda la app (estado global).
  - Compatible con tema del sistema.
- **Animación Hero** al navegar entre tarjeta de raza (lista) y encabezado del detalle.
- **Caché local de primera página** para apertura instantánea aun sin red:
  - Persistencia con `shared_preferences`.
  - Fallback a caché en errores de red de la primera carga.
- Manejo de errores con `SnackBar` y acciones de reintento.

## Stack técnico

- `flutter_bloc` para estado reactivo.
- `get_it` para inyección de dependencias.
- `dio` para consumo HTTP.
- `go_router` para enrutamiento.
- `freezed` + `json_serializable` para modelos inmutables y tipados.
- `shared_preferences` para persistencia de caché local.

## Arquitectura

Se utiliza enfoque **feature-first** con separación de responsabilidades.

```text
lib/
  app/
    app.dart
    app_router.dart
  core/
    di/
    network/
    theme/
  features/
    breeds/
      data/
      domain/
      presentation/
        cubit/
        pages/
    breed_detail/
      data/
      presentation/
        cubit/
        pages/
```

### Decisiones importantes

- `BreedsCubit` se usa en el listado para reducir boilerplate y mantener el flujo simple (inicio, scroll, refresh, búsqueda con debounce).
- `BreedDetailCubit` se mantiene para detalle porque el flujo es más simple y con menos boilerplate.
- `ThemeModeCubit` maneja el modo visual global (light/dark/system-friendly).
- `BreedsCacheService` persiste y recupera la primera página para mejorar tiempo de arranque percibido.
- La UI no contiene lógica de negocio ni llamadas HTTP directas.
- Repositorios encapsulan errores de red y retornan entidades tipadas.

## Cómo ejecutar el proyecto

### Requisitos

- Flutter SDK instalado.
- Dart SDK compatible (`sdk: ^3.11.1`).

### Pasos

```bash
flutter pub get
flutter run
```

## Pruebas

Se incluyen pruebas de widget y pruebas unitarias del `BreedsCubit`.

### Ejecutar pruebas

```bash
flutter test
```

### Casos unitarios cubiertos (BreedsCubit)

- Emisión de estados en carga inicial (`loading -> success`).
- Debounce de búsqueda.
- Control para ignorar `loadMore` duplicados en paralelo.

## Manejo de errores y UX

- Si falla la carga inicial, se muestra estado de error con botón de reintento.
- Si falla una página adicional del scroll, se conserva lo ya cargado y se notifica al usuario.
- Si falla el fact del detalle, se permite reintentar sin perder el resto del contenido.

## Nota de diseño

Se aplicó un estilo visual minimalista con paleta suave, priorizando legibilidad y limpieza visual para mantener una experiencia moderna y clara.
