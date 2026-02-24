# 🛒 Sistema de Gestión de Almacén (Point of Sale - POS)

Sistema transaccional de punto de venta y control de inventario desarrollado en Java, enfocado en la optimización de recursos, seguridad de datos y persistencia relacional.

## 🚀 Arquitectura y Desafíos Técnicos Resueltos

A lo largo del desarrollo de este sistema, me enfoqué en aplicar buenas prácticas de arquitectura de software para resolver problemas del mundo real:

* **Optimización de Pool de Conexiones (Evitando Connection Leaks):** Se implementó el patrón de diseño **Singleton** para el manejo del `EntityManagerFactory` de Hibernate/JPA. Esto resolvió cuellos de botella y caídas del servidor generadas por la instanciación múltiple de conexiones.
* **Gestión de Estado Volátil (Sesiones):** La lógica del carrito de compras opera 100% en la memoria RAM (`HttpSession`). Esto evita consultas innecesarias (UPDATEs) a la base de datos por carritos abandonados o cancelados, impactando el stock real únicamente al concretar la transacción.
* **Validación Cruzada en Tiempo Real:** Algoritmo que contrasta el stock disponible en la base de datos con el estado temporal del carrito, previniendo la sobreventa (bug de carrito infinito).
* **Seguridad y Criptografía (BCrypt):** Implementación de hashing de contraseñas utilizando el algoritmo **BCrypt** para proteger las credenciales de los usuarios en la base de datos, garantizando un almacenamiento seguro.
* **Control de Acceso Basado en Roles (RBAC):** Sistema de seguridad a nivel de Servlets y JSP que restringe el acceso a las rutas según 3 niveles de privilegios:
    1. **Cajero:** Acceso exclusivo al módulo de ventas y cobro.
    2. **Supervisor:** Acceso a reportes financieros y gestión de stock.
    3. **Administrador de usuarios:** Panel de gestión de usuarios.
* **Cálculo Transaccional Dinámico:** Lógica financiera que aplica y desglosa automáticamente recargos de pasarelas de pago (ej. Mercado Pago) en la vista del cliente, manteniendo la ganancia neta intacta en la base de datos y reportes.

## 🛠️ Tecnologías Utilizadas

* **Backend:** Java, Servlets, JSP.
* **Persistencia:** Hibernate (JPA), MySQL.
* **Seguridad:** BCrypt (Password Hashing).
* **Frontend:** HTML5, CSS3, JavaScript.
* **Librerías / Herramientas:** Chart.js (Dashboards estadísticos dinámicos), Maven.

## 📊 Vistas y Módulos del Sistema

- **Módulo de Caja:** Interfaz ágil para escaneo/selección de productos, manejo de carrito en memoria temporal y cobro multimodal (Efectivo/QR).
- **Dashboard Gerencial:** Panel de control con KPI de ventas, recaudación y alertas automáticas de stock crítico.
- **Administración de Usuarios:** Panel CRUD para gestionar empleados, credenciales seguras y asignación de roles.
- **Reportes Dinámicos:** Gráficos de evolución de ventas históricas alimentados dinámicamente por la base de datos.