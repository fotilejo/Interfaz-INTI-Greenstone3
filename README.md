# Interfaz Gráfica - Repositorio Institucional INTI

Este repositorio contiene el código fuente de la interfaz gráfica personalizada para el **Repositorio Institucional del Instituto Nacional de Tecnología Industrial (INTI)**, basada en la plataforma **Greenstone 3**.

## Descripción

La interfaz, denominada `otra`, está diseñada para proveer una experiencia de usuario moderna, limpia y accesible para buscar, navegar y consultar publicaciones científicas, libros, artículos y documentos técnicos generados por los investigadores del INTI.

### Características Principales
* **Diseño Responsivo:** Adaptable a dispositivos móviles, tablets y pantallas de escritorio.
* **Componentes Modernos:** Uso de CSS moderno, flexbox y variables nativas para mantener consistencia visual (colores institucionales del INTI).
* **Integración con Greenstone 3:** Formato XSLT (`.xsl`) adaptado para inyectar metadatos dinámicos del repositorio.
* **Licencias Interactivas:** Transformación de metadatos de licencias (como Creative Commons) en botones interactivos (*badges*) legibles y atractivos.
* **SEO Optimizado:** Generación de etiquetas `<title>` dinámicas basadas en los metadatos de cada documento para mejorar la indexación en buscadores.

## Estructura del Proyecto

* `/styles`: Contiene las hojas de estilo modernas (`modern.css`, `fonts.css`, etc.)
* `/transform`: Archivos XSLT que determinan cómo Greenstone estructura el HTML (ej. `home.xsl`, `document.xsl`, `header.xsl`).
* `/js`: Scripts para funciones interactivas en la interfaz de usuario.
* `/images` y `/fonts`: Recursos gráficos e iconografía.

## Instalación y Despliegue

Esta carpeta debe colocarse dentro de la instalación de Greenstone 3, típicamente en:
`[directorio-greenstone3]/web/interfaces/otra`

Una vez actualizados los archivos, puede ser necesario limpiar la caché del navegador para que se apliquen las nuevas hojas de estilo y scripts.
