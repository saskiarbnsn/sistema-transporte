# Sistema de Gestión de Transporte Agropecuario

Trabajo final de la carrera **Analista de Sistemas de Computación**, Colegio Universitario IES Siglo 21, Córdoba, Argentina.

El proyecto parte del relevamiento de un caso real (Transportes Ceresoli, una empresa familiar de transporte del sur de Córdoba) y propone una aplicación web que reemplaza el registro manual en planillas de Excel por un sistema centralizado de gestión de viajes, choferes, camiones, clientes, destinos y gastos.

🔗 **Demo en vivo:** [sistema-transporte-f84o.onrender.com](https://sistema-transporte-f84o.onrender.com)  
Usuario: `admin@demo.com` · Contraseña: `demo123456`

## Contexto

Transportes Ceresoli opera con cuatro camiones y veinte clientes en la región. Al momento del relevamiento, en 2022, los pedidos se anotaban en una agenda, los viajes en planillas de Excel separadas por chofer, y las cartas de porte se confeccionaban a mano en triplicado. Obtener una estadística de rentabilidad por período requería un trabajo manual de consolidación que en la práctica nadie hacía. El pedido del propietario fue agilizar lo administrativo, limitar el uso de Excel y poder analizar el rendimiento del negocio con datos.

## Relevamiento y diagnóstico

El relevamiento incluyó entrevista al propietario, observación de procesos, levantamiento de cursogramas y elaboración del diagrama de clases y los casos de uso (todo documentado en el trabajo final académico). El diagnóstico fue que el sistema basado en planillas no escalaba con el crecimiento del negocio. La propuesta fue una aplicación web con módulos de gestión de datos (clientes, campos, choferes, camiones, destinos), gestión de viajes con cálculo automático de tarifa, neto e IVA, y módulo estadístico para análisis de rentabilidad.

## Stack tecnológico

El sistema se construyó con Ruby on Rails 7 y PostgreSQL como base de datos, siguiendo el patrón Modelo-Vista-Controlador. El frontend usa Bootstrap 5 para los componentes responsive y Hotwire (Turbo + Stimulus) para la interactividad sin necesidad de un frontend SPA aparte, lo que resultó adecuado para los formularios dinámicos del registro de viajes. La autenticación se resuelve con Devise, la geolocalización de campos y destinos con la API de Google Maps, y el servidor web es Puma. El desarrollo se hizo en Visual Studio Code con control de versiones en Git.

## Cómo correrlo localmente

Requisitos previos: Ruby 3.1.3, Bundler, Node.js 18 o superior, Yarn, PostgreSQL 14 o superior. Opcionalmente una API key de Google Maps; sin ella, la aplicación funciona igual y los campos de domicilio y ubicación quedan como inputs de texto donde se puede escribir libremente, pero no aparecen el mapa, las sugerencias de direcciones ni el cálculo automático de coordenadas.

```bash
git clone https://github.com/saskiarbnsn/sistema-transporte.git
cd sistema-transporte
bundle install
yarn install
cp .env.example .env   # editar con los valores locales
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed      # carga datos de demostración
bin/dev
```

La aplicación queda disponible en `http://localhost:3000`.

Las variables de entorno necesarias son `DB_USERNAME`, `DB_PASSWORD`, `DB_PORT`, `DEVISE_MAILER_SENDER`, `GOOGLE_MAPS_API_KEY` y `APP_HOST`. Un archivo `.env.example` puede servir de plantilla.

## Datos de demostración

El archivo `db/seeds.rb` carga una base de datos ficticia con clientes, campos, choferes, camiones, destinos y viajes, además de dos usuarios de prueba para acceder al sistema. Las credenciales quedan documentadas en el propio archivo de seeds y se imprimen en consola al ejecutar `bin/rails db:seed`.

Todos los datos del seed son inventados. No corresponden a personas, empresas, CUITs ni operaciones reales.
## Licencia

Código publicado bajo licencia MIT. Ver archivo `LICENSE` para los términos completos.
