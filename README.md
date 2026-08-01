# Homelab Destroyer Dashboard

Panel estático, táctil y responsive para el homelab. Está diseñado para una pantalla de referencia de **1024×768** (con compatibilidad mínima a 800×600) y obtiene las métricas de Prometheus cada 15 segundos.

## Vistas

- **Inicio**: CPU, memoria y disco de `homelab-server`, más tarjetas de todos los nodos.
- **Servicios**: estado y latencia de monitores de Uptime Kuma expuestos en Prometheus.
- **Backups**: antigüedad y estado de repositorios.
- **Alertas**: alertas firing de Prometheus/Alertmanager.

## Requisitos

El servidor web debe exponer un proxy de solo lectura hacia Prometheus en:

```text
/api/prometheus/api/v1/query
```

La interfaz consulta métricas de Node Exporter, las reglas `homelab:*`, Uptime Kuma y `ALERTS` de Prometheus. No incluye credenciales, certificados ni configuración de producción.

## Despliegue

Publica el contenido de este repositorio como raíz de un virtual host HTTPS. Los recursos se sirven desde `/assets/`; Grafana puede mantenerse en `/grafana/` mediante el proxy que prefieras.

```nginx
location /api/prometheus/ {
    proxy_pass http://127.0.0.1:9090/;
}
```

## Personalización

- Ajusta nodos especiales y grupos de servicios en `assets/dashboard.js`.
- Ajusta colores, escalado y layout en `assets/dashboard.css`.
- Las fuentes JetBrains Mono se alojan localmente en `assets/` para que la pantalla no dependa de Internet.
