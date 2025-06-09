# Creado por secure_framework para centralizar la gestión de cabeceras de seguridad.

SecureHeaders::Configuration.default do |config|
  # Previene que el sitio sea cargado en un frame o iframe (protección contra Clickjacking).
  config.x_frame_options = "SAMEORIGIN"

  # Evita que el navegador intente adivinar el tipo de contenido (MIME-type sniffing).
  config.x_content_type_options = "nosniff"

  # Activa el filtro XSS de los navegadores.
  config.x_xss_protection = "1; mode=block"

  # Previene que navegadores como IE abran descargas directamente en el contexto del sitio.
  config.x_download_options = "noopen"

  # Restringe el permiso de Adobe Flash/Reader para acceder a datos entre dominios.
  config.x_permitted_cross_domain_policies = "none"

  # Define una política más estricta sobre la información enviada en la cabecera Referer.
  config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)

  # Desactivamos explícitamente la gestión de CSP en esta gema.
  # Esto previene cualquier conflicto con el inicializador nativo de Rails
  # (config/initializers/content_security_policy.rb) que es gestionado
  # por el método install_csp_and_configure del framework.
  config.csp = SecureHeaders::OPT_OUT

  # HTTP Strict Transport Security (HSTS)
  # Descomentar en producción para forzar conexiones HTTPS.
  # if Rails.env.production?
  #   config.strict_transport_security = "max-age=63072000; includeSubDomains"
  # end
end
