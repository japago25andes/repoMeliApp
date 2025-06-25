# Automatización de Búsqueda y Filtros en Mercado Libre (Android)

Este proyecto contiene un script de automatización en Ruby que utiliza el framework Appium para interactuar con la aplicación nativa de Mercado Libre en un dispositivo Android. El script simula el comportamiento de un usuario real para realizar una búsqueda de producto, aplicar una serie de filtros complejos y extraer información clave de los resultados.

## 📜 Descripción del Flujo

El script ejecuta la siguiente secuencia de acciones de forma autónoma:
1.  Inicia la aplicación de Mercado Libre en un dispositivo o emulador Android conectado.
2.  Ingresa a la aplicación como "visitante" para evitar el login.
3.  Realiza una búsqueda de un término predefinido (por defecto, "playstation 5").
4.  Abre el menú de filtros y lo navega de forma inteligente, haciendo scroll cuando los elementos no son visibles.
5.  Aplica secuencialmente tres filtros distintos:
    * **Condición:** Nuevo
    * **Retiro gratis:** Bogotá D.C.
    * **Ordenar por:** Mayor precio
6.  Confirma y aplica los filtros seleccionados.
7.  En la pantalla de resultados, recolecta los datos de los primeros 5 productos. Para ello, realiza scrolls verticales de forma eficiente, procesando todos los productos visibles en la pantalla antes de deslizar para buscar más.
8.  Imprime en la consola el título y el precio de cada uno de los 5 productos encontrados.
9.  Cierra la sesión del driver de forma segura, incluso si ocurre un error.

## ✨ Características Principales

-   **Robusto y Estable:** Diseñado para manejar las inestabilidades y cambios en la UI de la aplicación, utilizando esperas explícitas y una lógica de scroll resistente.
-   **Eficiente:** La recolección de datos en la pantalla de resultados está optimizada para minimizar los scrolls innecesarios, procesando primero todos los elementos visibles.
-   **Modular y Legible:** El código está organizado con funciones de ayuda claras, constantes para una fácil configuración y comentarios que explican la lógica.
-   **Manejo de Errores:** Incluye un bloque `rescue` general que captura cualquier error crítico, guarda una captura de pantalla para el diagnóstico y se asegura de que el driver se cierre correctamente.

## 🛠️ Prerrequisitos

Para ejecutar este script, necesitarás tener el siguiente software instalado y configurado en tu sistema:

1.  **Ruby:** Versión 3.0 o superior.
2.  **Bundler:** Para gestionar las dependencias de Ruby. (`gem install bundler`)
3.  **Node.js y npm:** Necesarios para instalar Appium y sus drivers.
4.  **Appium 2.x Server:** El servidor principal de automatización.
    -   Instalación global vía npm: `npm install -g appium`
5.  **Appium UiAutomator2 Driver:** El driver específico para la automatización de Android.
    -   Instalación vía Appium: `appium driver install uiautomator2`
6.  **Appium Doctor:** Una herramienta para verificar que toda tu configuración es correcta.
    -   Instalación global vía npm: `npm install -g appium-doctor`
7.  **Java JDK:** Versión 11 o superior. Asegúrate de tener la variable de entorno `JAVA_HOME` configurada.
8.  **Android SDK:** (Generalmente se instala con Android Studio). Asegúrate de tener `ANDROID_HOME` y otras variables de entorno configuradas (`platform-tools`, `cmdline-tools`, etc.).
9.  **Dispositivo Android Físico o Emulador:**
    -   Debe tener el modo de desarrollador y la depuración por USB habilitados.
    -   Debe estar conectado y ser visible al ejecutar `adb devices`.
10. **La aplicación de Mercado Libre:** El archivo APK debe estar instalado en el dispositivo/emulador.

## ⚙️ Instalación y Configuración del Proyecto

1.  **Clonar el Repositorio:**
    ```bash
    git clone https://github.com/japago25andes/repoMeliApp.git
    cd <NOMBRE_DEL_DIRECTORIO>
    ```

2.  **Crear el `Gemfile`:**
    Crea un archivo llamado `Gemfile` en la raíz del proyecto y añade el siguiente contenido:
    ```ruby
    source '[https://rubygems.org](https://rubygems.org)'

    gem 'appium_lib'
    ```

3.  **Instalar Dependencias de Ruby:**
    Ejecuta Bundler para instalar las gemas necesarias (en este caso, `appium_lib`).
    ```bash
    bundle install
    ```

4.  **Verificar la Configuración de Appium:**
    Ejecuta Appium Doctor para asegurarte de que tu entorno está listo. Deberías ver marcas de verificación verdes en todos los apartados necesarios.
    ```bash
    appium-doctor
    ```

## ▶️ Cómo Ejecutar la Prueba

1.  **Iniciar el Servidor de Appium:**
    Abre una terminal y ejecuta el siguiente comando. Déjala abierta durante toda la prueba.
    ```bash
    appium
    ```

2.  **Conectar tu Dispositivo Android:**
    Asegúrate de que tu dispositivo físico o emulador esté en ejecución y correctamente reconocido por ADB.
    ```bash
    adb devices
    ```
    Deberías ver tu dispositivo en la lista.

3.  **Ejecutar el Script de Ruby:**
    Abre una **segunda terminal**, navega a la carpeta del proyecto y ejecuta el script.
    ```bash
    ruby mercadolibre_search.rb
    ```

El script comenzará a ejecutarse en el dispositivo y verás los logs de progreso en la terminal.

## 🔧 Personalización

Puedes modificar fácilmente el comportamiento del script editando las constantes al principio del archivo `mercadolibre_search.rb`:

-   **Para buscar otro producto:**
    Cambia el valor de la constante `SEARCH_TERM`.
    ```ruby
    SEARCH_TERM = 'iphone 15 pro max'
    ```
-   **Para cambiar los filtros:**
    Modifica los valores de texto dentro del hash `LOCATORS`. Por ejemplo, para buscar en "Usado" en lugar de "Nuevo":
    ```ruby
    #...
    condition_filter: "//*[@text='Condición']",
    new_option: "//*[@text='Usado']", # Cambiado de 'Nuevo' a 'Usado'
    #...
    ```
