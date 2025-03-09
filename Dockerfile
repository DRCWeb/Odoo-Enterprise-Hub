# Imagen base de Odoo 15
ARG ODOO_VERSION=15.0
FROM odoo:${ODOO_VERSION}

# Cambiar a usuario root para instalación de paquetes
USER root

# Configurar variables
ENV OE_ADDONS_PATH="/mnt/enterprise"

# Actualizar repositorios e instalar dependencias necesarias
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Regresar a usuario Odoo para ejecución segura
USER odoo

# Agregar el token de GitHub para clonar Odoo Enterprise
ARG GH_PAT_ODDO
RUN git clone --branch ${ODOO_VERSION} --single-branch https://${GH_PAT_ODDO}@github.com/odoo/enterprise.git $OE_ADDONS_PATH

# Ajustar permisos de los módulos Enterprise
RUN chown -R odoo:odoo $OE_ADDONS_PATH

# Modificar configuración para incluir los módulos de Enterprise
RUN echo "addons_path = /mnt/enterprise, /usr/lib/python3/dist-packages/odoo/addons" >> /etc/odoo/odoo.conf

# Exponer el puerto de Odoo
EXPOSE 8069
